Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab3IMO3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384Ab3IMO3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:29:33 -0400
Date: Fri, 13 Sep 2013 10:28:56 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130913142856.GB6799@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@kernel.org>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130913111447.GN31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913111447.GN31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 01:14:47PM +0200, Peter Zijlstra wrote:
 > On Thu, Sep 12, 2013 at 02:19:13PM -0400, Steven Rostedt wrote:
 > > > WARNING: CPU: 3 PID: 861 at kernel/events/core.c:5566 perf_swevent_add+0x18d/0x1a0()
 > > > Modules linked in: ipt_ULOG nfnetlink can_bcm can scsi_transport_iscsi ax25 nfc rfkill af_802154 irda crc_ccitt rds x25 atm appletalk ipx p8023 psnap p8022 llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc libcrc32c snd_timer snd e1000e pcspkr ptp pps_core soundcore usb_debug
 > > > CPU: 3 PID: 861 Comm: trinity-child31 Not tainted 3.11.0+ #67 
 > > >  ffffffff81a2aa43 ffff8801e6c65ae8 ffffffff8171d5cb 0000000000000000
 > > >  ffff8801e6c65b20 ffffffff81053e5d ffff8801e66a2e68 ffff880245dcf3e0
 > > >  0000000000000004 0000000000000001 0000000004392ac6 ffff8801e6c65b30
 > > > Call Trace:
 > > >  [<ffffffff8171d5cb>] dump_stack+0x54/0x74
 > > >  [<ffffffff81053e5d>] warn_slowpath_common+0x7d/0xa0
 > > >  [<ffffffff81053f3a>] warn_slowpath_null+0x1a/0x20
 > > >  [<ffffffff8114302d>] perf_swevent_add+0x18d/0x1a0
 > > >  [<ffffffff81143ba7>] event_sched_in.isra.78+0x87/0x1c0
 > > >  [<ffffffff81144a9a>] group_sched_in+0x6a/0x1c0
 > > >  [<ffffffff8114580c>] ctx_sched_in+0x17c/0x290
 > > >  [<ffffffff8114595a>] perf_event_sched_in+0x3a/0x90
 > > >  [<ffffffff8114940b>] perf_event_context_sched_in+0x7b/0xc0
 > > >  [<ffffffff81149f67>] __perf_event_task_sched_in+0x477/0x490
 > 
 > So I've got an idea how this can happen. If we have a per-cpu swevent
 > and group it with an uncore counter which lives on another cpu we'll
 > migrate the swevent using perf_pmu_migrate_context() but it doesn't
 > migrate the swhash.
 > 
 > The below should be able to confirm that theory if one can reproduce the
 > issue.

With that, I now get a different bug... yay?

[  212.012514] WARNING: CPU: 1 PID: 575 at kernel/events/core.c:1109 add_event_to_ctx+0x1fd/0x210()
[  212.016034] Modules linked in: pppoe pppox ppp_generic slhc ipt_ULOG can_raw can scsi_transport_iscsi nfnetlink af_802154 nfc rfkill irda crc_ccitt rds x25 atm appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd e1000e usb_debug soundcore ptp pps_core pcspkr
[  212.026484] CPU: 1 PID: 575 Comm: trinity-child11 Not tainted 3.11.0+ #75 
[  212.031121]  ffffffff81a2b40e ffff88023087dcc0 ffffffff81720482 0000000000000000
[  212.033279]  ffff88023087dcf8 ffffffff810540bd ffff88024197e418 ffff88023976ae68
[  212.035471]  ffff88024197e418 000000007b016bc1 ffff8802419a9530 ffff88023087dd08
[  212.037549] Call Trace:
[  212.038277]  [<ffffffff81720482>] dump_stack+0x54/0x74
[  212.039604]  [<ffffffff810540bd>] warn_slowpath_common+0x7d/0xa0
[  212.040946]  [<ffffffff8105419a>] warn_slowpath_null+0x1a/0x20
[  212.042296]  [<ffffffff8114383d>] add_event_to_ctx+0x1fd/0x210
[  212.043650]  [<ffffffff81149a36>] __perf_install_in_context+0x136/0x260
[  212.045147]  [<ffffffff811434a0>] ? rcu_read_lock_held+0x50/0x50
[  212.046523]  [<ffffffff811434e0>] remote_function+0x40/0x50
[  212.047759]  [<ffffffff810cc670>] smp_call_function_single+0x190/0x1e0
[  212.048337]  [<ffffffff8107d969>] ? wait_rcu_gp+0x79/0xa0
[  212.048374]  [<ffffffff810cc4e5>] ? smp_call_function_single+0x5/0x1e0
[  212.048418]  [<ffffffff811423c4>] task_function_call+0x44/0x50
[  212.048458]  [<ffffffff81149900>] ? perf_cpu_hrtimer_handler+0x1f0/0x1f0
[  212.048502]  [<ffffffff811438d7>] perf_install_in_context+0x87/0x100
[  212.048546]  [<ffffffff8114eebc>] SYSC_perf_event_open+0xcec/0xea0
[  212.048590]  [<ffffffff8114f449>] SyS_perf_event_open+0x9/0x10
[  212.048629]  [<ffffffff81733d54>] tracesys+0xdd/0xe2

 
