Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaA3PNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:13:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35755 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaA3PNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:13:35 -0500
Date: Thu, 30 Jan 2014 16:13:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140130151321.GC23342@pd.tnic>
References: <20140123192939.GB11190@pd.tnic>
 <52E17087.2060301@oracle.com>
 <20140128162431.GH815@pd.tnic>
 <52E8168D.9060805@oracle.com>
 <20140128205246.GL815@pd.tnic>
 <52E81B90.8040604@oracle.com>
 <20140128213030.GM815@pd.tnic>
 <52E8230F.7080300@oracle.com>
 <52E83903.5040908@oracle.com>
 <20140128232219.GO815@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140128232219.GO815@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 12:22:19AM +0100, Borislav Petkov wrote:
> > >Are you sure that
> > >
> > >    container = (u8 *)(__va((u32)relocated_ramdisk) +
> > >                           ((u32)container -
> > >boot_params.hdr.ramdisk_image));
> > >
> > >in save_microcode_in_initrd_amd() always results in a valid
> > >pointer? It is non-NULL but it
> > >points to address that looks to be not mapped.

Well, here's what I see here:

* initrd *without* microcode:

[    0.000000] RAMDISK: [mem 0x7fbfc000-0x7ffeffff]
[    0.000000] Allocated new RAMDISK: [mem 0x3680a000-0x36bfd099]
[    0.000000] Move RAMDISK from [mem 0x7fbfc000-0x7ffef099] to [mem 0x3680a000-0x36bfd099]

...

[    0.710771] save_microcode_in_initrd_amd:

relocated_ramdisk:			0x3680a000,
__va(relocated_ramdisk):		0xf680a000,
container:				0x76c0e000,
boot_params.hdr.ramdisk_image:		0x7fbfc000

...

[    0.717080] BUG: unable to handle kernel paging request at 76c0e008


* initrd + microcode:

[    0.000000] RAMDISK: [mem 0x7fbf7000-0x7ffeffff]
[    0.000000] Allocated new RAMDISK: [mem 0x36805000-0x36bfd499]
[    0.000000] Move RAMDISK from [mem 0x7fbf7000-0x7ffef499] to [mem 0x36805000-0x36bfd499]

[    0.781948] save_microcode_in_initrd_amd:

relocated_ramdisk:			0x36805000,
__va(relocated_ramdisk):		0xf6805000,
container:				0xf680527c,
boot_params.hdr.ramdisk_image:		0x7fbf7000

Now guess what happens arithmetically if container is 0 (first case
above without microcode):

0xf680a000 + 0 - 0x7fbfc000 = 0x76c0e000.

So the fix of looking at ucode_cpio.data is correct.

An equivalent fix would be this hunk below but the initial version I
sent you aligns more with what we do on 64-bit.

---
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 8384c0fa206f..7199953fdbf2 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -347,6 +347,9 @@ int __init save_microcode_in_initrd_amd(void)
        if (!uci->cpu_sig.sig)
                smp_call_function_single(bsp, collect_cpu_sig_on_bsp, NULL, 1);
 
+       if (!container)
+               return -EINVAL;
+
        /*
         * Take into account the fact that the ramdisk might get relocated
         * and therefore we need to recompute the container's position in

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
