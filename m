Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaA2OIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:08:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51590 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaA2OHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:07:48 -0500
Date: Wed, 29 Jan 2014 15:07:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: task_ctx_sched_out WARN_ON triggered.
Message-ID: <20140129140744.GF9636@twins.programming.kicks-ass.net>
References: <20140109154707.GB3714@redhat.com>
 <20140110104837.GL31570@twins.programming.kicks-ass.net>
 <20140121150953.GA2408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121150953.GA2408@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:09:53AM -0500, Dave Jones wrote:
> On Fri, Jan 10, 2014 at 11:48:37AM +0100, Peter Zijlstra wrote:
>  > On Thu, Jan 09, 2014 at 10:47:07AM -0500, Dave Jones wrote:
>  > > This is my fuzz tester, but this looks to be part of normal operation,
>  > > not actually fuzzing a syscall. This looks to be the bit that
>  > > sets the task_comm name in the child process to 'trinity-cN'.  Which appears to have
>  > > succeeded judging by the Comm:, but the follow-on perf stuff seems to
>  > > be screwed up.
>  > > 
>  > > WARNING: CPU: 1 PID: 13500 at kernel/events/core.c:2379 task_ctx_sched_out+0x6b/0x80()
>  > > Modules linked in: 8021q garp stp snd_seq_dummy tun fuse rfcomm hidp sctp bnep can_raw scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth can_bcm can llc2 pppoe pppox ppp_generic slhc nfnetlink irda ipt_ULOG crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm xfs snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep libcrc32c snd_seq e1000e snd_seq_device crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_pcm ptp snd_page_alloc shpchp snd_timer snd microcode serio_raw soundcore usb_debug pcspkr pps_core
>  > > CPU: 1 PID: 13500 Comm: trinity-c5 Not tainted 3.13.0-rc7+ #14 
>  > >  ffffffff81a240ac ffff88002e0c7df8 ffffffff816de2ee 0000000000000000
>  > >  ffff88002e0c7e30 ffffffff81052ddd ffff88024d0975f8 ffff880214d7bb10
>  > >  0000000000000282 ffff88015b3b24c0 ffff880214d7bb10 ffff88002e0c7e40
>  > > Call Trace:
>  > >  [<ffffffff816de2ee>] dump_stack+0x4e/0x7a
>  > >  [<ffffffff81052ddd>] warn_slowpath_common+0x7d/0xa0
>  > >  [<ffffffff81052eba>] warn_slowpath_null+0x1a/0x20
>  > >  [<ffffffff81128d5b>] task_ctx_sched_out+0x6b/0x80
>  > >  [<ffffffff8112ba78>] perf_event_comm+0x108/0x260
>  > >  [<ffffffff8112b970>] ? perf_event_fork+0x20/0x20
>  > >  [<ffffffff811a3815>] ? set_task_comm+0x25/0xc0
>  > >  [<ffffffff811a383f>] set_task_comm+0x4f/0xc0
>  > >  [<ffffffff8106b039>] SyS_prctl+0x229/0x3d0
>  > >  [<ffffffff816f0b24>] tracesys+0xdd/0xe2
>  > > ---[ end trace d6e98e080907af47 ]---
>  > > 
>  > > 
>  > > 2379         if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
>  > > 2380                 return;
>  > 
>  > Hmm, you wouldn't happen to have the perf_event_attr for all active
>  > events, would you?
> 
> dammit. forgot about this, and hit it again overnight.
> Is there a handy function in the kernel to dump that struct
> that I can call from that path ?

Not really; I was kinda hoping you kept traces of the syscalls like
Vince's perf-trinity thing does.

Let me see if I can make a 'nice' function to dump state though, it
might come in handy more often.
