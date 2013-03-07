Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3CGViu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:38:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab3CGVit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:38:49 -0500
Date: Thu, 7 Mar 2013 16:38:19 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: ipc/testmsg GPF.
Message-ID: <20130307213819.GB19543@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to reproduce that nd_jump_link trace, but I keep hitting other bugs
instead.  It's like whackamole. Except these are even more annoying
than moles.


general protection fault: 0000 [#1] PREEMPT SMP 
Modules linked in: rose ax25 phonet lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec bluetooth snd_pcm snd_page_alloc snd_timer snd vhost_net rfkill tun macvtap usb_debug macvlan microcode serio_raw pcspkr kvm_amd soundcore edac_core r8169 mii kvm
CPU 0 
Pid: 845, comm: trinity-child14 Not tainted 3.9.0-rc1+ #70 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff812b7b00>]  [<ffffffff812b7b00>] testmsg.isra.1+0x40/0x60
RSP: 0018:ffff880122b0fe78  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
RDX: 0000000000000002 RSI: 000000002c24a9b2 RDI: 697665642d737983
RBP: ffff880122b0fe78 R08: fffffff3f14b03ae R09: 0000000000000000
R10: ffff880127bd8000 R11: 0000000000000000 R12: 000000002c24a9b2
R13: ffff880123360798 R14: ffff8801233606e8 R15: 697665642d737973
FS:  00007f2672bd3740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2672b96068 CR3: 0000000127bc1000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child14 (pid: 845, threadinfo ffff880122b0e000, task ffff880127bd8000)
Stack:
 ffff880122b0ff68 ffffffff812b8e7e ffff8801276d5b90 ffff880127bd8000
 ffff880127bd8000 ffff880127bd8000 0000000000000000 ffffffff812b78c0
 0000000000000000 ffffffff81c7a260 0000000000000000 0000000000001000
Call Trace:
 [<ffffffff812b8e7e>] do_msgrcv+0x1de/0x670
 [<ffffffff812b78c0>] ? load_msg+0x180/0x180
 [<ffffffff810b8685>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff81341aae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812b9325>] sys_msgrcv+0x15/0x20
 [<ffffffff816cd982>] system_call_fastpath+0x16/0x1b
Code: 83 fa 04 74 16 31 c0 5d c3 66 90 ff ca b8 01 00 00 00 74 f3 31 c0 eb ef 0f 1f 00 48 39 37 b8 01 00 00 00 7e e2 31 c0 eb de 66 90 <48> 3b 37 75 d5 b8 01 00 00 00 5d c3 0f 1f 40 00 48 3b 37 74 c5 

0000000000000000 <.text>:
   0:	48 3b 37             	cmp    (%rdi),%rsi
   3:	75 d5                	jne    0xffffffffffffffda
   5:	b8 01 00 00 00       	mov    $0x1,%eax
   a:	5d                   	pop    %rbp
   b:	c3                   	retq   
   c:	0f 1f 40 00          	nopl   0x0(%rax)
  10:	48 3b 37             	cmp    (%rdi),%rsi
  13:	74 c5                	je     0xffffffffffffffda

rdi is ascii. "ived-sy�" Curious.

EIP is here in testmsg.

                case SEARCH_EQUAL:
                        if (msg->m_type == type)
     240:       48 3b 37                cmp    (%rdi),%rsi
     243:       75 d5                   jne    21a <testmsg.isra.1+0x1a>
        {


