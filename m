Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3CFQzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:55:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3CFQzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:55:39 -0500
Date: Wed, 6 Mar 2013 11:55:33 -0500
From: Peter Jones <pjones@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, hpa@sgi.com, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
Message-ID: <20130306165533.GA25932@fenchurch.internal.datastacks.com>
References: <20130228205206.GC3438@sgi.com>
 <512FC697.3090608@zytor.com>
 <20130228210910.GD3438@sgi.com>
 <512FC82B.40909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512FC82B.40909@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 01:12:11PM -0800, H. Peter Anvin wrote:
> Then make it follow the boot spec:
> 
> > In 32-bit boot protocol, the first step in loading a Linux kernel
> > should be to setup the boot parameters (struct boot_params,
> > traditionally known as "zero page"). The memory for struct boot_params
> > should be allocated and initialized to all zero. Then the setup header
> > from offset 0x01f1 of kernel image on should be loaded into struct
> > boot_params and examined. The end of setup header can be calculated as
> > follow:
> > 
> >         0x0202 + byte value at offset 0x0201
> 
> ... so we don't have to.

So, the problem here seems to be that there's never been widespread
compliance with this paragraph, but this patch assumes there has.  A
brief survey concludes:

grub 1 on bios - loads the kernel and edits the parameters it cares
                 about in place
grub 1 on efi - allocates a buffer (fails to clear it) and modifies
                the parameters it cares about, then copies it back
grub 2 on bios - clears the buffer, writes what it cares about
grub 2 on efi (using efi boot stub) - reads the buffer, modifies fields
        it cares about, passes the pointer to the boot stub
elilo - allocates a new buffer, copies the kernel structure in to it,
        allocates another buffer, clears it, copies the first structure
	in to it, frees the first buffer, modifies fields it cares about
	in the second buffer, clears some other fields in the second
	structure, and passes the pointer in when it calls the old entry
	point
	(It's possible that there's some newer version of elilo than 3.14,
	which I had handy, but I'm not going to do deeper research on a
	project that keeps a link to its CVS repo on the most obvious
	google result, lest I lose the will to live.)
syslinux - I'm just going to assume that your code matches the spec.

So it's certainly worth trying to find a better way to check this, but I
don't think this patch is it.  If we're going to enforce it, we have to
make sure that a bootloader that's conforming to what was de facto the
standard in 0x020b still works.  Otherwise we're just breaking
bootloaders for no reason, and that will end poorly.

I'd suggest we add a field for the bootloader to make a positive
declaration of what version it is using, and only check for the sentinel
if the field claims it's doing 0x020c or newer.

-- 
        Peter
