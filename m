Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3LICWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:22:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab3LICWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:22:31 -0500
X-IronPort-AV: E=Sophos;i="4.93,854,1378828800"; 
   d="scan'208";a="9218577"
Message-ID: <52A5DFC9.6020105@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 10:20:41 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net>
In-Reply-To: <20131206115627.GA2279@ghostprotocols.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 10:22:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 10:22:14,
	Serialize complete at 2013/12/09 10:22:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and David.....

On 12/06/2013 06:56 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 06, 2013 at 04:33:08PM -0500, Dongsheng Yang escreveu:
>> Currently, if we use perf kvm --guestkallsyms --guestmodules report,
>> we can not get the perf information from perf data file. The all sample
>> are shown as unknown.
>>
>> Reproducing steps:
>> 	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules record -a sleep 1
>> 	[ perf record: Woken up 1 times to write data ]
>> 	[ perf record: Captured and wrote 0.624 MB perf.data.guest (~27260 samples) ]
>> 	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules report |grep %
>> 	   100.00%  [guest/6471]  [unknown]         [g] 0xffffffff8164f330
>>
>> This bug is caused when delivery sample. We use perf_session__find_machine_for_cpumode() to find
>> the machine, and it call perf_session__findnew_machine(). Then we will delivery the sample to a
>> new machine without kernel mapped.
>>
>> This patch changes perf_session__findnew_machine() to perf_session__find_machine(), so the sample
>> will be deliveried to default guest machine if there is no machine specified for it.
> Ok, but then we will use the provided guest modules, etc for _all_ VMs,
> irrespective of its pid, which sounds risky, no?

Yes, it is risky.

As my guess, the intention of default guest was to take care of the symbols
which are out of existing guest machines. It means when we have no guest 
specified for a
symbol, it will be delivered to default guest, right? Otherwise, I can 
not understand what
the default guest is used for.

But, yes, this design is really really risky. And I think it is time to 
do some change for it.
How about introduce an option named --guestpid? Then we can make the 
usage of perf kvm
more clear:
     * perf kvm --guestkallsyms --guestmodules --guestpid 
[top|record|report]
         This usage is for only one guest and will not resolve the 
symbols from other guests.
     * perf kvm --guestmount [top|record|report]
         This usage is for one or more guest. But you have to use sshfs 
to mount the guestfs on host.

This way, 1st usage is limited for one guest (actually, it is for only 
one guest currently and insidiously),
user will get a clear result as the wish. Then the 1st usage is a 
shortcut of usage 2 as David said.

Comments?


- Yang
>
> You get correct results because the modules/kallsyms info you provided
> matches the VM you're testing, i.e. the pid test is not needed.
>
> I think we need to specify for which PID the --guestmodules and
> --guestkallsyms is provided, so that it can refuse to use it for pids
> where it is invalid.
>
> If we do that then the current code will find it with
> perf_session__find_machine_for_cpumode(), and when not finding it, it
> will behave as expected and as it does today: refuse to resolve symbols
> using invalid kallsyms/modules.
>
> One way to achieve this automagically would be to have the build-id of
> the guest kernel and modules be present on the PERF_RECORD_MMAP, so that
> we wouldn't need to provide --guest{kallsyms,modules} as it would look
> it up (kallsyms or vmlinux) in the ~/.debug or elsewhere, like in
> /usr/lib/debug/lib/modules/3.11.4-101.fc18.x86_64/vmlinux (where
> kernel-debuginfo packages install its contents.
>
> Untill we have that, we need to at least document this limitation, i.e.
> that great care must be taken to provide exactly the kallsyms/modules
> pair to 'perf kvm', otherwise bogus results will be presented.
>
> - Arnaldo
>   
>> Verify steps:
>> 	# ./perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules record -a sleep 1
>> 	[ perf record: Woken up 1 times to write data ]
>> 	[ perf record: Captured and wrote 0.651 MB perf.data.guest (~28437 samples) ]
>> 	# ./perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules report |grep %
>> 	    22.64%    :6471  [guest.kernel.kallsyms]  [g] update_rq_clock.part.70
>> 	    19.99%    :6471  [guest.kernel.kallsyms]  [g] d_free
>> 	    18.46%    :6471  [guest.kernel.kallsyms]  [g] bio_phys_segments
>> 	    16.25%    :6471  [guest.kernel.kallsyms]  [g] dequeue_task
>> 	    12.78%    :6471  [guest.kernel.kallsyms]  [g] __switch_to
>> 	     7.91%    :6471  [guest.kernel.kallsyms]  [g] scheduler_tick
>> 	     1.75%    :6471  [guest.kernel.kallsyms]  [g] native_apic_mem_write
>> 	     0.21%    :6471  [guest.kernel.kallsyms]  [g] apic_timer_interrupt
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   tools/perf/util/session.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 8a7da6f..1770f2f 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -851,6 +851,7 @@ static struct machine *
>>   					       struct perf_sample *sample)
>>   {
>>   	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>> +	struct machine *machine;
>>   
>>   	if (perf_guest &&
>>   	    ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
>> @@ -863,7 +864,11 @@ static struct machine *
>>   		else
>>   			pid = sample->pid;
>>   
>> -		return perf_session__findnew_machine(session, pid);
>> +		machine = perf_session__find_machine(session, pid);
>> +		if (!machine)
>> +			machine = perf_session__findnew_machine(session,
>> +						DEFAULT_GUEST_KERNEL_ID);
>> +		return machine;
>>   	}
>>   
>>   	return &session->machines.host;
>> -- 
>> 1.8.2.1

