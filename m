Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3GDCtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 22:49:21 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:40032 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3GDCtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 22:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130704015525.GA8486@redhat.com>
References: <20130704015525.GA8486@redhat.com>
Date: Wed, 3 Jul 2013 19:49:18 -0700
X-Google-Sender-Auth: aWI28m7NiTvdZrGqZQEqtbdgCig
Message-ID: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
Subject: Re: scheduling while atomic & hang.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 6:55 PM, Dave Jones <davej@redhat.com> wrote:
> This is a pretty context free trace. What the hell happened here?

That lack of call trace looks like it happened at the final stage of
an interrupt or page fault or other trap that is about to return to
user space.

My guess would be that the trap/irq/whatever handler for some odd
reason ended up with an unbalanced spinlock or something. But since
there is no trace of it, I can't even begin to guess what it would be.

Does trinity save enough pseudo-random state that it can be
repeatable, because if it's something repeatable it might be
interesting to see what the last few system calls and traps were...

> Box is wedged, and I won't be able to get to it until Friday to poke it.

Oh well. Adding the x86 people to the cc, since the whole
"retint_careful" does seem imply that it's not a system call entry,
and more likely to be something like a page fault or debug trap or
something. Any ideas, guys?

>From the " 3.10.0+" I assume this is from the merge window, and
possibly a new failure. Do you have an actual git ID? I can heartily
recommend CONFIG_LOCALVERSION_AUTO=y as a way to get commit ID's
encoded in the version string (which is obviously more useful if you
end up running mainly kernels without extra commits of your own on top
of them - if you have your own local commits you'd still need to
translate it into "your kernel XYZ with commits of mine on top")

              Linus

---
> BUG: scheduling while atomic: trinity-child0/13280/0xefffffff
> INFO: lockdep is turned off.
> Modules linked in: dlci dccp_ipv6 dccp_ipv4 dccp sctp bridge 8021q garp stp snd_seq_dummy tun fuse hidp rfcomm bnep can_raw can_bcm nfnetlink phonet llc2 pppoe pppox ppp_generic slhc appletalk af_rxrpc ipt_ULOG irda af_key
>  can atm scsi_transport_iscsi rds rose x25 af_802154 caif_socket ipx caif p8023 psnap crc_ccitt p8022 llc bluetooth nfc rfkill netrom ax25 snd_hda_codec_realtek microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep sn
> d_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
> CPU: 0 PID: 13280 Comm: trinity-child0 Not tainted 3.10.0+ #40
>  0000000000000000 ffff880228533ee0 ffffffff816ec1a2 ffff880228533ef8
>  ffffffff816e782e 0000000000000db5 ffff880228533f60 ffffffff816f42bf
>  ffff88023bdeca40 ffff880228533fd8 ffff880228533fd8 ffff880228533fd8
> Call Trace:
>  [<ffffffff816ec1a2>] dump_stack+0x19/0x1b
>  [<ffffffff816e782e>] __schedule_bug+0x61/0x70
>  [<ffffffff816f42bf>] __schedule+0x94f/0x9c0
>  [<ffffffff816f487e>] schedule_user+0x2e/0x70
>  [<ffffffff816f6de4>] retint_careful+0x12/0x2e
> BUG: scheduling while atomic: trinity-child0/13280/0xefffffff
> INFO: lockdep is turned off.
> Modules linked in: dlci dccp_ipv6 dccp_ipv4 dccp sctp bridge 8021q garp stp snd_seq_dummy tun fuse hidp rfcomm bnep can_raw can_bcm nfnetlink phonet llc2 pppoe pppox ppp_generic slhc appletalk af_rxrpc ipt_ULOG irda af_key can atm scsi_transport_iscsi rds rose x25 af_802154 caif_socket ipx caif p8023 psnap crc_ccitt p8022 llc bluetooth nfc rfkill netrom ax25 snd_hda_codec_realtek microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
> CPU: 0 PID: 13280 Comm: trinity-child0 Tainted: G        W    3.10.0+ #40
>  0000000000000000 ffff880228533e80 ffffffff816ec1a2 ffff880228533e98
>  ffffffff816e782e ffff880228533fd8 ffff880228533f00 ffffffff816f42bf
>  ffff88023bdeca40 ffff880228533fd8 ffff880228533fd8 ffff880228533fd8
> Call Trace:
>  [<ffffffff816ec1a2>] dump_stack+0x19/0x1b
>  [<ffffffff816e782e>] __schedule_bug+0x61/0x70
>  [<ffffffff816f42bf>] __schedule+0x94f/0x9c0
>  [<ffffffff816f487e>] schedule_user+0x2e/0x70
>  [<ffffffff816ff169>] int_careful+0x12/0x1e
>  [<ffffffff816f487e>] ? schedule_user+0x2e/0x70
>  [<ffffffff816f6de4>] ? retint_careful+0x12/0x2e
> Kernel panic - not syncing: Aiee, killing interrupt handler!
