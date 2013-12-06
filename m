Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3LFL4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:56:37 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:62608 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab3LFL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:56:35 -0500
Date: Fri, 6 Dec 2013 08:56:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without
 guestmount.
Message-ID: <20131206115627.GA2279@ghostprotocols.net>
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 06, 2013 at 04:33:08PM -0500, Dongsheng Yang escreveu:
> Currently, if we use perf kvm --guestkallsyms --guestmodules report,
> we can not get the perf information from perf data file. The all sample
> are shown as unknown.
> 
> Reproducing steps:
> 	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules record -a sleep 1
> 	[ perf record: Woken up 1 times to write data ]
> 	[ perf record: Captured and wrote 0.624 MB perf.data.guest (~27260 samples) ]
> 	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules report |grep %
> 	   100.00%  [guest/6471]  [unknown]         [g] 0xffffffff8164f330
> 
> This bug is caused when delivery sample. We use perf_session__find_machine_for_cpumode() to find
> the machine, and it call perf_session__findnew_machine(). Then we will delivery the sample to a
> new machine without kernel mapped.
> 
> This patch changes perf_session__findnew_machine() to perf_session__find_machine(), so the sample
> will be deliveried to default guest machine if there is no machine specified for it.

Ok, but then we will use the provided guest modules, etc for _all_ VMs,
irrespective of its pid, which sounds risky, no?

You get correct results because the modules/kallsyms info you provided
matches the VM you're testing, i.e. the pid test is not needed.

I think we need to specify for which PID the --guestmodules and
--guestkallsyms is provided, so that it can refuse to use it for pids
where it is invalid.

If we do that then the current code will find it with
perf_session__find_machine_for_cpumode(), and when not finding it, it
will behave as expected and as it does today: refuse to resolve symbols
using invalid kallsyms/modules.

One way to achieve this automagically would be to have the build-id of
the guest kernel and modules be present on the PERF_RECORD_MMAP, so that
we wouldn't need to provide --guest{kallsyms,modules} as it would look
it up (kallsyms or vmlinux) in the ~/.debug or elsewhere, like in
/usr/lib/debug/lib/modules/3.11.4-101.fc18.x86_64/vmlinux (where
kernel-debuginfo packages install its contents.

Untill we have that, we need to at least document this limitation, i.e.
that great care must be taken to provide exactly the kallsyms/modules
pair to 'perf kvm', otherwise bogus results will be presented.

- Arnaldo
 
> Verify steps:
> 	# ./perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules record -a sleep 1
> 	[ perf record: Woken up 1 times to write data ]
> 	[ perf record: Captured and wrote 0.651 MB perf.data.guest (~28437 samples) ]
> 	# ./perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules report |grep %
> 	    22.64%    :6471  [guest.kernel.kallsyms]  [g] update_rq_clock.part.70
> 	    19.99%    :6471  [guest.kernel.kallsyms]  [g] d_free
> 	    18.46%    :6471  [guest.kernel.kallsyms]  [g] bio_phys_segments
> 	    16.25%    :6471  [guest.kernel.kallsyms]  [g] dequeue_task
> 	    12.78%    :6471  [guest.kernel.kallsyms]  [g] __switch_to
> 	     7.91%    :6471  [guest.kernel.kallsyms]  [g] scheduler_tick
> 	     1.75%    :6471  [guest.kernel.kallsyms]  [g] native_apic_mem_write
> 	     0.21%    :6471  [guest.kernel.kallsyms]  [g] apic_timer_interrupt
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  tools/perf/util/session.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 8a7da6f..1770f2f 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -851,6 +851,7 @@ static struct machine *
>  					       struct perf_sample *sample)
>  {
>  	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> +	struct machine *machine;
>  
>  	if (perf_guest &&
>  	    ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
> @@ -863,7 +864,11 @@ static struct machine *
>  		else
>  			pid = sample->pid;
>  
> -		return perf_session__findnew_machine(session, pid);
> +		machine = perf_session__find_machine(session, pid);
> +		if (!machine)
> +			machine = perf_session__findnew_machine(session,
> +						DEFAULT_GUEST_KERNEL_ID);
> +		return machine;
>  	}
>  
>  	return &session->machines.host;
> -- 
> 1.8.2.1
