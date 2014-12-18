Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaLRQNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:13:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLRQNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:13:37 -0500
Date: Thu, 18 Dec 2014 11:12:30 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141218161230.GA6042@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
 <20141215055707.GA26225@redhat.com>
 <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
 <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
 <20141218051327.GA31988@redhat.com>
 <1418918059.17358.6@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418918059.17358.6@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 10:54:19AM -0500, Chris Mason wrote:
 
 
 > CPU 2 seems to be the one making the least progress.  I think he's 
 > calling fork and then trying to allocate a debug object for his 
 > hrtimer, eventually wandering into fill_pool from __debug_object_init():
 > 
 > static void fill_pool(void)
 > {
 >         gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
 >         struct debug_obj *new;
 >         unsigned long flags;
 > 
 >         if (likely(obj_pool_free >= ODEBUG_POOL_MIN_LEVEL))
 >                 return;
 > 
 >         if (unlikely(!obj_cache))
 >                 return;
 > 
 >         while (obj_pool_free < ODEBUG_POOL_MIN_LEVEL) {
 > 
 >                 new = kmem_cache_zalloc(obj_cache, gfp);
 >                 if (!new)
 >                         return;
 > 
 >                 raw_spin_lock_irqsave(&pool_lock, flags);
 >                 hlist_add_head(&new->node, &obj_pool);
 >                 obj_pool_free++;
 >                 raw_spin_unlock_irqrestore(&pool_lock, flags);
 >         }
 > }
 > 
 > It doesn't seem to be making progress out of __slab_alloc+0x52f/0x58f, 
 > but maybe the slab code is just a victim of being called in a while 
 > loop with GFP_ATOMIC set from a starvation prone loop.  Can you please 
 > line up where 0x52f is in __slab_alloc?

http://codemonkey.org.uk/junk/slub.txt is the whole disassembly.
is that at 10ac, the end of an inlined get_freepointer ?
If so, the looping thing sounds plausible.

 > It might be fun to run with CONFIG_DEBUG_OBJECTS off.

That was going to be my next move in absense of any better ideas.

 > ..Linus' patch clearly helped, I think we're off in a different bug now.

It certainly not showing the xsave traces any more, which is a good
sign.  I just this happen..

[36195.185301] WARNING: CPU: 2 PID: 23893 at kernel/watchdog.c:290 watchdog_overflow_callback+0x9c/0xd0()
[36195.185333] Watchdog detected hard LOCKUP on cpu 2
[36195.185347] Modules linked in:
[36195.185363]  8021q garp dlci bridge stp snd_seq_dummy fuse tun rfcomm bnep llc2 af_key hidp can_raw nfnetlink sctp libcrc32c can_bcm nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds scsi_transport_iscsi rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel usb_debug snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm shpchp snd_timer snd e1000e ptp soundcore pps_core nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[36195.186809] CPU: 2 PID: 23893 Comm: modprobe Not tainted 3.18.0+ #106
[36195.189025]  0000000000000000 00000000ac0a0aab ffff880245205b98 ffffffff817c4aef
[36195.190140]  0000000000000000 ffff880245205bf0 ffff880245205bd8 ffffffff81077c61
[36195.191266]  0000000000000000 ffff880244852520 0000000000000000 ffff880245205d30
[36195.192380] Call Trace:
[36195.193482]  <NMI>  [<ffffffff817c4aef>] dump_stack+0x4e/0x68
[36195.194603]  [<ffffffff81077c61>] warn_slowpath_common+0x81/0xa0
[36195.195722]  [<ffffffff81077cd5>] warn_slowpath_fmt+0x55/0x70
[36195.196810]  [<ffffffff8112bcf0>] ? restart_watchdog_hrtimer+0x60/0x60
[36195.197898]  [<ffffffff8112bd8c>] watchdog_overflow_callback+0x9c/0xd0
[36195.198982]  [<ffffffff8116ebfd>] __perf_event_overflow+0x9d/0x2a0
[36195.200058]  [<ffffffff8116d7d3>] ? perf_event_update_userpage+0x103/0x180
[36195.201137]  [<ffffffff8116d6d0>] ? perf_event_task_disable+0x90/0x90
[36195.202291]  [<ffffffff8116f7d4>] perf_event_overflow+0x14/0x20
[36195.203501]  [<ffffffff8101e739>] intel_pmu_handle_irq+0x1f9/0x3f0
[36195.204696]  [<ffffffff81017cab>] perf_event_nmi_handler+0x2b/0x50
[36195.205881]  [<ffffffff81007320>] nmi_handle+0xc0/0x1b0
[36195.207018]  [<ffffffff81007265>] ? nmi_handle+0x5/0x1b0
[36195.208119]  [<ffffffff8100760a>] default_do_nmi+0x4a/0x140
[36195.209191]  [<ffffffff810077c0>] do_nmi+0xc0/0x100
[36195.210259]  [<ffffffff817d1efa>] end_repeat_nmi+0x1e/0x2e
[36195.211323]  <<EOE>>  <UNK> 
[36195.211335] ---[ end trace b7e2af452c79e16a ]---
[36195.213538] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 28.230 msecs
[36195.214595] perf interrupt took too long (223362 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[36225.945721] perf interrupt took too long (221634 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
[36243.519426] INFO: rcu_sched detected stalls on CPUs/tasks:
[36243.520799] 	2: (0 ticks this GP) idle=3b5/140000000000000/0 softirq=2159968/2159968 
[36243.522120] 	(detected by 0, t=6002 jiffies, g=972859, c=972858, q=0)
[36243.523406] Task dump for CPU 2:
[36243.524699] swapper/2       R  running task    14576     0      1 0x00200000
[36243.526016]  000000024375be38 ffffffffffffff10 ffffffff8165f7d9 0000000000000001
[36243.527326]  ffffffff81cb1bc0 0000000000000002 ffff88024375be88 ffffffff8165f7b5
[36243.528664]  000020fb799d5682 ffffffff81cb1c30 00000000001cc300 ffffffff81d215f0
[36243.530015] Call Trace:
[36243.531328]  [<ffffffff810ed5f4>] ? ktime_get+0x94/0x120
[36243.532647]  [<ffffffff8165f7b5>] cpuidle_enter_state+0x55/0x190
[36243.533974]  [<ffffffff8165f9a7>] cpuidle_enter+0x17/0x20
[36243.535290]  [<ffffffff810bd4a4>] cpu_startup_entry+0x194/0x410
[36243.536590]  [<ffffffff8103015a>] start_secondary+0x1aa/0x230


Which didn't lock up the box, but did taint the kernel so it stopped the fuzzer.
That <UNK> trace is pretty hopeless.

	Dave
