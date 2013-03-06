Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3CFRcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:32:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab3CFRcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:32:13 -0500
Date: Wed, 6 Mar 2013 12:32:07 -0500
From: Peter Jones <pjones@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, hpa@sgi.com, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
Message-ID: <20130306173207.GB25932@fenchurch.internal.datastacks.com>
References: <20130228205206.GC3438@sgi.com>
 <512FC697.3090608@zytor.com>
 <20130228210910.GD3438@sgi.com>
 <512FC82B.40909@zytor.com>
 <20130306165533.GA25932@fenchurch.internal.datastacks.com>
 <51377973.3070005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51377973.3070005@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:14:27AM -0800, H. Peter Anvin wrote:
> On 03/06/2013 08:55 AM, Peter Jones wrote:
> > 
> > So, the problem here seems to be that there's never been widespread
> > compliance with this paragraph, but this patch assumes there has.  A
> > brief survey concludes:
> 
> No, this patch doesn't assume there is widespread compliance, it is
> trying to address the bits that are not complied with.

Right, but that's basically every x86_64 UEFI machine ever deployed.

[lots trimmed]
> > So it's certainly worth trying to find a better way to check this, but I
> > don't think this patch is it.  If we're going to enforce it, we have to
> > make sure that a bootloader that's conforming to what was de facto the
> > standard in 0x020b still works.  Otherwise we're just breaking
> > bootloaders for no reason, and that will end poorly.
> > 
> > I'd suggest we add a field for the bootloader to make a positive
> > declaration of what version it is using, and only check for the sentinel
> > if the field claims it's doing 0x020c or newer.
> 
> Except it doesn't quite work.  The problem is that these broken
> bootloaders aren't just a matter of 2.11 vs 2.12, they are implicitly
> assuming that the kernel image itself doesn't happen to contain anything
> harmful in the fields that they don't bother initializing.  This would
> be nice and good, except that the demands for the boot sector space is
> fairly high and it gets very cantankerous to turn that into a minefield.

If your only objection is real estate, we can find a way to be clever
about what we do that uses already existing space.  For instance, write
back the version number that's supported in the version field, but
byte-swapped, so we can tell it changed (we don't anticipate ever
supporting protocol 0x20b from a kernel that advertises 0xb02, right?)

Just one example - we don't have to do this the exact way I said; we
just need a positive assertion from the bootloader to start doing
enforcement.  Versions would be nice, but they're not strictly required.

> In fact, your suggestion is exactly equivalent to the sentinel, except
> you want it to be pre-initialized with 0x20b instead of 0xffff.

No, I want the bootloader to communicate that it understands the boot
protocol revision is 0x020c, so we can /safely/ enter a world where
we're forbidding booting from an older bootloader.

> As such, I don't really know anything better we can do other than:
> 
> 1. detect the *properly working* case of the structure properly
>    initialized

Which is easy, but it doesn't seem to be anything anybody has ever
shipped on UEFI machines.

> 2. doing legacy bootloader-specific clearing based on the bootloader ID
>    if the sentinel triggers -- if you can think of better heuristics
>    then that would be good;

This heuristic is "all UEFI bootloaders anybody uses".  You can list
them individually, but it's the same as reverting the patch, just with
more code.

> 3. try to get bootloaders switched from case #2 to case #1.

And I'm for that, but I think we should delay enforcement until they've
got a way to express that.

-- 
        Peter
