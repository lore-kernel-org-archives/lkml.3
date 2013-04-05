Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163058Ab3DEWqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:46:20 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50793 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162909Ab3DEWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:46:18 -0400
Date: Fri, 5 Apr 2013 15:46:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC] revoke(2) and generic handling of things like
 remove_proc_entry()
Message-ID: <20130405224616.GA10377@kroah.com>
References: <20130405042932.GB4068@ZenIV.linux.org.uk>
 <20130405195609.GA8745@kroah.com>
 <20130405205137.GG4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405205137.GG4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 09:51:37PM +0100, Al Viro wrote:
> On Fri, Apr 05, 2013 at 12:56:09PM -0700, Greg Kroah-Hartman wrote:
> > > 4) nasty semantics issue - mmap() vs. revoke (of any sort, including
> > > remove_proc_entry(), etc.).  Suppose a revokable file had been mmapped;
> > > now it's going away.  What should we do to its VMAs?  Right now sysfs
> > > and procfs get away with that, but only because there's only one thing
> > > that has ->mmap() there - /proc/bus/pci and sysfs equivalents.  I've
> > > no idea how does pci_mmap_page_range() interact with PCI hotplug (and
> > > I'm not at all sure that whatever it does isn't racy wrt device removal),
> > 
> > The page range should just start returning 0xff all over the place, the
> > BIOS should have kept the mapping around, as it can't really assign it
> > anywhere else, so all _should_ be fine here.
> 
> Umm... 0xff or SIGSEGV?

I think, at first glance, 0xff, as the area is still "mapped" to the
device, and that never gets invaldated from what I can tell, despite the
device now being gone.

> > I think that's a reasonable constraint, although tearing down the VMAs
> > might be possible if we just invalidate the file handle "forcefully"
> > (i.e. manually tear them down and then further accesses should through a
> > SIGSEV fail, or am I missing something more basic here?)
> 
> The question is how to do that in a reasonably clean way; we would've done
> as part of ->kick(), I suppose, or right next to it.

I don't really know, sorry.

> > > 6) how do we get from revoke(2) to call of revoke_it() on the right object?
> > > Note that revoke(2) is done by pathname; we might want an ...at() variant,
> > > but all we'll have to play with will be inode, not an opened file.
> > 
> > Can we make revoke(2) require a valid file handle?  Is there a POSIX
> > spec for revoke(2) that we have to follow here, or given that we haven't
> > had one yet, are we free to define whatever we want without people
> > getting that upset?
> 
> BSD one takes a pathname and so do all derived ones...

Ugh, ok, they were there first, fair enough.

Hm, how do they solve this type of race condition?  Last time I looked
(middle of last year) at one of the revoke BSD implementations, I don't
recall anything special to try to prevent this.  Is it that they just
don't care as almost no one uses it, and it's only for tty devices?  Or
did I miss something?

thanks,

greg k-h
