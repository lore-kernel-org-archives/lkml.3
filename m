Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965769Ab3HHPCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:02:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34846 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965294Ab3HHPCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:02:51 -0400
Date: Thu, 8 Aug 2013 17:02:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>,
        "Jordan Justen (Intel address)" <jordan.l.justen@intel.com>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130808150249.GB27974@pd.tnic>
References: <51FFC19A.1020204@redhat.com>
 <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <5202889C.2080608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5202889C.2080608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 07:49:16PM +0200, Laszlo Ersek wrote:

[…]

> Now, lines 01 to 05 *do not happen*.
>
> More precisely, they don't happen in the kernel. They happen in the
> firmware. Specifically, "OvmfPkg/Library/LoadLinuxLib/Linux.c".
>
> You're booting the kernel from the qemu command line. The kernel you
> run is also an "[o]ld kernel[] without EFI handover protocol". So what
> happens is, OVMF downloads the kernel image from qemu over fw_cfg,
> figures it's an old kernel...

Right, I think this is easier than having to go into the EFI shell each
time and run bzImage.efi. Unless there's a faster way to do that along
with passing it kernel command line parameters...

[…]

> In one sentence, efi_memblock_x86_reserve_range() expects that
> "boot_params.efi_info->efi_memmap" has been allocated as "loader data"
> (by whomever), but SetupLinuxMemmap() violates this by allocating the
> storage as "boot services data".
>
> This leads to double reservation attempts between
> efi_memblock_x86_reserve_range(), and efi_reserve_boot_services().

Ok, this makes sense.

> The attached edk2 patch should fix it. Please confirm.
> 
> Thanks,
> Laszlo
> 

> From 4a9e1f10fa2d06496f1983c25c47c6a1373d2f42 Mon Sep 17 00:00:00 2001
> From: Laszlo Ersek <lersek@redhat.com>
> Date: Wed, 7 Aug 2013 19:39:30 +0200
> Subject: [PATCH] OvmfPkg: allocate the EFI memory map for Linux as Loader Data
> 
> In Linux, efi_memblock_x86_reserve_range() and efi_reserve_boot_services()
> expect that whoever allocates the EFI memmap allocates it in Loader Data
> type memory. Linux's own exit_boot()-->low_alloc() complies, but
> SetupLinuxMemmap() in LoadLinuxLib doesn't.
> 
> The memory type discrepancy leads to efi_memblock_x86_reserve_range() and
> efi_reserve_boot_services() both trying to reserve the range backing the
> memmap, resulting in memmap entry truncation in
> efi_reserve_boot_services().
> 
> This fix also makes this allocation consistent with all other persistent
> allocations in  "OvmfPkg/Library/LoadLinuxLib/Linux.c".
> 
> Contributed-under: TianoCore Contribution Agreement 1.0
> 
> Signed-off-by: Laszlo Ersek <lersek@redhat.com>

Reported-and-tested-by: Borislav Petkov <bp@suse.de>

Great, thanks for this.

I guess we got that out of the way too. I finally can concentrate on my
patches again :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
