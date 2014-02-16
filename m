Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaBPDfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 22:35:10 -0500
Received: from one.firstfloor.org ([193.170.194.197]:46069 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaBPDfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 22:35:07 -0500
Date: Sun, 16 Feb 2014 04:35:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-kbuild@vger.kernel.org, mmarek@suse.cz, hjl.tools@gmail.com
Subject: Re: Updated Link-Time-Optimization patchkit
Message-ID: <20140216033504.GC32005@two.firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
 <20140215133814.GA287@x4>
 <20140215174424.GB32005@two.firstfloor.org>
 <20140215212443.GA27575@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215212443.GA27575@ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 10:24:43PM +0100, Sam Ravnborg wrote:
> Hi Andi.
> 
> On Sat, Feb 15, 2014 at 06:44:24PM +0100, Andi Kleen wrote:
> > On Sat, Feb 15, 2014 at 02:38:14PM +0100, Markus Trippelsdorf wrote:
> > > On 2014.02.14 at 22:21 +0100, Andi Kleen wrote:
> > > > This is the updated LTO patchkit for 3.14-rc2.  LTO allows
> > > > the compiler to do global optimization over the whole kernel.
> > > 
> > > It is mildly annoying that one couldn't use vanilla binutils. Have you
> > > already opened bugs on sourceware.org/bugzilla/ to get this fixed for
> > > gold and ld.bfd?
> > 
> > The problem is supporting "pass through" of both pure (.S) assembler code and
> > LTO through ld -r, because the kernel makefiles use ld -r heavily.
> > Standard binutils would throw all the assembler away when in plugin LTO
> > mode.
> 
> Long time ago I looked at eliminating the use of -r in the kernel build.
> I lost the patch - but the attached patch managed to build
> a "make defconfig; make" kernel.
> 
> I have not event tried boot with this - it only managed to build!
> 
> What the patch does is for each directory visited a built-in.link file is created
> which is really a linker script.
> It uses INPUT (file file file) to specify all the object files.
> And in the final link the files are all read and the link is performed.
> 
> This limit the depth to 10 levels due to a restriction in ld.
> The binutils people have suggested some other methods that I did not look into.
> 
> Half of the patch is fixes to the security makefiles which I
> will submit anyway as this needs to be cleaned up indendent on
> this patch.
> 
> The patch drops $(cmd_secanalysis) because I did not look into this.
> 
> If this could make it easier to enable LTO then this would be
> a nice win.

I gave it a quick try and it failed like below with LTO

Right now using the Linux binutils is ok for me.

-Andi


+ ld -m elf_x86_64 -r -o vmlinux.o arch/x86/kernel/head_64.o
arch/x86/kernel/head64.o arch/x86/kernel/head.o init/built-in.link
--start-group usr/built-in.link arch/x86/built-in.link
kernel/built-in.link mm/built-in.link fs/built-in.link ipc/built-in.link
security/built-in.link crypto/built-in.link block/built-in.link
lib/lib.a arch/x86/lib/lib.a lib/built-in.link
arch/x86/lib/built-in.link drivers/built-in.link sound/built-in.link
firmware/built-in.link arch/x86/pci/built-in.link
arch/x86/oprofile/built-in.link arch/x86/power/built-in.link
arch/x86/video/built-in.link net/built-in.link --end-group
lib/lib.a: could not read symbols: Bad value

