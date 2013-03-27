Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3C0Nvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab3C0Nvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:51:31 -0400
Date: Wed, 27 Mar 2013 09:51:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Yet another pipe related oops.
Message-ID: <20130327135127.GB1738@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk>
 <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 01:09:16PM -0700, Linus Torvalds wrote:
 > On Tue, Mar 12, 2013 at 12:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
 > >
 > > Umm...  How about the following, then?  I think it makes the whole thing
 > > simpler and saner...  NOTE: this got only a light beating and we'd
 > > just seen an example of long-standing breakage in that area; I'd really
 > > like to see it tortured by Dave's scripts before it gets merged into
 > > mainline.
 > 
 > Looks ok to me.
 > 
 > But it's very hard to see the changes when they are joined by code
 > movement, so either I'd almost like to see it split into two ("pure
 > movement" followed by "clean up"), or I'd like to feel a lot safer by
 > having somebody beat on named pipes with some app that actually uses
 > them. They are rather seldom used, it's easy to break them and not
 > even notice. For example, we have that whole "r/w_counter" logic that
 > is subtle (and mis-documented, I notice). It's not a "count of
 > readers/writers", it's a "*sequence* count of readers/writers having
 > come in", and it's needed for the whole "oh, we're waiting for a
 > writer, and one came in, but disappeared before we noticed, but we can
 > see that it was there from the sequence number".
 > 
 > So the whole FIFO code is trivial from the standpoint of sharing all
 > the IO code with pipes, but it's nontrivial in having some very
 > specific semantics at open time, and it's seldom actually used, and
 > easy to get wrong.
 > 
 > So anything like this needs to be either "obviously no semantic
 > changes", or needs some real fifo testing.

So here's something interesting..

I had Al's changes in my local tree since the 12th, without anything
pipe related turning up at all.  Yesterday I switched back to using
an unpatched[*] tree based on rc4. 

Today I woke up to this..

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<          (null)>]           (null)
PGD 11be33067 PUD 116800067 PMD 0 
Oops: 0010 [#2] PREEMPT SMP 
Modules linked in: dlci bridge 8021q garp stp mrp vmw_vsock_vmci_transport vmw_vmci vsock bnep rfcomm fuse hidp llc2 af_key caif_socket caif af_rxrpc netrom phonet rose cmtp kernelcapi l2tp_ppp l2tp_netlink l2tp_core can_raw nfnetlink can_bcm pppoe can scsi_transport_iscsi pppox ppp_generic slhc ipt_ULOG appletalk ipx irda p8023 p8022 atm decnet rds psnap llc crc_ccitt x25 af_802154 ax25 nfc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb bluetooth raid0 snd_hda_codec_realtek snd_hda_intel snd_hda_codec microcode serio_raw pcspkr snd_pcm rfkill snd_page_alloc snd_timer snd edac_core r8169 soundcore mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
CPU 1 
Pid: 3935, comm: trinity-child9 Tainted: G      D      3.9.0-rc4+ #2 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
RSP: 0018:ffff880100bcdb98  EFLAGS: 00010286
RAX: ffffffffa01600e0 RBX: ffff880100bcdbb0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff880100bcdba0 RDI: ffff880100bcdbb0
RBP: ffff880100bcdca8 R08: 0000000000000000 R09: ffffffff811efbc0
R10: 0000000000000001 R11: ffffea0000713600 R12: ffff88004b45fc80
R13: ffff880100bcdce8 R14: ffff880025e1f000 R15: ffffffff811efbc0
FS:  00007f61b835c740(0000) GS:ffff88012b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000105e07000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child9 (pid: 3935, threadinfo ffff880100bcc000, task ffff880064bb8000)
Stack:
 ffffffff811bc0f8 ffff880025e1f000 0000000000000068 0000000000000000
 0000000000000000 0000000000000000 ffffffff00000001 ffff88004b45fc80
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff811bc0f8>] ? do_sync_write+0x98/0xd0
 [<ffffffff81198c9b>] ? set_track+0x8b/0x190
 [<ffffffff811bc995>] __kernel_write+0x115/0x120
 [<ffffffff811efc12>] write_pipe_buf+0x52/0x80
 [<ffffffff811ef153>] splice_from_pipe_feed+0x83/0x120
 [<ffffffff811efbc0>] ? direct_splice_actor+0x30/0x30
 [<ffffffff811ef496>] __splice_from_pipe+0x66/0x80
 [<ffffffff811efbc0>] ? direct_splice_actor+0x30/0x30
 [<ffffffff811f1126>] splice_from_pipe+0x86/0xa0
 [<ffffffff811f1179>] default_file_splice_write+0x19/0x30
 [<ffffffff811efb64>] do_splice_from+0x84/0xb0
 [<ffffffff811efbb3>] direct_splice_actor+0x23/0x30
 [<ffffffff811ef9c4>] splice_direct_to_actor+0xc4/0x1e0
 [<ffffffff811efb90>] ? do_splice_from+0xb0/0xb0
 [<ffffffff811f1209>] do_splice_direct+0x79/0x90
 [<ffffffff811bd659>] do_sendfile+0x199/0x300
 [<ffffffff8104d102>] ? do_setitimer+0x1c2/0x310
 [<ffffffff811bd902>] sys_sendfile64+0x92/0xb0
 [<ffffffff816cd242>] system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<          (null)>]           (null)
 RSP <ffff880100bcdb98>
CR2: 0000000000000000

Could be that Al's patches refactored this bug away, or it could just be
that I've been lucky the last few weeks, and just haven't had the right
entropy to get the sequence of events right..

thoughts ?

	Dave


[*] Asides from some pipe-unrelated patches fixing other oopses
