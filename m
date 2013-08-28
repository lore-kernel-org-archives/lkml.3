Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3H1NyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:54:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3H1NyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:54:09 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jxQzypR4wcoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qWrlR9Lw5PkA:10 a=20KFwNOVAAAA:8 a=sTcujxoSGD2Pd2_0HTwA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 28 Aug 2013 09:54:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828095408.37c3dd83@gandalf.local.home>
In-Reply-To: <20130828034627.GA30596@redhat.com>
References: <20130828034627.GA30596@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 23:46:27 -0400
Dave Jones <davej@redhat.com> wrote:

> WARNING: CPU: 0 PID: 8961 at kernel/trace/ftrace.c:1640 __ftrace_hash_rec_update.part.37+0x20a/0x240()
> Modules linked in: bridge stp fuse hidp bnep rfcomm nfnetlink ipt_ULOG scsi_transport_iscsi can_bcm nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec pcspkr snd_hwdep usb_debug snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd e1000e ptp soundcore pps_core
> CPU: 0 PID: 8961 Comm: trinity-child4 Not tainted 3.11.0-rc7+ #30 
>  ffffffff81a21901 ffff880210039c60 ffffffff816f9e2f 0000000000000000
>  ffff880210039c98 ffffffff81052dcd 0000000000000000 0000000000000001
>  ffff8801cc5d2000 0000000000000000 ffff88022f357248 ffff880210039ca8
> Call Trace:
>  [<ffffffff816f9e2f>] dump_stack+0x54/0x74
>  [<ffffffff81052dcd>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff81052eaa>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff81115d1a>] __ftrace_hash_rec_update.part.37+0x20a/0x240
>  [<ffffffff81117e18>] ftrace_shutdown+0xb8/0x160

OK, this is a hint. The __unregister_ftrace_function returned an error
code, and called ftrace_shutdown(). This is an error path that is not
tested much. So perhaps you did find another place that can cause the
accounting to get out of sync.

I'll investigate this.

Thanks!

-- Steve

>  [<ffffffff811182a0>] unregister_ftrace_function+0x30/0x50
>  [<ffffffff81135e57>] perf_ftrace_event_register+0x87/0x130
>  [<ffffffff81135cdc>] perf_trace_destroy+0x2c/0x50
>  [<ffffffff8113df29>] tp_perf_event_destroy+0x9/0x10
>  [<ffffffff81140507>] free_event+0xa7/0x300
>  [<ffffffff811407c4>] perf_event_release_kernel+0x64/0x90
>  [<ffffffff811413c3>] put_event+0x133/0x1c0
>  [<ffffffff811412c0>] ? put_event+0x30/0x1c0
>  [<ffffffff81141460>] perf_release+0x10/0x20
>  [<ffffffff811b969a>] __fput+0xfa/0x2e0
>  [<ffffffff811b98ce>] ____fput+0xe/0x10
>  [<ffffffff8107a2fc>] task_work_run+0xac/0xe0
>  [<ffffffff8105469c>] do_exit+0x2cc/0xcd0
>  [<ffffffff8170cfc0>] ? ftrace_call+0x5/0x2f
>  [<ffffffff8105643c>] do_group_exit+0x4c/0xc0
>  [<ffffffff810564c4>] SyS_exit_group+0x14/0x20
>  [<ffffffff8170d594>] tracesys+0xdd/0xe2
> ---[ end trace e1bf4ddc241d086b ]---
> 
> 
> 1640                         if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
> 1641                                 return;
> 

