Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3L3O7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:59:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab3L3O7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:59:04 -0500
Message-ID: <52C18A23.10703@redhat.com>
Date: Mon, 30 Dec 2013 15:58:43 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Gleb Natapov <gleb@kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <231382870.yshsPRR4KM@vostro.rjw.lan> <52C011A2.3040800@redhat.com> <4794554.Hmd2RUNYDT@vostro.rjw.lan>
In-Reply-To: <4794554.Hmd2RUNYDT@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2013 04:04 PM, Rafael J. Wysocki wrote:
> On Sunday, December 29, 2013 01:12:18 PM Kashyap Chamarthy wrote:
>> [. . .]
>>
>>>> Here's host dmesg: https://bugzilla.kernel.org/attachment.cgi?id=119751
>>>>
>>>>>> Can you ftrace the failure?
>>>>
>>>> Can try, need some time (rest of the day I'll be away travelling,
>>>> will try to do it over the weekend, and update the Kernel
>>>> bugzilla with observations).
>>>>
>>>>>>
>>>>> Ugh, it looks like guest dmesg but there are KVM messages there too ("[
>>>>> 281.443662] kvm [2452]: vcpu0 unhandled rdmsr: 0xe8" is unhandled access
>>>>> to MSR_IA32_APERF I was talking about above), so I guess this is nested
>>>>> guest invocation? 
>>>>
>>>> Yeah -- sorry, I forgot to note it's in a nested environment :(
>>>>
>>>>> Does it happen in non nested guest?
>>>>
>>>> I need to that.
>>>>
>>>> Note to self: Also try with a newer Kernel on the host.
>>>
>>> Please try the patch I posted earlier today when you're at it:
>>>
>>> https://patchwork.kernel.org/patch/3411991/
>>
>> I applied the patch & tried to build the Kernel, it failed with:
>>
>> =======
>> .
>> .
>> .
>> Generating a 4096 bit RSA private key
>> ............................................................................................................drivers/cpufreq/intel_pstate.c:
>> In function 'intel_pstate_init_cpu':
>> drivers/cpufreq/intel_pstate.c:617:18: error: 'struct pstate_data' has no member named
>> 'current_state'
>>   if (!cpu->pstate.current_state) {
> 
> My bad, that should have been current_pstate.  Updated patch is appended.
> 
> Thanks,
> Rafael
> 
> 
> ---
>  drivers/cpufreq/intel_pstate.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-pm/drivers/cpufreq/intel_pstate.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/intel_pstate.c
> +++ linux-pm/drivers/cpufreq/intel_pstate.c
> @@ -614,6 +614,11 @@ static int intel_pstate_init_cpu(unsigne
>  	cpu = all_cpu_data[cpunum];
>  
>  	intel_pstate_get_cpu_pstates(cpu);
> +	if (!cpu->pstate.current_pstate) {
> +		all_cpu_data[cpunum] = NULL;
> +		kfree(cpu);
> +		return -ENODATA;
> +	}
>  
>  	cpu->cpu = cpunum;
>  
> 


Thanks Rafel, I can confirm this patch helps.

I re-built the Kernel on L0 (physical host) and L1 (guest hypervisor) with
the above patch, and re-ran the libguestfs test (which invokes an L2 appliance),
it now successfully completes:

   http://kashyapc.fedorapeople.org/temp/libguestfs-test-tool-stdout.txt


Here's a Fedora Kernel scratch build (not retained for more than 2 weeks)
with the above patch I used -- http://koji.fedoraproject.org/koji/taskinfo?taskID=6342414



-- 
/kashyap
