Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaHSIeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:34:08 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52081 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaHSIeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:34:03 -0400
Message-ID: <53F30B99.4000704@linaro.org>
Date: Tue, 19 Aug 2014 16:32:25 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v2 08/18] ARM64 / ACPI: Get the enable method for SMP
 initialization in ACPI way
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-9-git-send-email-hanjun.guo@linaro.org> <20140818142733.GT20043@localhost>
In-Reply-To: <20140818142733.GT20043@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-18 22:27, Catalin Marinas wrote:
> On Mon, Aug 04, 2014 at 04:28:15PM +0100, Hanjun Guo wrote:
>> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
>> index e877967..022f4ad 100644
>> --- a/arch/arm64/include/asm/acpi.h
>> +++ b/arch/arm64/include/asm/acpi.h
>> @@ -14,6 +14,27 @@
>>  
>>  /* Basic configuration for ACPI */
>>  #ifdef	CONFIG_ACPI
>> +/*
>> + * ACPI 5.1 only has two explicit methods to
>> + * boot up SMP, PSCI and Parking protocol,
>> + * but the Parking protocol is only defined
>> + * for ARMv7 now, so make PSCI as the only
>> + * way for the SMP boot protocol before some
>> + * updates for the ACPI spec or the Parking
>> + * protocol spec.
>> + *
>> + * This enum is intend to make the boot method
>> + * scalable when above updates are happended,
>> + * which NOT means to support all of them.
>> + */
>> +enum acpi_smp_boot_protocol {
>> +	ACPI_SMP_BOOT_PSCI,
>> +	ACPI_SMP_BOOT_PARKING_PROTOCOL,
>> +	ACPI_SMP_BOOT_PROTOCOL_MAX
>> +};
>> +
>> +enum acpi_smp_boot_protocol smp_boot_protocol(void);
> 
> Since this is not a static function and ACPI-specific, could you prefix
> it with something like acpi (or arm64_acpi_ unless it gets too long)?
> 
>> diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
>> index d62d12f..05bc314 100644
>> --- a/arch/arm64/kernel/cpu_ops.c
>> +++ b/arch/arm64/kernel/cpu_ops.c
>> @@ -16,11 +16,13 @@
>>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>   */
>>  
>> -#include <asm/cpu_ops.h>
>> -#include <asm/smp_plat.h>
>>  #include <linux/errno.h>
>>  #include <linux/of.h>
>>  #include <linux/string.h>
>> +#include <linux/acpi.h>
>> +
>> +#include <asm/cpu_ops.h>
>> +#include <asm/smp_plat.h>
>>  
>>  extern const struct cpu_operations smp_spin_table_ops;
>>  extern const struct cpu_operations cpu_psci_ops;
>> @@ -49,12 +51,44 @@ static const struct cpu_operations * __init cpu_get_ops(const char *name)
>>  	return NULL;
>>  }
>>  
>> +#ifdef CONFIG_ACPI
>> +/*
>> + * Get a cpu's boot method in the ACPI way.
>> + */
>> +static char * __init acpi_get_cpu_boot_method(void)
>> +{
>> +	/*
>> +	 * For ACPI 5.1, only two kind of methods are provided,
>> +	 * Parking protocol and PSCI, but Parking protocol is
>> +	 * specified for ARMv7 only, so make PSCI as the only method
>> +	 * for SMP initialization before the ACPI spec or Parking
>> +	 * protocol spec is updated.
>> +	 */
>> +	switch (smp_boot_protocol()) {
>> +	case ACPI_SMP_BOOT_PSCI:
>> +		return "psci";
>> +	case ACPI_SMP_BOOT_PARKING_PROTOCOL:
>> +	default:
>> +		return NULL;
>> +	}
>> +}
> 
> Actually, do we even need to define smp_boot_protocol()? Is it used
> anywhere else apart from this patch (I still haven't gone through all
> patches)?

It is just used in this patch. I think we can make the ACPI boot protocol
scalable in this way, if we support another boot protocol in ACPI in the
future, we can easily update the function to support it, does it make sense?

> 
>> +#else
>> +static inline char * __init acpi_get_cpu_boot_method(void) { return NULL; }
>> +#endif
>> +
>>  /*
>> - * Read a cpu's enable method from the device tree and record it in cpu_ops.
>> + * Read a cpu's enable method and record it in cpu_ops.
>>   */
>>  int __init cpu_read_ops(struct device_node *dn, int cpu)
>>  {
>> -	const char *enable_method = of_get_property(dn, "enable-method", NULL);
>> +	const char *enable_method;
>> +
>> +	if (!acpi_disabled) {
>> +		enable_method = acpi_get_cpu_boot_method();
>> +		goto get_ops;
> 
> Are we always guaranteed an enable_method here? You should have an
> if/else of ACPI vs DT and keep the if (!enable_method) check for both
> cases.

ok, I will fix it.

Thanks
Hanjun

