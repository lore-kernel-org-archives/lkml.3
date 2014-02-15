Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBOUaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:30:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43052 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbaBOUaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:30:19 -0500
Date: Sat, 15 Feb 2014 21:30:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: John <da_audiophile@yahoo.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mlindner@marvell.com" <mlindner@marvell.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
Message-ID: <20140215203015.GA4528@pd.tnic>
References: <1392466251.41282.YahooMailNeo@web140003.mail.bf1.yahoo.com>
 <1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I'd have to guess, that's trying to rcu deref that struct net_generic
*ng in net_generic() but this is only guesswork as I don't have your
.config.

Anyway, adding some more people to CC.

[ 137.689996] Code: f8 e8 4f b8 9a c8 31 c0 eb c6 90 8d b4 26 00 00 00 00 55 89 e5 56 53 3e 8d 74 26 00 8b 1d 28 e9 a3 f8 89 c6 e8 59 64 5f c8 85 db <8b> 86 58 08 00 00 74 3a 3b 18 77 36 8b 5c 98 08 e8 32 66 5f c8
All code
========
   0:   f8                      clc    
   1:   e8 4f b8 9a c8          call   0xc89ab855
   6:   31 c0                   xor    %eax,%eax
   8:   eb c6                   jmp    0xffffffd0
   a:   90                      nop
   b:   8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi
  12:   55                      push   %ebp
  13:   89 e5                   mov    %esp,%ebp
  15:   56                      push   %esi
  16:   53                      push   %ebx
  17:   3e 8d 74 26 00          lea    %ds:0x0(%esi,%eiz,1),%esi
  1c:   8b 1d 28 e9 a3 f8       mov    0xf8a3e928,%ebx
  22:   89 c6                   mov    %eax,%esi
  24:   e8 59 64 5f c8          call   0xc85f6482
  29:   85 db                   test   %ebx,%ebx
  2b:*  8b 86 58 08 00 00       mov    0x858(%esi),%eax         <-- trapping instruction
  31:   74 3a                   je     0x6d
  33:   3b 18                   cmp    (%eax),%ebx
  35:   77 36                   ja     0x6d
  37:   8b 5c 98 08             mov    0x8(%eax,%ebx,4),%ebx
  3b:   e8 32 66 5f c8          call   0xc85f6672

Code starting with the faulting instruction
===========================================
   0:   8b 86 58 08 00 00       mov    0x858(%esi),%eax
   6:   74 3a                   je     0x42
   8:   3b 18                   cmp    (%eax),%ebx
   a:   77 36                   ja     0x42
   c:   8b 5c 98 08             mov    0x8(%eax,%ebx,4),%ebx
  10:   e8 32 66 5f c8          call   0xc85f6647


On Sat, Feb 15, 2014 at 12:08:37PM -0800, John wrote:
> > When booting into linux v3.13.3, I am unable to mount an nfs share on this 
> 
> > particular hardware.  I get the same problem using v3.12.11.  Only the 3.10.x 
> > series allows normal operation.  Partial dmesg output shown inline, additional 
> > logs available upon request.
> > 
> > PLEASE cc me on my replies as I am not subscribed to lkml.
> > 
> > Hardware: Athlon XP 3200+ on an NVIDIA nForce2 Ultra 400 motherboard.
> > Distro: Arch Linux i686.
> > 
> > % dmesg
> > ...
> > [ 137.616014] NFS: Registering the id_resolver key type
> > [ 137.616036] Key type id_resolver registered
> > [ 137.616038] Key type id_legacy registered
> > [ 137.686758] BUG: unable to handle kernel NULL pointer dereference at 00000858
> > [ 137.689996] IP: [<f8aa2d99>] put_pipe_version+0x19/0x60 [auth_rpcgss]
> > [ 137.689996] *pde = 00000000 
> > [ 137.689996] Oops: 0000 [#1] PREEMPT SMP 
> > [ 137.689996] Modules linked in: rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 
> > asb100 hwmon_vid snd_wavefront ir_mce_kbd_decoder ir_lirc_codec 
> > ir_rc5_sz_decoder ir_sony_decoder lirc_dev ir_rc5_decoder ir_jvc_decoder 
> > ir_sanyo_decoder ir_rc6_decoder ir_nec_decoder rc_streamzap streamzap mousedev 
> > snd_cs4236 rc_core snd_intel8x0 snd_wss_lib snd_opl3_lib snd_hwdep 
> > snd_ac97_codec evdev snd_mpu401 ac97_bus snd_mpu401_uart snd_pcm snd_rawmidi 
> > snd_page_alloc snd_seq_device snd_timer snd pcspkr skge shpchp i2c_nforce2 
> > i2c_core soundcore ns558 gameport processor button nvidia_agp agpgart nfs lockd 
> > sunrpc fscache ext4 crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom 
> > sd_mod ata_generic pata_acpi sata_sil pata_amd libata ehci_pci ohci_pci ohci_hcd 
> > ehci_hcd scsi_mod usbcore usb_common
> > [ 137.689996] CPU: 0 PID: 534 Comm: rpc.gssd Not tainted 3.13.3-1-ARCH #1
> > [ 137.689996] Hardware name: ASUSTeK Computer INC. A7N8X-E/A7N8X-E, BIOS ASUS 
> > A7N8X-E Deluxe ACPI BIOS Rev 1013 11/12/2004
> > [ 137.689996] task: f4633210 ti: f568e000 task.ti: f568e000
> > [ 137.689996] EIP: 0060:[<f8aa2d99>] EFLAGS: 00010202 CPU: 0
> > [ 137.689996] EIP is at put_pipe_version+0x19/0x60 [auth_rpcgss]
> > [ 137.689996] EAX: f4633210 EBX: 00000001 ECX: f56efca8 EDX: 00000296
> > [ 137.689996] ESI: 00000000 EDI: f56efc00 EBP: f568fee8 ESP: f568fee0
> > [ 137.689996] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > [ 137.689996] CR0: 8005003b CR2: 00000858 CR3: 34523000 CR4: 000007d0
> > [ 137.689996] Stack:
> > [ 137.689996] f56efc00 f6c64f78 f568fef4 f8aa2e05 00000010 f568ff40 f8aa3b38 
> > 00000374
> > [ 137.689996] 00000080 b74dde40 f4644a80 f568ff30 00000246 f8ac1080 ffff41c9 
> > f6c64f78
> > [ 137.689996] fffffff3 00000010 f4460140 f44d5820 f44d5810 f53df7ec f57595a0 
> > f8aa93e8
> > [ 137.689996] Call Trace:
> > [ 137.689996] [<f8aa2e05>] gss_release_msg+0x25/0x70 [auth_rpcgss]
> > [ 137.689996] [<f8aa3b38>] gss_pipe_downcall+0x208/0x4b0 [auth_rpcgss]
> > [ 137.689996] [<f8a2f9ab>] rpc_pipe_write+0x3b/0x60 [sunrpc]
> > [ 137.689996] [<f8a2f970>] ? rpc_pipe_poll+0x90/0x90 [sunrpc]
> > [ 137.689996] [<c1156bd5>] vfs_write+0x95/0x1c0
> > [ 137.689996] [<c11572a1>] SyS_write+0x51/0x90
> > [ 137.689996] [<c145cc0d>] sysenter_do_call+0x12/0x28
> > [ 137.689996] Code: f8 e8 4f b8 9a c8 31 c0 eb c6 90 8d b4 26 00 00 00 00 55 89 
> > e5 56 53 3e 8d 74 26 00 8b 1d 28 e9 a3 f8 89 c6 e8 59 64 5f c8 85 db <8b> 
> > 86 58 08 00 00 74 3a 3b 18 77 36 8b 5c 98 08 e8 32 66 5f c8
> > [ 137.689996] EIP: [<f8aa2d99>] put_pipe_version+0x19/0x60 [auth_rpcgss] 
> > SS:ESP 0068:f568fee0
> > [ 137.689996] CR2: 0000000000000858
> > [ 138.578433] ---[ end trace 3dcb8d5c35b64fbd ]---
> > [ 142.979263] type=1006 audit(1392415950.632:4): pid=540 uid=0 old 
> > auid=4294967295 new auid=1000 old ses=4294967295 new ses=3 res=1
> 
> 
> I should add that if I test the same kernel version (v3.13.3 compiled for i686) on a similar machine of the same vintage, there is not a problem.  When I looked into the `lspci -v` output on the machine that has the problems, I found that it seems to be related to the skge driver as shown below; the similar machine that does not have the problem is using the forcedeth driver so I am hypothesizing that the error is with the skge driver.
> 
> 01:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit Ethernet Controller (rev 13)
>         Subsystem: ASUSTeK Computer Inc. Marvell 88E8001 Gigabit Ethernet Controller (Asus)
>         Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
>         Memory at d5000000 (32-bit, non-prefetchable) [size=16K]
>         I/O ports at a000 [size=256]
>         [virtual] Expansion ROM at 80080000 [disabled] [size=128K]
>         Capabilities: [48] Power Management version 2
>         Capabilities: [50] Vital Product Data
>         Kernel driver in use: skge
>         Kernel modules: skge
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
