Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3H1S3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab3H1S3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:29:12 -0400
Date: Wed, 28 Aug 2013 14:29:02 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828182902.GB14103@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130828034627.GA30596@redhat.com>
 <20130828095408.37c3dd83@gandalf.local.home>
 <20130828095833.103ccdf0@gandalf.local.home>
 <20130828111746.35369b84@gandalf.local.home>
 <20130828182710.GA14103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828182710.GA14103@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:27:10PM -0400, Dave Jones wrote:
 > On Wed, Aug 28, 2013 at 11:17:46AM -0400, Steven Rostedt wrote:
 >  
 >  > Dave, can you add this patch to your kernels you test, and that way,
 >  > the next time you hit this error, I want to see if this warning was
 >  > triggered too.
 >  > 
 >  > If we did not unregister the ftrace ops but free the filters, it will
 >  > cause the accounting to get out of whack.
 >  > 
 >  > Thanks!
 >  > 
 >  > -- Steve
 >  > 
 >  > diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
 >  > index 80c36bc..05167bb 100644
 >  > --- a/kernel/trace/trace_event_perf.c
 >  > +++ b/kernel/trace/trace_event_perf.c
 >  > @@ -306,6 +306,7 @@ static int perf_ftrace_function_unregister(struct perf_event *event)
 >  >  {
 >  >  	struct ftrace_ops *ops = &event->ftrace_ops;
 >  >  	int ret = unregister_ftrace_function(ops);
 >  > +	WARN_ON(ret);
 >  >  	ftrace_free_filter(ops);
 >  >  	return ret;
 >  >  }
 > 
 > I hit the WARN in the subject, and then this new one immediately afterwards.

actually looking closer..

[ 6619.050768] WARNING: CPU: 1 PID: 16351 at kernel/trace/ftrace.c:1640 __ftrace_hash_rec_update.part.37+0x20a/0x240()
[ 6619.053767] Modules linked in: lec snd_seq_dummy bridge stp fuse tun bnep hidp rfcomm nfnetlink ipt_ULOG scsi_transport_iscsi can_bcm can_raw nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc e1000e ptp snd_timer pcspkr pps_core snd soundcore usb_debug
[ 6619.060523] CPU: 1 PID: 16351 Comm: trinity-child2 Not tainted 3.11.0-rc7+ #31 
[ 6619.062161]  ffffffff81a21901 ffff8802267b9ce0 ffffffff816f9e4f 0000000000000000
[ 6619.063733]  ffff8802267b9d18 ffffffff81052dcd 0000000000000000 0000000000000001
[ 6619.065309]  ffff8802203a3000 0000000000000000 ffff880225e962d0 ffff8802267b9d28
[ 6619.066895] Call Trace:
[ 6619.068437]  [<ffffffff816f9e4f>] dump_stack+0x54/0x74
[ 6619.070046]  [<ffffffff81052dcd>] warn_slowpath_common+0x7d/0xa0
[ 6619.071642]  [<ffffffff81052eaa>] warn_slowpath_null+0x1a/0x20
[ 6619.073224]  [<ffffffff81115d1a>] __ftrace_hash_rec_update.part.37+0x20a/0x240
[ 6619.074817]  [<ffffffff81117e18>] ftrace_shutdown+0xb8/0x160
[ 6619.076399]  [<ffffffff811182a0>] unregister_ftrace_function+0x30/0x50
[ 6619.077983]  [<ffffffff81135e57>] perf_ftrace_event_register+0x87/0x150
[ 6619.079565]  [<ffffffff81135cdc>] perf_trace_destroy+0x2c/0x50
[ 6619.081180]  [<ffffffff8113df49>] tp_perf_event_destroy+0x9/0x10
[ 6619.082742]  [<ffffffff81140527>] free_event+0xa7/0x300
[ 6619.084264]  [<ffffffff81141620>] __perf_event_exit_task+0xe0/0x130
[ 6619.085792]  [<ffffffff8114a491>] perf_event_exit_task+0x1f1/0x230
[ 6619.087329]  [<ffffffff810546dd>] do_exit+0x30d/0xcd0
[ 6619.088860]  [<ffffffff8170cfc0>] ? ftrace_call+0x5/0x2f
[ 6619.090460]  [<ffffffff8105643c>] do_group_exit+0x4c/0xc0
[ 6619.092036]  [<ffffffff810564c4>] SyS_exit_group+0x14/0x20
[ 6619.093614]  [<ffffffff8170d594>] tracesys+0xdd/0xe2

[ 6620.015243] ------------[ cut here ]------------
[ 6620.018093] WARNING: CPU: 3 PID: 17998 at kernel/trace/trace_event_perf.c:309 perf_ftrace_event_register+0x13f/0x150()
[ 6620.022809] Modules linked in: lec snd_seq_dummy bridge stp fuse tun bnep hidp rfcomm nfnetlink ipt_ULOG scsi_transport_iscsi can_bcm can_raw nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc e1000e ptp snd_timer pcspkr pps_core snd soundcore usb_debug
[ 6620.029752] CPU: 3 PID: 17998 Comm: trinity-child3 Tainted: G        W    3.11.0-rc7+ #31
[ 6620.033043]  ffffffff81a185c0 ffff8801e80b1d78 ffffffff816f9e4f 0000000000000000
[ 6620.034676]  ffff8801e80b1db0 ffffffff81052dcd ffff8801f308f3b8 00000000ffffffed
[ 6620.036314]  ffff8801f308f1e0 ffff8802266d01d8 0000000000000001 ffff8801e80b1dc0
[ 6620.038041] Call Trace:
[ 6620.039743]  [<ffffffff816f9e4f>] dump_stack+0x54/0x74
[ 6620.041430]  [<ffffffff81052dcd>] warn_slowpath_common+0x7d/0xa0
[ 6620.043131]  [<ffffffff81052eaa>] warn_slowpath_null+0x1a/0x20
[ 6620.044810]  [<ffffffff81135f0f>] perf_ftrace_event_register+0x13f/0x150
[ 6620.046492]  [<ffffffff81135cdc>] perf_trace_destroy+0x2c/0x50
[ 6620.048168]  [<ffffffff8113df49>] tp_perf_event_destroy+0x9/0x10
[ 6620.049876]  [<ffffffff81140527>] free_event+0xa7/0x300
[ 6620.051545]  [<ffffffff81141620>] __perf_event_exit_task+0xe0/0x130
[ 6620.053204]  [<ffffffff8114a491>] perf_event_exit_task+0x1f1/0x230
[ 6620.054852]  [<ffffffff810546dd>] do_exit+0x30d/0xcd0
[ 6620.056482]  [<ffffffff8170cfc0>] ? ftrace_call+0x5/0x2f
[ 6620.058098]  [<ffffffff8105643c>] do_group_exit+0x4c/0xc0
[ 6620.059739]  [<ffffffff810564c4>] SyS_exit_group+0x14/0x20
[ 6620.061348]  [<ffffffff8170d594>] tracesys+0xdd/0xe2
[ 6620.062955] ---[ end trace c7d2bbab21000c60 ]---

note how they're different CPUs & pids. Relevant ?

	Dave

