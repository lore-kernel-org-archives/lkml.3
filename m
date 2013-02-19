Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab3BSSE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:04:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724Ab3BSSEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:04:54 -0500
Date: Tue, 19 Feb 2013 13:04:41 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: skinsbursky@parallels.com
Subject: general protection fault in do_msgrcv  [3.8]
Message-ID: <20130219180441.GA27141@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	skinsbursky@parallels.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: can af_rxrpc binfmt_misc scsi_transport_iscsi ax25 ipt_ULOG decnet nfc appletalk x25 rds ipx p8023 psnap p8022 llc irda crc_ccitt atm lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb bluetooth snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm edac_core snd_page_alloc snd_timer microcode rfkill usb_debug serio_raw pcspkr snd soundcore vhost_net r8169 mii tun macvtap macvlan kvm_amd kvm
CPU 2 
Pid: 887, comm: trinity-child2 Not tainted 3.8.0+ #57 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff812aebba>]  [<ffffffff812aebba>] do_msgrcv+0x22a/0x670
RSP: 0018:ffff88011892be88  EFLAGS: 00010297
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000004000
RDX: 000000007adea6f6 RSI: 6b6b6b6b6b6b6b6b RDI: ffff8801189ffb60
RBP: ffff88011892bf68 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8801189ffc10 R14: ffff8801189ffb60 R15: 6b6b6b6b6b6b6b6b
FS:  00007f681e955740(0000) GS:ffff88012f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f681e846064 CR3: 000000012553d000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child2 (pid: 887, threadinfo ffff88011892a000, task ffff88010bc82490)
Stack:
 ffff88011892beb8 ffff88010bc82490 ffff88010bc82490 ffff88010bc82490
 ffff8801186d8000 ffffffff812ad5f0 0000000001aba000 ffffffff81c688c0
 000000007adea6f6 00000000001fffff 0000400046a9467e 6b6b6b6b6b6b6b6b
Call Trace:
 [<ffffffff812ad5f0>] ? load_msg+0x180/0x180
 [<ffffffff810b8395>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff813347be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812af015>] sys_msgrcv+0x15/0x20
 [<ffffffff816a8482>] system_call_fastpath+0x16/0x1b
Code: 84 14 01 00 00 8b 8d 74 ff ff ff 85 c9 0f 84 52 02 00 00 48 8b 95 60 ff ff ff 48 39 55 80 0f 84 4d 02 00 00 4c 89 bd 78 ff ff ff <4d> 8b 3f 48 ff 45 80 4d 39 ef 75 9a 66 90 48 81 bd 78 ff ff ff 
RIP  [<ffffffff812aebba>] do_msgrcv+0x22a/0x670
 RSP <ffff88011892be88>
---[ end trace d3cc044a84b1d828 ]---

oopsing instruction is..

   0:	4d 8b 3f             	mov    (%r15),%r15

Looks like a use-after-free.

Disassembly of ipc/msg.o shows this happens here..

                msg = ERR_PTR(-EAGAIN);
                tmp = msq->q_messages.next;
    1537:       4d 8b be b0 00 00 00    mov    0xb0(%r14),%r15
                while (tmp != &msq->q_messages) {
    153e:       4d 8d ae b0 00 00 00    lea    0xb0(%r14),%r13
    1545:       4d 39 ef                cmp    %r13,%r15
    1548:       0f 84 5f 03 00 00       je     18ad <do_msgrcv+0x50d>
    154e:       48 c7 45 80 00 00 00    movq   $0x0,-0x80(%rbp)
    1555:       00 
    1556:       48 c7 85 78 ff ff ff    movq   $0xfffffffffffffff5,-0x88(%rbp)
    155d:       f5 ff ff ff 
    1561:       eb 0d                   jmp    1570 <do_msgrcv+0x1d0>
    1563:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
                                        }
                                } else
                                        break;
                                msg_counter++;
                        }
                        tmp = tmp->next;
    1568:       4d 8b 3f                mov    (%r15),%r15
                if (ipcperms(ns, &msq->q_perm, S_IRUGO))
                        goto out_unlock;

                msg = ERR_PTR(-EAGAIN);
                tmp = msq->q_messages.next;
                while (tmp != &msq->q_messages) {

Looks like Stanislav recently changed this code, so problem was likely introduced
in those changes.

	Dave

