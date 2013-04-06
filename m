Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3DFFAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:00:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54460 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3DFFAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:00:53 -0400
Date: Sat, 6 Apr 2013 06:00:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] revoke(2) and generic handling of things like
 remove_proc_entry()
Message-ID: <20130406050049.GI4068@ZenIV.linux.org.uk>
References: <20130405042932.GB4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405042932.GB4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 05:29:32AM +0100, Al Viro wrote:
> 4) nasty semantics issue - mmap() vs. revoke (of any sort, including
> remove_proc_entry(), etc.).  Suppose a revokable file had been mmapped;
> now it's going away.  What should we do to its VMAs?  Right now sysfs
> and procfs get away with that, but only because there's only one thing
> that has ->mmap() there - /proc/bus/pci and sysfs equivalents.  I've
> no idea how does pci_mmap_page_range() interact with PCI hotplug (and
> I'm not at all sure that whatever it does isn't racy wrt device removal),
> but I suspect that it strongly depends on lack of ->fault() for those
> VMAs, which makes killing all PTEs pointing to pages in question enough.
> How generic do we want to make it?  Anybody wanting to add more files
> that could be mmapped in procfs/sysfs/debugfs deserves to be hurt, but
> if we start playing with revoke(2), restriction might become inconvenient.
> I'm not sure what kind of behaviour do we want there - *BSD at least
> used to have revoke(2) only for character devices that had no mmap()...

Actually, after looking at what sysfs does...   We might get away with
the following
	* new vma flag - VM_REVOKABLE; set by mmap() if ->f_revoke is
non-NULL.  We are short on spare bits there, but there still are some...
	* start_using_vma(vma) that checks the presence of that flag,
returns true if it's absent and __start_using(vma->vm_file->f_revoke)
otherwise; a matching stop_using_vma(vma) as well.
	* surround vma method calls with start_using_vma/stop_using_vma,
similar to file ones.  Do what fs/sysfs/bin.c wrappers do for revoked
ones - VM_FAULT_SIGBUS for ->fault() and ->page_mkwrite(), -EINVAL for
->access() and ->set_policy(), vma->vm_policy for ->get_policy(),
0 for ->migrate(), "do nothing" for ->open() (and I'm not at all sure that
this one is correct), hell knows what for ->close().  Note that the *only*
instance with ->open and without ->close is sysfs pile of wrappers itself...

Hell knows...  We have few enough call sites for ->vm_op->foo() to make
it feasible and overhead would be trivial.  OTOH, I'm not sure what's the
right behaviour for mmap of something like drm after revoke(2) - leaving
writable pages there looks wrong...

BTW, snd_card_disconnect() doesn't do anything to existing mappings; smells
like a bug, and there we do have ones with non-trivial ->mmap().  Could
ALSA folks comment?

One note about the mockup implementation upthread - __release_revoke() should
suck in a bit more than just ->release() - turning fasync off should also go
there.
