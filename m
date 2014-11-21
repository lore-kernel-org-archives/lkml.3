Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbaKUDHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 22:07:24 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:47028 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbaKUDHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 22:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141120132317.00ad7210@kcaccard-desk.amr.corp.intel.com>
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>
	<1416299826-15813-8-git-send-email-ethan.zhao@oracle.com>
	<20141119110548.24a0a808@kcaccard-desk.amr.corp.intel.com>
	<41ADCDB8-C204-4661-833B-F68E7D687B61@gmail.com>
	<20141120132317.00ad7210@kcaccard-desk.amr.corp.intel.com>
Date: Fri, 21 Nov 2014 11:07:19 +0800
Message-ID: <CABawtvO57bTEs2qCd1SRaOX-R24_VJYmHFLAoUatTRnmuenrdg@mail.gmail.com>
Subject: Re: [PATCH 3/3] intel_pstate: add module and kernel command line
 parameter to ignore ACPI _PPC
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        "<dirk.j.brandewie@intel.com>" <dirk.j.brandewie@intel.com>,
        "<viresh.kumar@linaro.org>" <viresh.kumar@linaro.org>,
        "<rjw@rjwysocki.net>" <rjw@rjwysocki.net>,
        "<corbet@lwn.net>" <corbet@lwn.net>,
        "<linux-doc@vger.kernel.org>" <linux-doc@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-pm@vger.kernel.org>" <linux-pm@vger.kernel.org>,
        "<joe.jin@oracle.com>" <joe.jin@oracle.com>,
        "<brian.maly@oracle.com>" <brian.maly@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen,
   Whatever I would like there is a way to load intel_pstate and give
it a try even it does not support all the PM features.
   I think 'force' is OK.
Linda,
  Do you like it ? if the 'intel_pstate=force' would force the driver
to be loaded on to HP too ?

Thanks,
Ethan

On Fri, Nov 21, 2014 at 5:23 AM, Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
> On Thu, 20 Nov 2014 08:57:34 +0800
> ethan <ethan.kernel@gmail.com> wrote:
>
>>
>>
>> > 在 2014年11月20日，03:05，Kristen Carlson Accardi <kristen@linux.intel.com> 写道：
>> >
>> > On Tue, 18 Nov 2014 17:37:06 +0900
>> > Ethan Zhao <ethan.zhao@oracle.com> wrote:
>> >
>> >> Add kernel command line parameter
>> >> intel_pstate = ignore_acpi_ppc
>> >> and module parameter
>> >> ignore_acpi_ppc = 1
>> >> to allow driver to ignore the ACPI _PPC existence even for Sun x86 servers.
>> >> These parameter could be used for debug\test\workaround etc purpose.
>> >>
>> >> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> >
>> > What if we used a more generic parameter like "force" that would bypass
>> > any vendor specific checks and just load anyway?  This way we don't have
>> > to add new parameters everything some new thing shows up that we want to
>> > ignore.
>> >
>> To be honest, I prefer more generic parameter. But to avoid the possible negative affect
>> To another vendors. I back to this way.
>
> Well, your parameter can still impact other vendors as it is.  it
> is pretty typical to assume that using a parameter like "force" means
> you know what you are doing and accept the risks.  Especially if its
> documented as such.
>
>>
>> Thanks,
>> Ethan
>> >> ---
>> >> Documentation/kernel-parameters.txt | 3 +++
>> >> drivers/cpufreq/intel_pstate.c      | 8 +++++++-
>> >> 2 files changed, 10 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> >> index 4c81a86..f502b85 100644
>> >> --- a/Documentation/kernel-parameters.txt
>> >> +++ b/Documentation/kernel-parameters.txt
>> >> @@ -1446,6 +1446,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>> >>               disable
>> >>                 Do not enable intel_pstate as the default
>> >>                 scaling driver for the supported processors
>> >> +               ignore_acpi_ppc
>> >> +             Ignore the existence of ACPI method _PPC for Sun x86 servers
>> >> +             and load the driver.
>> >>
>> >>    intremap=    [X86-64, Intel-IOMMU]
>> >>            on    enable Interrupt Remapping (default)
>> >> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> >> index 7c5faea..388387b 100644
>> >> --- a/drivers/cpufreq/intel_pstate.c
>> >> +++ b/drivers/cpufreq/intel_pstate.c
>> >> @@ -870,6 +870,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>> >> };
>> >>
>> >> static int __initdata no_load;
>> >> +static unsigned int  ignore_acpi_ppc;
>> >>
>> >> static int intel_pstate_msrs_not_valid(void)
>> >> {
>> >> @@ -990,7 +991,7 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>> >>            intel_pstate_no_acpi_pss())
>> >>            return true;
>> >>        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>> >> -            intel_pstate_has_acpi_ppc())
>> >> +            intel_pstate_has_acpi_ppc() && !ignore_acpi_ppc)
>> >>            return true;
>> >>    }
>> >>
>> >> @@ -1066,11 +1067,16 @@ static int __init intel_pstate_setup(char *str)
>> >>
>> >>    if (!strcmp(str, "disable"))
>> >>        no_load = 1;
>> >> +    if (!strcmp(str, "ignore_acpi_ppc"))
>> >> +        ignore_acpi_ppc = 1;
>> >>    return 0;
>> >> }
>> >> early_param("intel_pstate", intel_pstate_setup);
>> >> #endif
>> >>
>> >> +module_param(ignore_acpi_ppc, uint, 0644);
>> >> +MODULE_PARM_DESC(ignore_acpi_ppc,
>> >> +    "value 0 or non-zero. non-zero -> ignore ACPI _PPC and load this driver");
>> >> MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
>> >> MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");
>> >> MODULE_LICENSE("GPL");
>> >
>
