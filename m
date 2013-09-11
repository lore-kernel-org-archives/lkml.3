Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3IKNyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab3IKNyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:54:44 -0400
Date: Wed, 11 Sep 2013 09:54:34 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130911135434.GA678@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usual story. I'm trying to narrow down on a tracing bug I'd reported that we had no
understanding of (https://lkml.org/lkml/2013/8/27/646) and had hacked up
trinity to just only use perf fds, and left it running overnight.

Woke up to _another_ bug.

WARNING: CPU: 1 PID: 23361 at kernel/events/core.c:5566 perf_swevent_add+0x18d/0x1a0()
Modules linked in: bnep can_bcm caif_socket caif phonet af_rxrpc bluetooth llc2 af_key rose netrom bridge stp snd_seq_dummy tun fuse scsi_transport_iscsi ipt_ULOG pppoe pppox ppp_generic slhc can_raw can af_802154 nfnetlink nfc rfkill irda crc_ccitt rds x25 atm appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd e1000e pcspkr usb_debug ptp pps_core soundcore
CPU: 1 PID: 23361 Comm: trinity-child31 Not tainted 3.11.0+ #66
 ffffffff81a2a90b ffff8801fe4e9a68 ffffffff8171d32b 0000000000000000
 ffff8801fe4e9aa0 ffffffff81053e5d ffff880102728948 ffff8802459cf3e0
 0000000000000008 0000000000000001 000000002fa8ce99 ffff8801fe4e9ab0
Call Trace:
 [<ffffffff8171d32b>] dump_stack+0x54/0x74
 [<ffffffff81053e5d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81053f3a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81142fbd>] perf_swevent_add+0x18d/0x1a0
 [<ffffffff81143b37>] event_sched_in.isra.78+0x87/0x1c0
 [<ffffffff81144a2a>] group_sched_in+0x6a/0x1c0
 [<ffffffff81145721>] ctx_sched_in+0x101/0x290
 [<ffffffff81145910>] perf_event_sched_in+0x60/0x90
 [<ffffffff8114939b>] perf_event_context_sched_in+0x7b/0xc0
 [<ffffffff81149ef7>] __perf_event_task_sched_in+0x477/0x490
 [<ffffffff8109a8e4>] ? arch_vtime_task_switch+0x94/0xa0
 [<ffffffff8108e840>] finish_task_switch+0xf0/0x180
 [<ffffffff817242dc>] __schedule+0x34c/0x9b0
 [<ffffffff81724969>] schedule+0x29/0x70
 [<ffffffff81720e41>] schedule_timeout+0x1c1/0x360
 [<ffffffff810be89f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810be94d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81099e2f>] ? local_clock+0x3f/0x50
 [<ffffffff81726cfc>] ? _raw_spin_unlock_irq+0x2c/0x40
 [<ffffffff810c2065>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff81724e64>] wait_for_completion+0xd4/0x110
 [<ffffffff810965a0>] ? wake_up_state+0x20/0x20
 [<ffffffff81088acd>] __synchronize_srcu+0x12d/0x1f0
 [<ffffffff81088580>] ? call_srcu+0x80/0x80
 [<ffffffff8108e52d>] ? complete+0x1d/0x50
 [<ffffffff81088bad>] synchronize_srcu+0x1d/0x20
 [<ffffffff812049ae>] fsnotify_destroy_group+0x1e/0x40
 [<ffffffff81207868>] SyS_inotify_init1+0xe8/0x110
 [<ffffffff812078a0>] sys_inotify_init+0x10/0x20
 [<ffffffff81730b54>] tracesys+0xdd/0xe2
---[ end trace 2e7ee66c64149375 ]---

That's this in perf_swevent_add

5564 
5565         head = find_swevent_head(swhash, event);
5566         if (WARN_ON_ONCE(!head))
5567                 return -EINVAL;
5568 
5569         hlist_add_head_rcu(&event->hlist_entry, head);
5570 
5571         return 0;
5572 }
5573 

Of the 8 syscalls that trinity was running, three were perf_event_open
inotify_init, and newlstat.  

So then I tried running trinity with just those three syscalls.

And got the same WARN_ON, but from a slightly different path..

WARNING: CPU: 3 PID: 861 at kernel/events/core.c:5566 perf_swevent_add+0x18d/0x1a0()
Modules linked in: ipt_ULOG nfnetlink can_bcm can scsi_transport_iscsi ax25 nfc rfkill af_802154 irda crc_ccitt rds x25 atm appletalk ipx p8023 psnap p8022 llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc libcrc32c snd_timer snd e1000e pcspkr ptp pps_core soundcore usb_debug
CPU: 3 PID: 861 Comm: trinity-child31 Not tainted 3.11.0+ #67 
 ffffffff81a2aa43 ffff8801e6c65ae8 ffffffff8171d5cb 0000000000000000
 ffff8801e6c65b20 ffffffff81053e5d ffff8801e66a2e68 ffff880245dcf3e0
 0000000000000004 0000000000000001 0000000004392ac6 ffff8801e6c65b30
Call Trace:
 [<ffffffff8171d5cb>] dump_stack+0x54/0x74
 [<ffffffff81053e5d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81053f3a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8114302d>] perf_swevent_add+0x18d/0x1a0
 [<ffffffff81143ba7>] event_sched_in.isra.78+0x87/0x1c0
 [<ffffffff81144a9a>] group_sched_in+0x6a/0x1c0
 [<ffffffff8114580c>] ctx_sched_in+0x17c/0x290
 [<ffffffff8114595a>] perf_event_sched_in+0x3a/0x90
 [<ffffffff8114940b>] perf_event_context_sched_in+0x7b/0xc0
 [<ffffffff81149f67>] __perf_event_task_sched_in+0x477/0x490
 [<ffffffff8109a954>] ? arch_vtime_task_switch+0x94/0xa0
 [<ffffffff8108e860>] finish_task_switch+0xf0/0x180
 [<ffffffff81724564>] __schedule+0x344/0xa20
 [<ffffffff81093326>] __cond_resched+0x26/0x30
 [<ffffffff8172507a>] _cond_resched+0x3a/0x50
 [<ffffffff811d7fbe>] clear_inode+0x2e/0x80
 [<ffffffff8122bf33>] proc_evict_inode+0x23/0x70
 [<ffffffff811d8f13>] evict+0xa3/0x1a0
 [<ffffffff811d98b5>] iput+0xf5/0x190
 [<ffffffff811d3c55>] dput+0x245/0x260
 [<ffffffff811c6586>] path_put+0x16/0x30
 [<ffffffff811c138d>] vfs_fstatat+0x6d/0xa0
 [<ffffffff811c1822>] SYSC_newlstat+0x22/0x40
 [<ffffffff811c1a3e>] SyS_newlstat+0xe/0x10
 [<ffffffff81730e54>] tracesys+0xdd/0xe2

The good news is I can reproduce that very quickly.
(Apply http://paste.fedoraproject.org/38721/37890755 on top of trinity.git,
 and run ./trinity -l off -q -C32 -c inotify_init1 -c perf_event_open -c newlstat)


(There's a different kernel build on the two traces fwiw, but the commits are
just 8d7551eb1916832f2a5b27346edf24e7b2382f67 -> bf83e61464803d386d0ec3fc92e5449d7963a409,
which is just a bunch of drm stuff).

	Dave
