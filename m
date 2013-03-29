Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3C2TH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab3C2THz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:07:55 -0400
Date: Fri, 29 Mar 2013 15:06:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130329190642.GC23893@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Davidlohr Bueso <davidlohr.bueso@hp.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
	Michel Lespinasse <walken@google.com>,
	Larry Woodman <lwoodman@redhat.com>,
	"Vinod, Chegu" <chegu_vinod@hp.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Stanislav Kinsbursky <skinsbursky@parallels.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
 <20130326192852.GA25899@redhat.com>
 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
 <20130329161746.GA8391@redhat.com>
 <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 11:43:25AM -0700, Linus Torvalds wrote:
 > On Fri, Mar 29, 2013 at 9:17 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Now that I have that reverted, I'm not seeing msgrcv traces any more, but
 > > I've started seeing this..
 > >
 > > general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 > 
 > Do you have CONFIG_CHECKPOINT_RESTORE enabled? Does it go away if you
 > disable it?
 > 
 > I think I foud at least one bug in the MSG_COPY stuff: it leaks the
 > "copy" allocation if
 > 
 >     mode == SEARCH_LESSEQUAL
 > 
 > but maybe I'm misreading it. And that shouldn't cause the problem you
 > see, but it's indicative of how badly tested and thought through the
 > MSG_COPY code is.
 > 
 > Totally UNTESTED leak fix appended. Stanislav?

I'll give it a shot.

Btw, something that's really bothering me is just how much bogus
'follow-on' spew we have lately. I'm not sure what changed, but it
seems to have gotten worse.

Here's an oops I just hit..

BUG: unable to handle kernel NULL pointer dereference at 000000000000000f
IP: [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60
PGD 10fd95067 PUD 10f767067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: phonet netrom llc2 af_key rose af_rxrpc caif_socket caif can_raw cmtp kernelcapi ipt_ULOG nfnetlink can_bcm can scsi_transport_iscsi af_802154 irda ax25 atm ipx x25 p8023 p8022 appletalk pppoe decnet pppox ppp_generic nfc rds slhc psnap crc_ccitt llc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables raid0 snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec bluetooth microcode serio_raw snd_pcm edac_core pcspkr snd_page_alloc rfkill snd_timer snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
CPU 2 
Pid: 958, comm: trinity-child20 Not tainted 3.9.0-rc4+ #7 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff812c24ca>]  [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60
RSP: 0018:ffff880117bb5e88  EFLAGS: 00010246
RAX: ffffffffffffffff RBX: 0000000000000004 RCX: 0000000000000078
RDX: 0000000000000004 RSI: fffffffffffffffe RDI: 000000000000000f
RBP: ffff880117bb5e88 R08: 0000000000000004 R09: 0000000000000001
R10: ffff880117bb8000 R11: 0000000000000001 R12: fffffffffffffffe
R13: ffff88010fd10308 R14: ffff88010fd10258 R15: ffffffffffffffff
FS:  00007fa89c256740(0000) GS:ffff88012aa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000000f CR3: 000000010f76c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child20 (pid: 958, threadinfo ffff880117bb4000, task ffff880117bb8000)
Stack:
 ffff880117bb5f68 ffffffff812c3746 0000000000000000 ffff880117bb8000
 ffff880117bb8000 ffff880117bb8000 ffffffff81c7ace0 ffffffff812c2430
 0000000000000004 0000000000000000 000000000000ffff 00000000652a928e
Call Trace:
 [<ffffffff812c3746>] do_msgrcv+0x1a6/0x5f0
 [<ffffffff812c2430>] ? msg_security+0x10/0x10
 [<ffffffff810b6c55>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134b39e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812c3ba5>] sys_msgrcv+0x15/0x20
 [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
Code: c3 48 c7 c0 f2 ff ff ff eb e5 0f 1f 80 00 00 00 00 66 66 66 66 90 55 83 fa 02 48 89 e5 74 3a 7e 28 83 fa 03 74 13 83 fa 04 75 0a <48> 39 37 b8 01 00 00 00 7e 02 31 c0 5d c3 48 3b 37 74 f7 b8 01 
RIP  [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60
 RSP <ffff880117bb5e88>
CR2: 000000000000000f
---[ end trace 8f0713d2aacb6aa3 ]---
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic(): 1, irqs_disabled(): 0, pid: 958, name: trinity-child20
INFO: lockdep is turned off.
Pid: 958, comm: trinity-child20 Tainted: G      D      3.9.0-rc4+ #7
Call Trace:
 [<ffffffff8107dba5>] __might_sleep+0x145/0x200
 [<ffffffff816c215a>] down_read+0x2a/0xa0
 [<ffffffff8105fa14>] exit_signals+0x24/0x130
 [<ffffffff8104b80c>] do_exit+0xbc/0xd10
 [<ffffffff81048b25>] ? kmsg_dump+0x1b5/0x230
 [<ffffffff81048995>] ? kmsg_dump+0x25/0x230
 [<ffffffff816c6b6c>] oops_end+0x9c/0xe0
 [<ffffffff816b7a40>] no_context+0x268/0x275
 [<ffffffff816b7ac5>] __bad_area_nosemaphore+0x78/0x1d1
 [<ffffffff816b7c31>] bad_area_nosemaphore+0x13/0x15
 [<ffffffff816c90e6>] __do_page_fault+0x366/0x5b0
 [<ffffffff810b72b5>] ? __lock_acquire+0x2e5/0x1a00
 [<ffffffff810b3348>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff8134b3dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff816c933e>] do_page_fault+0xe/0x10
 [<ffffffff816c5fa2>] page_fault+0x22/0x30
 [<ffffffff812c24ca>] ? testmsg.isra.5+0x1a/0x60
 [<ffffffff812d80b6>] ? security_msg_queue_msgrcv+0x16/0x20
 [<ffffffff812c3746>] do_msgrcv+0x1a6/0x5f0
 [<ffffffff812c2430>] ? msg_security+0x10/0x10
 [<ffffffff810b6c55>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134b39e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812c3ba5>] sys_msgrcv+0x15/0x20
 [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
note: trinity-child20[958] exited with preempt_count 1
BUG: scheduling while atomic: trinity-child20/958/0x10000002
INFO: lockdep is turned off.
Modules linked in: phonet netrom llc2 af_key rose af_rxrpc caif_socket caif can_raw cmtp kernelcapi ipt_ULOG nfnetlink can_bcm can scsi_transport_iscsi af_802154 irda ax25 atm ipx x25 p8023 p8022 appletalk pppoe decnet pppox ppp_generic nfc rds slhc psnap crc_ccitt llc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables raid0 snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec bluetooth microcode serio_raw snd_pcm edac_core pcspkr snd_page_alloc rfkill snd_timer snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
Pid: 958, comm: trinity-child20 Tainted: G      D      3.9.0-rc4+ #7
Call Trace:
 [<ffffffff816b8792>] __schedule_bug+0x61/0x70
 [<ffffffff816c38af>] __schedule+0x8df/0x950
 [<ffffffff81083bb8>] __cond_resched+0x18/0x30
 [<ffffffff816c3dea>] _cond_resched+0x3a/0x50
 [<ffffffff8117712f>] munlock_vma_pages_range+0xbf/0xe0
 [<ffffffff8117b6e7>] exit_mmap+0x57/0x160
 [<ffffffff811a9b5e>] ? __khugepaged_exit+0xee/0x130
 [<ffffffff8119c485>] ? kmem_cache_free+0x335/0x380
 [<ffffffff811a9b5e>] ? __khugepaged_exit+0xee/0x130
 [<ffffffff81042047>] mmput+0x77/0x100
 [<ffffffff8104b9e1>] do_exit+0x291/0xd10
 [<ffffffff81048b25>] ? kmsg_dump+0x1b5/0x230
 [<ffffffff81048995>] ? kmsg_dump+0x25/0x230
 [<ffffffff816c6b6c>] oops_end+0x9c/0xe0
 [<ffffffff816b7a40>] no_context+0x268/0x275
 [<ffffffff816b7ac5>] __bad_area_nosemaphore+0x78/0x1d1
 [<ffffffff816b7c31>] bad_area_nosemaphore+0x13/0x15
 [<ffffffff816c90e6>] __do_page_fault+0x366/0x5b0
 [<ffffffff810b72b5>] ? __lock_acquire+0x2e5/0x1a00
 [<ffffffff810b3348>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff8134b3dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff816c933e>] do_page_fault+0xe/0x10
 [<ffffffff816c5fa2>] page_fault+0x22/0x30
 [<ffffffff812c24ca>] ? testmsg.isra.5+0x1a/0x60
 [<ffffffff812d80b6>] ? security_msg_queue_msgrcv+0x16/0x20
 [<ffffffff812c3746>] do_msgrcv+0x1a6/0x5f0
 [<ffffffff812c2430>] ? msg_security+0x10/0x10
 [<ffffffff810b6c55>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134b39e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812c3ba5>] sys_msgrcv+0x15/0x20
 [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b



That's a ton of not-very-interesting crap that makes me thankful
I have a serial console. Most users aren't so lucky. Is there
any way we can silence all that if we've just oopsed ?

Related: is there any value in printing out all the ? symbols on
kernels with frame pointers enabled ?

	Dave

