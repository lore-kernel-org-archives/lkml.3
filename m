Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3LTFqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:46:12 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47105 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3LTFqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:46:09 -0500
Message-ID: <52B3D99E.8030104@gmail.com>
Date: Thu, 19 Dec 2013 22:46:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] perf tools: Fix bug for perf kvm report without guestmount.
References: <52B48E5A.8090106@cn.fujitsu.com> <1387564907-3045-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1387564907-3045-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

This should go into all stable releases from v3.3 up.


On 12/20/13, 11:41 AM, Dongsheng Yang wrote:
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
> Acked-by: David Ahern <dsahern@gmail.com>
> ---
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
>

