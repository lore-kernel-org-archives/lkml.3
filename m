Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3CFROk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:14:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45500 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3CFROh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:14:37 -0500
Message-ID: <51377973.3070005@zytor.com>
Date: Wed, 06 Mar 2013 09:14:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Peter Jones <pjones@redhat.com>
CC: Robin Holt <holt@sgi.com>, hpa@sgi.com, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
References: <20130228205206.GC3438@sgi.com> <512FC697.3090608@zytor.com> <20130228210910.GD3438@sgi.com> <512FC82B.40909@zytor.com> <20130306165533.GA25932@fenchurch.internal.datastacks.com>
In-Reply-To: <20130306165533.GA25932@fenchurch.internal.datastacks.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 08:55 AM, Peter Jones wrote:
> 
> So, the problem here seems to be that there's never been widespread
> compliance with this paragraph, but this patch assumes there has.  A
> brief survey concludes:
> 

No, this patch doesn't assume there is widespread compliance, it is
trying to address the bits that are not complied with.

> grub 1 on bios - loads the kernel and edits the parameters it cares
>                  about in place
> grub 1 on efi - allocates a buffer (fails to clear it) and modifies
>                 the parameters it cares about, then copies it back
> grub 2 on bios - clears the buffer, writes what it cares about

On BIOS, anything that invokes the 16-bit entry point will be correct,
because it is the 16-bit code that sets up struct boot_params.

> grub 2 on efi (using efi boot stub) - reads the buffer, modifies fields
>         it cares about, passes the pointer to the boot stub
> elilo - allocates a new buffer, copies the kernel structure in to it,
>         allocates another buffer, clears it, copies the first structure
> 	in to it, frees the first buffer, modifies fields it cares about
> 	in the second buffer, clears some other fields in the second
> 	structure, and passes the pointer in when it calls the old entry
> 	point
> 	(It's possible that there's some newer version of elilo than 3.14,
> 	which I had handy, but I'm not going to do deeper research on a
> 	project that keeps a link to its CVS repo on the most obvious
> 	google result, lest I lose the will to live.)
> syslinux - I'm just going to assume that your code matches the spec.
> 
> So it's certainly worth trying to find a better way to check this, but I
> don't think this patch is it.  If we're going to enforce it, we have to
> make sure that a bootloader that's conforming to what was de facto the
> standard in 0x020b still works.  Otherwise we're just breaking
> bootloaders for no reason, and that will end poorly.
> 
> I'd suggest we add a field for the bootloader to make a positive
> declaration of what version it is using, and only check for the sentinel
> if the field claims it's doing 0x020c or newer.

Except it doesn't quite work.  The problem is that these broken
bootloaders aren't just a matter of 2.11 vs 2.12, they are implicitly
assuming that the kernel image itself doesn't happen to contain anything
harmful in the fields that they don't bother initializing.  This would
be nice and good, except that the demands for the boot sector space is
fairly high and it gets very cantankerous to turn that into a minefield.

In fact, your suggestion is exactly equivalent to the sentinel, except
you want it to be pre-initialized with 0x20b instead of 0xffff.

As such, I don't really know anything better we can do other than:

1. detect the *properly working* case of the structure properly
   initialized;
2. doing legacy bootloader-specific clearing based on the bootloader ID
   if the sentinel triggers -- if you can think of better heuristics
   then that would be good;
3. try to get bootloaders switched from case #2 to case #1.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

