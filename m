Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3EVK25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:28:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35743 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3EVK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:28:55 -0400
Date: Wed, 22 May 2013 02:51:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: WARNING: at kernel/rcutree.c:388 rcu_eqs_enter
Message-ID: <20130522095129.GA3578@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130521173100.GA2076@redhat.com>
 <20130521235813.GA18737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521235813.GA18737@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052210-5406-0000-0000-000008B7A8B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 07:58:13PM -0400, Dave Jones wrote:
> On Tue, May 21, 2013 at 01:31:00PM -0400, Dave Jones wrote:
> 
> I'm also seeing this quite often..
> 
> [  576.156848] WARNING: at kernel/rcutree.c:388 rcu_eqs_enter+0x9b/0xb0()
> [  576.165962] Modules linked in: snd_seq_dummy tun fuse bnep hidp can_raw phonet rfcomm rose bluetooth netrom af_rxrpc scsi_transport_iscsi caif_socket caif ipt_ULOG af_key pppoe pppox af_802154 ppp_generic nfnetlink slhc llc2 can_bcm can irda atm ax25 ipx rds p8023 p8022 crc_ccitt x25 nfc rfkill decnet appletalk psnap llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs libcrc32c microcode snd_hda_intel snd_hda_codec pcspkr i915 snd_hwdep snd_seq snd_seq_device e1000e snd_pcm i2c_algo_bit drm_kms_helper drm ptp snd_page_alloc snd_timer pps_core snd i2c_core soundcore video
> [  576.235012] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc2+ #2
> [  576.264999]  ffffffff819e8d1d ffffffff81c01e90 ffffffff816599f1 ffffffff81c01ec8
> [  576.265002]  ffffffff8104a171 ffff8802449cdb60 0000000000000000 0000000000000000
> [  576.265005]  ffffffff81c01fd8 ffffffff81c01fd8 ffffffff81c01ed8 ffffffff8104a24a
> [  576.265006] Call Trace:
> [  576.265011]  [<ffffffff816599f1>] dump_stack+0x19/0x1b
> [  576.265015]  [<ffffffff8104a171>] warn_slowpath_common+0x61/0x80
> [  576.265018]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
> [  576.265022]  [<ffffffff81100b7b>] rcu_eqs_enter+0x9b/0xb0
> [  576.265025]  [<ffffffff81100ba9>] rcu_idle_enter+0x19/0x40
> [  576.265029]  [<ffffffff810a66e2>] cpu_startup_entry+0x92/0x420
> [  576.265034]  [<ffffffff81645287>] rest_init+0x137/0x140
> [  576.265037]  [<ffffffff81645155>] ? rest_init+0x5/0x140
> [  576.265041]  [<ffffffff81ed3e1a>] start_kernel+0x3ec/0x3f9
> [  576.265044]  [<ffffffff81ed3836>] ? repair_env_string+0x5c/0x5c
> [  576.265048]  [<ffffffff81ed356f>] x86_64_start_reservations+0x2a/0x2c
> [  576.265050]  [<ffffffff81ed363d>] x86_64_start_kernel+0xcc/0xcf
> [  576.265052] ---[ end trace d18cda23dfca05cc ]---
> 
> 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);

Hmmm...  Could you please try the patch below?  Untested, probably does
not even compile.

[ . . . ]

> I'm trying to collect all the WARN's in rcutree. 5/29 isn't a bad start :)

;-) ;-) ;-)

Just to make your testing more exiting...  I will be getting on a plane
in a few hours, and will be on planes and in airports for about 30 hours.
I will check in as connectivity permits.

							Thanx, Paul

------------------------------------------------------------------------

trace: Allow idle-safe tracepoints to be called from irq

__DECLARE_TRACE_RCU() currently creates an _rcuidle() tracepoint which
may safely be invoked from what RCU considers to be an idle CPU.
However, these _rcuidle() tracepoints may -not- be invoked from the
handler of an irq taken from idle, because rcu_idle_enter() zeroes
RCU's nesting-level counter, so that the rcu_irq_exit() returning to
idle will trigger a WARN_ON_ONCE().

This commit therefore substitutes rcu_irq_enter() for rcu_idle_exit()
and rcu_irq_exit() for rcu_idle_enter() in order to make the _rcuidle()
tracepoints usable from irq handlers as well as from process context.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2f322c3..f8e084d 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -145,8 +145,8 @@ static inline void tracepoint_synchronize_unregister(void)
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond),			\
-				rcu_idle_exit(),			\
-				rcu_idle_enter());			\
+				rcu_irq_enter(),			\
+				rcu_irq_exit());			\
 	}
 #else
 #define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)

