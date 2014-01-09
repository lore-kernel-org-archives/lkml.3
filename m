Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaAIXCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:02:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38946 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbaAIXCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:02:15 -0500
Date: Fri, 10 Jan 2014 00:02:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: halfdog <me@halfdog.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
Message-ID: <20140109230210.GJ11594@pd.tnic>
References: <52C0C9F4.50101@zytor.com>
 <52C196C3.1040300@halfdog.net>
 <52C31027.2030101@zytor.com>
 <20131231192106.GA22535@phenom.dumpdata.com>
 <52C347F0.8070902@zytor.com>
 <52CD022E.9040107@halfdog.net>
 <52CD8E10.3010204@zytor.com>
 <20140108193655.GD5098@pd.tnic>
 <52CDC316.4050503@halfdog.net>
 <52CF27B4.5020101@halfdog.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52CF27B4.5020101@halfdog.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 10:50:28PM +0000, halfdog wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> It took me some time to build me the Debian Sid testing environment
> for amd64 with the same quality, I have vor i386, but now it is ready.
> And it seems, that amd64 is also affected, but lockup is immediately
> (makes exploitation harder)
> 
> Here is the OOPS from the serial console, again in __switch_to
> 
> [  498.783577] fpu exception: 0000 [#1] SMP
> [  498.787054] Modules linked in: xt_multiport xt_hashlimit xt_tcpudp
> ipt_ULOG xt_LOG xt_conntrack iptable_raw iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
> iptable_filter ip_tables x_tables fuse snd_pcm snd_page_alloc
> snd_timer snd soundcore i2c_piix4 psmouse pcspkr evdev serio_raw
> i2c_core parport_pc parport battery button ac ext4 crc16 mbcache jbd2
> sd_mod crc_t10dif crct10dif_common sg sr_mod cdrom ata_generic
> virtio_net mptspi scsi_transport_spi ata_piix virtio_pci virtio_ring
> virtio mptscsih mptbase libata scsi_mod
> [  498.787205] CPU: 0 PID: 1783 Comm: Test Not tainted 3.12-1-amd64 #1
> Debian 3.12.6-2
> [  498.787205] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> VirtualBox 12/01/2006
> [  498.787205] task: ffff88000cb18840 ti: ffff88000b454000 task.ti:
> ffff88000b454000
> [  498.787205] RIP: 0010:[<ffffffff81011730>]  [<ffffffff81011730>]
> __switch_to+0x2d0/0x490
> [  498.787205] RSP: 0018:ffff88000e0c78b8  EFLAGS: 00010002
> [  498.787205] RAX: 0000000000000001 RBX: ffff88000e0b77c0 RCX:
> 00000000c0000100
> [  498.787205] RDX: 0000000000000000 RSI: 0000000051e3f800 RDI:
> 00000000c0000100
> [  498.787205] RBP: ffff88000cb18840 R08: 0000000000000000 R09:
> 0000000000003314
> [  498.787205] R10: 0000000000001746 R11: 000000000000000f R12:
> 0000000000000000
> [  498.787205] R13: 0000000000000000 R14: ffff88000fc11780 R15:
> 0000000000000000
> [  498.787205] FS:  00007fb651e3f800(0000) GS:ffff88000fc00000(0000)
> knlGS:0000000000000000
> [  498.787205] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  498.787205] CR2: 00007f72ddfcc990 CR3: 000000000e22d000 CR4:
> 00000000000006f0
> [  498.787205] Stack:
> [  498.787205]  ffff88000e0b7bc0 000000010fc14330 ffff88000b4efac0
> ffff88000e0b77c0
> [  498.787205]  ffff88000fc142c0 ffff88000b5d3b40 0000000000000000
> ffff88000e0b77c0
> [  498.787205]  ffffffff8148febe ffff88000e0b77c0 0000000000000086
> 00000000000142c0
> [  498.787205] Call Trace:
> [  498.787205] Code: ff 66 2e 0f 1f 84 00 00 00 00 00 bf 7d 00 00 00
> e8 e6 00 01 00 84 c0 0f 85 d7 fd ff ff 0f 06 66 66 90 66 90 e9 cb fd
> ff ff 66 90 <0f> 77 db 83 94 04 00 00 66 90 eb 74 b8 ff ff ff ff 48 8b

Yep, EMMS again: 0f 77 - unhandled x87 FPU exception, see my other mail
I just sent.

I'll try this on another AMD machine tomorrow to see whether it is
affected too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
