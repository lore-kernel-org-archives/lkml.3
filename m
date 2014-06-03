Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbaFCQ7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:59:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297AbaFCQ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:59:06 -0400
Date: Tue, 3 Jun 2014 10:02:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Bin Wang <binw@marvell.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] char/misc driver patches for 3.16-rc1
Message-ID: <20140603170244.GA22867@kroah.com>
References: <20140603054434.GB2921@kroah.com>
 <CA+55aFyQ=iSMnLAywumYpGBOBiqxL2qO9u9OsTF=RFfYBnz10g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyQ=iSMnLAywumYpGBOBiqxL2qO9u9OsTF=RFfYBnz10g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 08:32:50AM -0700, Linus Torvalds wrote:
> On Mon, Jun 2, 2014 at 10:44 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Bin Wang (1):
> >       uio: fix vma io range check in mmap
> 
> Greg, this is BS.
> 
> If the UIO memory size is smaller than a page, we cannot mmap it
> safely, because the mmap will map random memory *after* the memory
> area too. This is not like a regular file mapping where the kernel can
> just zero-pad up to the end of the page.
> 
> We had this bug before (and even worse - it would mmap unaligned IO
> structures too, so now the actual mapped address didn't actually
> correspond to the returned user mapping address at all), and we fixed
> them. See
> 
>   7314e613d5ff Fix a few incorrectly checked [io_]remap_pfn_range() calls
>   b65502879556 uio: we cannot mmap unaligned page contents
> 
> so now you've re-introduced part of the problem, and marked it for stable too.

Crap, sorry about that, I'll remember to not take it for stable.

> The commit log shows nothing useful. It basically just says "let's
> reintroduce this bug" without even giving an excuse why that would be
> a good idea.
> 
> And it really _isn't_ a good idea. At least you didn't remove the
> alignment check, but the thing is, if a resource is less than a page
> in size, it's quite possibly also unaligned, so the fix doesn't even
> *fix* anything, except by pure luck. The fact is, memory-mapping
> device areas smaller than one page is simply a bad bad idea.
> 
> Don't do this shit.

Hm, I got two different bug reports, and this same patch from two
different people insisting that we broke their drivers with the above
patches, and asked for this patch to be applied.  Bin provided a big
long description of why this change was acceptable, somewhere in the
lkml archives, and I got confused thinking it was ok as long as the size
was aligned properly, my fault, I didn't think about the trailing data
in the buffer :(

Bin and Nobuhiro, you need to look at your userspace program that is
dealing with the uio interface and fix up the numbers you are passing it
to live with the existing changes.

Linus, I'll send you a revert patch for this now, or do you want to just
do it directly?

thanks,

greg k-h
