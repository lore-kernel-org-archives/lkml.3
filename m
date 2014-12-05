Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaLEE5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:57:05 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55603 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaLEE47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:56:59 -0500
Message-ID: <54813B17.8010509@hp.com>
Date: Thu, 04 Dec 2014 23:56:55 -0500
From: Linda Knippers <linda.knippers@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: ethan zhao <ethan.zhao@oracle.com>
CC: Kristen Carlson Accardi <kristen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, dirk.j.brandewie@intel.com,
        viresh.kumar@linaro.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 2/2 V7] intel_pstate: add kernel parameter to force loading
 on Sun X86 servers.
References: <1417658851-8729-1-git-send-email-ethan.zhao@oracle.com>	<22893638.NKVNYzPHrg@vostro.rjw.lan> <20141204143853.1adf98d8@kcaccard-desk.amr.corp.intel.com> <5480E829.2020805@hp.com> <548128C0.9020006@oracle.com>
In-Reply-To: <548128C0.9020006@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ethan,

On 12/4/2014 10:38 PM, ethan zhao wrote:
> Linda,
> 
> On 2014/12/5 7:03, Linda Knippers wrote:
>> On 12/4/2014 5:38 PM, Kristen Carlson Accardi wrote:
>>> On Thu, 04 Dec 2014 23:10:58 +0100
>>> "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
>>>
>>>> On Thursday, December 04, 2014 11:07:31 AM Ethan Zhao wrote:
>>>>> To force loading on Oracle Sun X86 servers, provide one kernel command line
>>>>> parameter
>>>>>
>>>>>    intel_pstate = ora_force
>>>> I would suggest to change the name of the option to "oracle_force" or
>>>> "sun_force"
>>>> for clarity.
>>>>
>>>> Anyway, I need an ACK from Kristen if this patch is to be applied.
>>>>
>>>>> For those who be aware of the risk of no power capping capabily working and
>>>>> try to get better performance with this driver.
>>>>>
>>>>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>>>>> ---
>>>>>   v2: change to hardware vendor specific naming parameter.
>>>>>   v4: refine code and doc.
>>>>>   v5&v6: fix a typo in doc.
>>>>>   v7: change enum PCC to PPC.
>>>>>
>>>>>   Documentation/kernel-parameters.txt | 5 +++++
>>>>>   drivers/cpufreq/intel_pstate.c      | 6 +++++-
>>>>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/kernel-parameters.txt
>>>>> b/Documentation/kernel-parameters.txt
>>>>> index 479f332..7d0983e 100644
>>>>> --- a/Documentation/kernel-parameters.txt
>>>>> +++ b/Documentation/kernel-parameters.txt
>>>>> @@ -1446,6 +1446,11 @@ bytes respectively. Such letter suffixes can also be
>>>>> entirely omitted.
>>>>>                  disable
>>>>>                    Do not enable intel_pstate as the default
>>>>>                    scaling driver for the supported processors
>>>>> +               ora_force
>>>>> +             Force loading intel_pstate on Oracle Sun Servers(X86).
>>>>> +             only for those who be aware of the risk of no power capping
>>>>> +             capability working and try to get better performance with this
>>>>> +             driver.
>>>> That is not sufficiently clear.  What does "risk of no power capping capability
>>>> working" mean, in particular?
>>>>
>>>>>         intremap=    [X86-64, Intel-IOMMU]
>>>>>               on    enable Interrupt Remapping (default)
>>>>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>>>>> index 1bb62ca..2654e13 100644
>>>>> --- a/drivers/cpufreq/intel_pstate.c
>>>>> +++ b/drivers/cpufreq/intel_pstate.c
>>>>> @@ -866,6 +866,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>>>>>   };
>>>>>     static int __initdata no_load;
>>>>> +static unsigned int  ora_force;
>>>>>     static int intel_pstate_msrs_not_valid(void)
>>>>>   {
>>>>> @@ -1003,7 +1004,8 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>>>>>               case PSS:
>>>>>                   return intel_pstate_no_acpi_pss();
>>>>>               case PPC:
>>>>> -                return intel_pstate_has_acpi_ppc();
>>>>> +                return intel_pstate_has_acpi_ppc() &&
>>>>> +                    (!ora_force);
>>>>>               }
>>>>>       }
>>>>>   @@ -1078,6 +1080,8 @@ static int __init intel_pstate_setup(char *str)
>>>>>         if (!strcmp(str, "disable"))
>>>>>           no_load = 1;
>>>>> +    if (!strcmp(str, "ora_force"))
>>>>> +        ora_force = 1;
>>>>>       return 0;
>>>>>   }
>>>>>   early_param("intel_pstate", intel_pstate_setup);
>>>> And can anyone please remind me what was wrong with a "force" option that would
>>>> work for everyone, not just Oracle/Sun?
>>>>
>>> That was my suggestion as well (i.e. a parameter to bypass the vendor
>>> checks), but Linda didn't like it.  My personal opinion is that unless
>>> it's generic, I don't really feel like having a force option solely for
>>> oracle.  I'm not convinced you want this for production machines, and I
>>> think for debug purposes I don't want a vendor specific param.
>> I'd be happy with it if it somehow disabled what the platform is doing,
>> but it doesn't.  I don't see the point of forcing intel_pstate if you
>> can't force the platform to stop doing power management at the same time.
>> Even if it's for test/debug purposes, I'm not sure what you're testing
>> when you have dueling power management.
>   Most of the power management functions is done by SP(service processor) on Sun
> X86
>   servers, the 'force' parameter is not supposed to disable whole platform
> working I think,
>   with intel_pstate,  it doesn't do CPU power capping issued via _PPC
> notification. but all
>  other rest parts of the power management still work. There is no scene as HP
> proliant OS
>  mode that OS could control everything(sorry, I don't know Proliant Architecture).
> 
>  So at least, it doesn't make sense to Oracle Sun X86 servers, provide an OS
> option to stop
>  all PM functions even disable ACPI at all.
> 
>  If the users could be aware of that the power capping doesn't work with CPUs.
> they could
>  load intel_pstate driver, though there may be faulty in SP . they still could
> monitor and
>  manage the power consumption of other parts in the server.
> 
>  Perhaps this is what we would test/have tested with intel_pstate.
> 
>  There is a public manual about PM command in Sun server SP may could help you
> to understand
>  the  difference.
>  https://docs.oracle.com/cd/E19121-01/sf.x4150/820-6412-12/820-6412-12.pdf

I've tried to put the pieces together so tell me if I've got this right.
Under normal circumstances, the Oracle platform wants the OS to do normal
power management (p-state and c-state management) using the ACPI information
that the firmware provides.  The firwmare or SP will potentially change the
ACPI information on the fly for things like power capping.  So normally, you
would want the acpi_cpufreq driver.  If the intel_pstate driver is loaded,
then that's going to disregard the ACPI information, uncluding the changes
that the firmware or SP may make when power capping.  There is no case where
the firmware or SP will try to manage pstates or cstates itself. Is that right?

If that's right, then I can see how the force option could make sense for
your platforms.  Sorry it took me so long to get this part.

HP platforms are different.  On our platforms, the platform is configurable
and customers can choose to have the firmware manage p-states, in which case
the pcc_cpufreq driver will be loaded to allow the OS to provide hints, or
to have the OS provide manage p-states, in which case the intel-pstate
driver will be loaded.  In our case, forcing the intel-pstate driver if
the platform is configured to have the firmware manage the p-states means
that both are trying to manage the power.  I don't think that ever makes
sense.  If the admin wants intel-pstate, its easy to configure the platform
through the iLO or the BIOS/UEFI setup so that the OS manages the p-states.

If the force option only works if the platform exposes _PPC, then it would
work with Oracle platforms and not work with HP platforms.  That gives us
what we want and is also note necessarily vendor specific.  And the good
news is that's actually how your recent patches work.

If the description said something about forcing the intel-pstate driver in
place of the acpi_cpufreq driver, assuming the processor is supported by
the intel-pstate driver, then I think we're good with a generic sounding
boot option.  It should also be clear that someone using force would
not get the intel-pstate driver on older processors.  There's no way
to force that.  And you could put in whatever warnings you want about
other features, such as power capping, potentially being disabled if
the force option is used.

Does this make sense to everyone?  It finally does to me. :-)

-- ljk



>>
>> The description would need to be different too since I think on
>> ProLiant, power capping can happen at any time, even if the
>> system is in OS control mode and the intel_pstate driver is
>> loaded.
>   Does that mean only the CPU power capping not work ? If so, they work the same
> way.
>>
>> Can anyone suggest a description for a force option that would
>> make sense generically?
>   the 'force' option means CPU power capping (frequency limited) not work to all,
>   right ?
> 
>  Thanks,
>  Ethan
>>
>> -- ljk
>>
>>
>>
> 

