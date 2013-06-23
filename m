Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab3FWH7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3FWH7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:59:02 -0400
Date: Sun, 23 Jun 2013 10:58:48 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        David Sharp <dhsharp@google.com>, yrl.pp-manager.tt@hitachi.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V3 0/1] kvm: Output TSC offset
Message-ID: <20130623075848.GO5832@redhat.com>
References: <20130612074341.25553.56877.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612074341.25553.56877.stgit@yunodevel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:43:41PM +0900, Yoshihiro YUNOMAE wrote:
> Hi All,
> 
Applied, thanks.

> I'd like to propose a patch which adds a tracepoint at write_tsc_offset for
> tracing guests TSC offset changes. It is required for sorting the trace data of
> a guest and the host in chronological order.
> 
> In a virtualization environment, it is difficult to analyze performance
> problems, such as a delay of I/O request on a guest. This is because multiple
> guests operate on the host. One of approaches for solving such kind of problems
> is to sort trace data of guests and the host in chronological order.
> 
> Raw TSC can be chosen as a timestamp of ftrace. I think TSC is useful for
> merging trace data in chronological order by two reasons. One of the reasons is 
> that guests can directly read raw TSC from the CPU using rdtsc operation. This
> means that raw TSC value is not software clock like sched_clock, so we don't
> need to consider about how the timestamp is calculated. The other is that TSC
> of recent x86 CPUs is constantly incremented. This means that we don't need to
> worry about pace of the timestamp. Therefore, choosing TSC as a timestamp for
> tracing is reasonable to integrate trace data of guests and a host.
> 
> Here, we need to consider about just one matter for using TSC on guests. TSC
> value on a guest is always the host TSC plus the guest's "TSC offset". In other
> words, to merge trace data using TSC as timestamp in chronological order, we
> need to consider TSC offset of the guest.
> 
> However, only the host kernel can read the TSC offset from VMCS and TSC offset
> is not output in anywhere now. In other words, tools in userland cannot get
> the TSC offset value, so we cannot merge trace data of guest and the host in
> chronological order. Therefore, I think the TSC offset should be exported for
> userland tools.
> 
> In this patch, TSC offset is exported by the tracepoint kvm_write_tsc_offset
> on the host. TSC offset events will be very rare event because guests may
> seldom execute write_tsc. So if we enable this event for a normal buffer of
> ftrace, the events will be overwritten by other events. For a recent linux
> kernel, a multiple buffer function is available. So, I recommend to enable
> this event for a sub buffer of ftrace.
> 
> <Example>
> We assume that wakeup-latency for a command is big on a guest. Normally
> we will use ftrace's wakeup-latency tracer or event tracer on the guest, but we
> may not be able to solve this problem. This is because guests often exit to
> the host for several reasons. In the next, we will use TSC as ftrace's timestamp
> and record the trace data on the guest and the host. Then, we get following
> data:
> 
>  /* guest data */
>             comm-3826  [000] d...49836825726903: sched_wakeup: [detail]
>             comm-3826  [000] d...49836832225344: sched_switch: [detail]
>  /* host data */
>         qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
>         qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
>         qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
>         qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]
> 
> Since TSC offset is not considered, these data cannot be merged. If this trace
> data is shown like as follows, we will be able to understand the reason:
> 
>         qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
>             comm-3826  [000] d.h.49836825726903: sched_wakeup: [detail] <=
>         qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
>         qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
>             comm-3826  [000] d...49836832225344: sched_switch: [detail] <=
>         qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
>         qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]
> 
> In this case, we can understand wakeup-latency was big due to exit to host
> twice. Getting this data sorted in chronological order is our goal.
> 
> To merge the data like previous pattern, we apply this patch. Then, we can
> get TSC offset of the guest as follows:
> 
> # cat /sys/kernel/debug/tracing/instances/tsc_offset/trace
> .. d...4300151845072: kvm_write_tsc_offset: vcpu=0 prev=0 next=18446739773557710924
>                                                         ^      ^^^^^^^^^^^^^^^^^^^^
> 
> We use this TSC offset value to a merge script and obtain the following data:
> 
> $ ./trace-merge.pl -g guest_data -h host_data -t 18446739773557710924
> 
> h        qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
> h        qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
> g            comm-3826  [000] d.h.50550079226331: sched_wakeup: [detail] <=
> h        qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
> h        qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
> h        qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
> h        qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
> g            comm-3826  [000] d...50550079279266: sched_switch: [detail] <=
> h        qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
> h        qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]
> |
> \----guest/host
> 
> In this summary, I suggest the patch which TSC offset for each guest can be
> output on the host.
> 
> As one example, I will send a merge tool. This tool assumes the guest doesn't
> execute write_tsc.
> 
> Changes in V2:
> - Use tracepoint for outputting TSC offset value instead of printk() [1/1]
> 
> Changes in V3:
> - Add tracepoint in svm.c [1/1]
> - Record vcpu_id [1/1]
> - Change "previous=" to "prev=" in output result [1/1]
> 
> Thanks!
> 
> ---
> 
> Yoshihiro YUNOMAE (1):
>       kvm: Add a tracepoint write_tsc_offset
> 
> 
>  arch/x86/kvm/svm.c   |   10 +++++++++-
>  arch/x86/kvm/trace.h |   21 +++++++++++++++++++++
>  arch/x86/kvm/vmx.c   |    7 ++++++-
>  arch/x86/kvm/x86.c   |    1 +
>  4 files changed, 37 insertions(+), 2 deletions(-)
> 
> -- 
> Yoshihiro YUNOMAE
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: yoshihiro.yunomae.ez@hitachi.com

--
			Gleb.
