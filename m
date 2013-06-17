Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3FQHAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:00:15 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57520 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3FQHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:00:13 -0400
Message-ID: <51BEB3F5.8070002@gmail.com>
Date: Mon, 17 Jun 2013 12:30:05 +0530
From: "Naveen N. Rao" <naveen.n.rao@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
CC: Borislav Petkov <bp@alien8.de>, "ananth@in.ibm.com" <ananth@in.ibm.com>,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Subject: Re: [PATCH] Re: [Patch] MCE, APEI: Don't enable CMCI when Firmware
 First mode is set in
References: <3908561D78D1C84285E8C5FCA982C28F2DA47F03@ORSMSX101.amr.corp.intel.com> <20130614181721.11206.95341.stgit@localhost.localdomain> <20130615144830.GA13310@pd.tnic>
In-Reply-To: <20130615144830.GA13310@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 08:18 PM, Borislav Petkov wrote:
> On Fri, Jun 14, 2013 at 11:47:21PM +0530, Naveen N. Rao wrote:
>> HEST for corrected machine checks
>>
>> Here's a patch that implements this technique. If the firmware advertises
>> support for firmware first mode in the CMC structure, we disable CMCI and
>> polling for all the MCA banks listed in the CMC structure.
>
> Yeah, this commit message needs a bit massaging. Don't be afraid to be
> more verbose than you feel is necessary. :-)

Yup, not to mention some stgit jitters with the subject ;)
I will re-write this.

>
>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> ---
>>   arch/x86/include/asm/mce.h             |    3 ++
>>   arch/x86/kernel/cpu/mcheck/mce_intel.c |   38 +++++++++++++++++++++++++++++++
>>   drivers/acpi/apei/hest.c               |   39 ++++++++++++++++++++++++++++++++
>>   3 files changed, 80 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
>> index fa5f71e..9c91683 100644
>> --- a/arch/x86/include/asm/mce.h
>> +++ b/arch/x86/include/asm/mce.h
>> @@ -188,6 +188,9 @@ extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
>>   				    const char __user *ubuf,
>>   				    size_t usize, loff_t *off));
>>
>> +/* Disable CMCI/polling for MCA bank claimed by firmware */
>> +extern void mce_disable_bank(int bank);
>> +
>>   /*
>>    * Exception handler
>>    */
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> index ae1697c..bc0307d 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> @@ -26,6 +26,9 @@
>>
>>   static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
>>
>> +/* MCA banks controlled through firmware first */
>> +static mce_banks_t mce_banks_disabled;
>> +
>>   /*
>>    * cmci_discover_lock protects against parallel discovery attempts
>>    * which could race against each other.
>> @@ -191,6 +194,10 @@ static void cmci_discover(int banks)
>>   		if (test_bit(i, owned))
>>   			continue;
>>
>> +		/* Skip banks in firmware first mode */
>> +		if (test_bit(i, mce_banks_disabled))
>> +			continue;
>> +
>>   		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
>>
>>   		/* Already owned by someone else? */
>> @@ -315,6 +322,37 @@ void cmci_reenable(void)
>>   		cmci_discover(banks);
>>   }
>>
>> +static void cmci_disable_bank(void *arg)
>> +{
>> +	int banks;
>> +	unsigned long flags;
>> +	u64 val;
>> +	int bank = *((int *)arg);
>> +
>> +	/* Ensure we don't poll this bank */
>> +	__clear_bit(bank, __get_cpu_var(mce_poll_banks));
>> +
>> +	if (!cmci_supported(&banks))
>> +		return;
>
> Hmm, so if CMCI is not supported, you just disabled polling of this bank
> and returned here. Not good.

This is on purpose. If the bank doesn't support CMCI and we were polling 
it earlier, we want to disable that. The firmware should be notifying us 
of error events in either case.

>
>> +
>> +	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
>> +
>> +	/* Disable CMCI */
>> +	rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
>> +	val &= ~MCI_CTL2_CMCI_EN;
>> +	wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
>> +
>> +	__clear_bit(bank, __get_cpu_var(mce_banks_owned));
>> +
>> +	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
>
> Almost the exact sequence is also in cmci_clear(). How about a static
> function called __cmci_disable_bank which does that and the other
> functions call it?

Ok, will do.

>
>> +}
>> +
>> +void mce_disable_bank(int bank)
>> +{
>> +	set_bit(bank, mce_banks_disabled);
>> +	on_each_cpu(cmci_disable_bank, &bank, 1);
>> +}
>> +
>>   static void intel_init_cmci(void)
>>   {
>>   	int banks;
>> diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
>> index f5ef5d5..765d8bf 100644
>> --- a/drivers/acpi/apei/hest.c
>> +++ b/drivers/acpi/apei/hest.c
>> @@ -36,6 +36,7 @@
>>   #include <linux/io.h>
>>   #include <linux/platform_device.h>
>>   #include <acpi/apei.h>
>> +#include <asm/mce.h>
>>
>>   #include "apei-internal.h"
>>
>> @@ -121,6 +122,42 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
>>   }
>>   EXPORT_SYMBOL_GPL(apei_hest_parse);
>>
>> +/*
>> + * Check if firmware advertises firmware first mode. We need FF bit to be set
>> + * along with a set of MC banks which work in FF mode.
>> + */
>> +static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
>> +{
>> +	int i;
>> +	struct acpi_hest_ia_corrected *cmc;
>> +	struct acpi_hest_ia_error_bank *mc_bank;
>> +
>> +	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
>> +		return 0;
>> +
>> +	if (!((struct acpi_hest_generic *)hest_hdr)->enabled)
>> +		return 0;
>> +
>> +	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
>
> There is some crazy casting going on here: hest_hdr can be struct
> acpi_hest_generic and struct acpi_hest_ia_corrected.
>
> Since the ->enabled field overlaps in both structs and you want only it
> as a struct acpi_hest_generic, and want the cmc later, why don't you do
> this:
>
> 	struct acpi_hest_ia_corrected *cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
>
> 	if (!cmc->enabled)
> 		...
>
> Then this below:
>
>> +	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST))
>> +		return 0;
>
> and so on... It should simplify the code a bit and drop the fun games
> with casting.

Nice catch. I will simplify this.

>
>> +
>> +	/*
>> +	 * We expect HEST to provide a list of MC banks that
>> +	 * report errors through firmware first mode.
>> +	 */
>> +	if (cmc->num_hardware_banks <= 0)
>
> ->num_hardware_banks is unsigned char, so "== 0"

Ok.

>
>> +		return 0;
>> +
>> +	pr_info("HEST: Enabling Firmware First mode for corrected errors\n");
>
> 	pr_info(HEST_PFX "Enabling..." (fullstop at the end of the sentence).

Ok. Changed.

>
> Btw, this hest.c could use the standard pr_fmt mechanism.
>
>> +
>> +	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
>> +	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
>> +		mce_disable_bank(mc_bank->bank_number);
>> +
>> +	return 0;
>> +}
>> +
>>   struct ghes_arr {
>>   	struct platform_device **ghes_devs;
>>   	unsigned int count;
>> @@ -227,6 +264,8 @@ void __init acpi_hest_init(void)
>>   		goto err;
>>   	}
>>
>> +	apei_hest_parse(hest_parse_cmc, NULL);
>> +
>>   	if (!ghes_disable) {
>>   		rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
>>   		if (rc)
>
> Thanks.
>

Thanks,
Naveen

