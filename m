Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaDCRuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:50:01 -0400
Received: from mail.efficios.com ([78.47.125.74]:58454 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbaDCRt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:49:58 -0400
Date: Thu, 3 Apr 2014 17:49:54 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <693620685.5916.1396547394009.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140403131559.4ed4cf5e@gandalf.local.home>
References: <1396391508-17294-1-git-send-email-mathieu.desnoyers@efficios.com> <1396391508-17294-2-git-send-email-mathieu.desnoyers@efficios.com> <20140403131559.4ed4cf5e@gandalf.local.home>
Subject: Re: [PATCH v9 1/1] Tracepoint: register/unregister struct
 tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint: register/unregister struct tracepoint
Thread-Index: tGuIiMFTNj/znlpd866b1jU5YGjpfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> "Andrew Morton" <akpm@linux-foundation.org>, "Frank Ch. Eigler" <fche@redhat.com>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Thursday, April 3, 2014 1:15:59 PM
> Subject: Re: [PATCH v9 1/1] Tracepoint: register/unregister struct tracepoint
> 
> On Tue,  1 Apr 2014 18:31:48 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Register/unregister tracepoint probes with struct tracepoint pointer
> > rather than tracepoint name.
> > 
> > This change, which vastly simplifies tracepoint.c, has been proposed by
> > Steven Rostedt. It also removes 8.8kB (mostly of text) to the vmlinux
> > size.
> > 
> > >From this point on, the tracers need to pass a struct tracepoint pointer
> > to probe register/unregister. A probe can now only be connected to a
> > tracepoint that exists. Moreover, tracers are responsible for
> > unregistering the probe before the module containing its associated
> > tracepoint is unloaded.
> > 
> 
> I applied this and kicked off my tests. It crashed horribly on the
> first stress test. Basically the test does this:
> 
> perf record -o perf-test.dat -a -- trace-cmd record -e all -p function \
>  hackbench 50

The warning below is a safety net I added. I assumed that:

kernel/trace/trace_events.c:
ftrace_event_reg()

was meant to receive only struct ftrace_event_call defined by:

include/trace/ftrace.h:
DEFINE_EVENT()

But it appears that other struct ftrace_event_call are passed to
trace_events.c.

Looking at the backtrace, __ftrace_event_enable_disable() seems to
only call ftrace_event_reg() with a TRACE_REG_REGISTER or
TRACE_REG_UNREGISTER type, which ends up calling
trace_probe_{register,unregister} directly. So It seems weird that
it does that for a struct ftrace_event_call that is not a tracepoint.
This is the reason why I did the assumption, but I added the WARN_ON()
just in case.

But __ftrace_set_clr_event_nolock() calls ftrace_event_enable_disable()
for all tr->events, which I'm starting to understand involves events
that are not tracepoints too.

So my current thinking is that the pre-existing code was erroneously
enabling tracepoints with the name of every event enabled (including
e.g. function tracer, kprobes, etc). It was not failing because
tracepoint.c silently accepted to enable tracepoints were not loaded
yet.

If my analysis is correct, then a simple check like this at the
beginning of ftrace_event_reg() should do the trick:

if (!(call->flags & TRACE_EVENT_FL_TRACEPOINT))
  return 0;

Thoughts ?

Thanks,

Mathieu

> 
> 
> [   86.299990] ------------[ cut here ]------------
> [   86.304631] WARNING: CPU: 3 PID: 2465 at
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_events.c:226
> ftrace_event_reg+0x29/0x92()
> [   86.317233] Modules linked in: ipt_MASQUERADE sunrpc ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables uinput
> snd_hda_codec_idt snd_hda_codec_generic snd_h
> da_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device kvm_intel snd_pcm kvm
> i2c_i801 shpchp snd_timer snd soundcore microcode pata_acpi firewire_ohci
> firewire_core ata_generic cr
> c_itu_t i915 drm_kms_helper drm i2c_algo_bit i2c_core video
> [   86.354705] CPU: 3 PID: 2465 Comm: trace-cmd Not tainted 3.14.0-rc7-test+
> #337
> [   86.361931] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
> [   86.373225]  ffffffff81c9a630 ffff880077659de0 ffffffff814e556f
> 0000000000000000
> [   86.380739]  ffff880077659e18 ffffffff8103c88f ffffffff810c8f04
> ffffffff81a140c0
> [   86.388240]  0000000000000000 ffffffff81abb600 ffffffff81ab1290
> ffff880077659e28
> [   86.395736] Call Trace:
> [   86.398201]  [<ffffffff814e556f>] dump_stack+0x4e/0x7a
> [   86.403346]  [<ffffffff8103c88f>] warn_slowpath_common+0x7f/0x98
> [   86.409359]  [<ffffffff810c8f04>] ? ftrace_event_reg+0x29/0x92
> [   86.415198]  [<ffffffff8103c956>] warn_slowpath_null+0x1a/0x1c
> [   86.421037]  [<ffffffff810c8f04>] ftrace_event_reg+0x29/0x92
> [   86.426702]  [<ffffffff810ca4d9>] __ftrace_event_enable_disable+0xed/0x12e
> [   86.433581]  [<ffffffff810ca5e7>] __ftrace_set_clr_event_nolock+0xcd/0xee
> [   86.440375]  [<ffffffff810ca68b>] system_enable_write+0x83/0xb6
> [   86.446303]  [<ffffffff811208b7>] vfs_write+0xab/0x108
> [   86.451445]  [<ffffffff81120fd2>] SyS_write+0x49/0x80
> [   86.456509]  [<ffffffff814f1092>] system_call_fastpath+0x16/0x1b
> [   86.462517] ---[ end trace 543bc9f6b2135806 ]---
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
