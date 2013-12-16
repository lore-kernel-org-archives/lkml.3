Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3LPDiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 22:38:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4607 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab3LPDiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 22:38:10 -0500
X-IronPort-AV: E=Sophos;i="4.95,492,1384272000"; 
   d="scan'208";a="9265968"
Message-ID: <52AF2C01.9020507@cn.fujitsu.com>
Date: Mon, 16 Dec 2013 11:36:17 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: dsahern@gmail.com, acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] perf tools: Fix bug for perf kvm report without guestmount.
References: <52A7637E.8080007@cn.fujitsu.com> <1387211216-19794-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1387211216-19794-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/16 11:37:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/16 11:37:43,
	Serialize complete at 2013/12/16 11:37:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
     Could you please help to review this patch when you have a time ?

     Thanx in advance

- Yang

On 12/16/2013 11:26 AM, Dongsheng Yang wrote:
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
> This bug was introduced by 207b57926 (perf kvm: Fix regression with guest machine creation).
>
> commit 207b5792696206663a38e525b9793644895bad3b
> Author: David Ahern <dsahern@gmail.com>
> Date:   Sun Jul 1 16:11:37 2012 -0600
>
>      perf kvm: Fix regression with guest machine creation
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index c3e399b..56142d0 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -926,7 +926,7 @@ static struct machine *
>                  else
>                          pid = event->ip.pid;
>
> -               return perf_session__find_machine(session, pid);
> +               return perf_session__findnew_machine(session, pid);
>          }
>
>          return perf_session__find_host_machine(session);
> In original code, it uses perf_session__find_machine(), it means we deliver symbol to machine
> which has the same pid, if no machine found, deliver it to *default* guest. But if we use
> perf_session__findnew_machine() here, if no machine was found, new machine with pid will be built
> and added. Then the default guest which with pid == 0 will never get a symbol.
>
> And because the new machine initialized here has no kernel map created, the symbol delivered to
> it will be marked as "unknown".
>
> This patch here is to revert commit 207b57926 and fix the SEGFAULT bug in another way.
>
> Verification steps:
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
>      Changelog since V1:
>          * More commit message.
>
>   tools/perf/util/session.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 989b2e3..a12dfdd 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -830,6 +830,7 @@ static struct machine *
>   					       struct perf_sample *sample)
>   {
>   	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> +	struct machine *machine;
>   
>   	if (perf_guest &&
>   	    ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
> @@ -842,7 +843,11 @@ static struct machine *
>   		else
>   			pid = sample->pid;
>   
> -		return perf_session__findnew_machine(session, pid);
> +		machine = perf_session__find_machine(session, pid);
> +		if (!machine)
> +			machine = perf_session__findnew_machine(session,
> +						DEFAULT_GUEST_KERNEL_ID);
> +		return machine;
>   	}
>   
>   	return &session->machines.host;

