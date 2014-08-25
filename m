Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaHYNHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:07:30 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58015 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaHYNH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:07:29 -0400
Date: Mon, 25 Aug 2014 14:07:24 +0100
From: Matt Fleming <matt@console-pimps.org>
To: harald@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH V2] efi_high_alloc: use EFI_ALLOCATE_MAX_ADDRESS
Message-ID: <20140825130724.GT29733@console-pimps.org>
References: <1408715303-2215-1-git-send-email-harald@redhat.com>
 <1408967732-2381-1-git-send-email-harald@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408967732-2381-1-git-send-email-harald@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug, at 01:55:32PM, harald@redhat.com wrote:
> From: Harald Hoyer <harald@redhat.com>
> 
> On my Lenovo T420s with 4GB memory, efi_high_alloc() was checking the
> following memory regions:
> 
> 0x0000000000100000 - 0x0000000020000000
> 0x0000000020200000 - 0x0000000040000000
> 0x0000000040200000 - 0x00000000d2c02000
> 0x00000000d6e9f000 - 0x000000011e600000
> 
> and decided to allocate 2649 pages at address 0x11dba7000.
> ...
> [    0.000000] efi: mem53: type=2, attr=0xf, range=[0x000000011dba7000-0x000000011e600000) (10MB)
> ...
> [    0.000000] RAMDISK: [mem 0x11dba7000-0x11e5fffff]
> ...
> [    0.154933] Unpacking initramfs...
> [    0.160990] Initramfs unpacking failed: junk in compressed archive
> [    0.163436] Freeing initrd memory: 10596K (ffff88011dba7000 - ffff88011e600000)
> ...
> 
> Nevertheless, unpacking of the initramfs later on failed.
> This is maybe caused by my buggy EFI BIOS and
> commit 4bf7111f50167133a71c23530ca852a41355e739,
> which enables loading the initramfs above 4G addresses.
> 
> With this patch efi_high_alloc() now uses EFI_ALLOCATE_MAX_ADDRESS,
> which should do the same as before, but use the EFI logic to select the high memory range.
 
No, that's not correct. Your patch changes the semantics of
efi_high_alloc(). The original version allocates from the top of memory
down, so you always get the highest aligned address, that is no higher
than 'max_addr'.

Your version allocates some address that isn't above 'max_addr', but it
needn't necessarily be the highest possible address. The following is
taken from the AllocatePages() documentation in the UEFI spec,

  "Allocation requests of Type AllocateMaxAddress allocate any available
   range of pages whose uppermost address is less than or equal to the
   address pointed to by Memory on input."

Note the part about allocating *any* available range.

Furthermore, there are more callers of efi_high_alloc() than the initrd
loading case, and you've changed their behaviour with this patch.

I get where you're coming from, but this isn't the best way to solve
this problem, sorry. NAK.

-- 
Matt Fleming, Intel Open Source Technology Center
