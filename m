Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaJETqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:46:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57948 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaJETqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:46:47 -0400
Date: Sun, 5 Oct 2014 15:46:44 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/2] Allow access to sysfs attributes without mem
 allocations.
Message-ID: <20141005194644.GF8549@htj.dyndns.org>
References: <20140930022205.13407.99210.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930022205.13407.99210.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

On Tue, Sep 30, 2014 at 12:33:34PM +1000, NeilBrown wrote:
> Hi Tejun,
>  is this closer to what you would like?

Yes.

>  I do really need this functionality, but I honestly don't like this
>  patch.
>  The need to identify just which attributes need special care seems
>  backwards to me.
>   1/ it is the process (which has called mlock etc) which needs
>      special care, more than the attribute.  Everything that process
>      does needs to avoid allocating memory, whether that this is
>      particularly related to enabling write-out or not.

But there are only certain things such processes can do.  For example,
it can't read the content of a regular file and I strongly believe
that it's a bad idea to give the impression that all sysfs / kernfs
files may be accessed without memory allocation.

The problem isn't just about how kernfs and sysfs are implemented.  A
lot of files get involved in the synchronization scheme of the
subsystem that they belong to and even just telling whether a file's
actual operation may end up depending on memory allocation isn't
trivial at all.  A file may grab a mutex inside which memory
allocation happens in rare cases and we have no way of verifying and
tracking them.

Also, allowing atomic access in general has risk of locking down
implementation details inadvertently.  Files which should have never
been and don't have any need to be accessible w/o memory access could
easily be forced to behave that way because some memlocked program X
used it that way for convenience or whatever.  Things like this are
extremely painful later on when the subsystem has to be updated
because there is no inherent reason whatsoever for such restriction on
internal implementation.

I strongly believe we should be *very* clear to both userland and
kernel ops implementations of this extra attribute.

>   2/ It is also backwards because the vast majority of sysfs
>      attributes only support bool/enum/int which means at most
>      23 chars including sign and newline (maybe more for reads if the
>      read provides a list of options).  So almost everything
>      doesn't need an allocation at all - just some on-stack space.
>      I would be quite happy to identify those attributes that
>      may need care when accessing and could possibly supports
>      read or write > 128 characters, because there wouldn't be any.

I really don't think the length has anything to do with it.  Sure, we
can just preallocate buffer for all open files if that's considered a
good approach.  I just think that the general idea of forcing all
files to be allocation-free is bad.

>   I also don't like this approach because we end up allocating 2 pages
>   for the buffer, as we have to ask for "PAGE_SIZE+1" bytes, for the
>   hypothetical case that an important attribute actually requires a
>   full PAGE_SIZE write...

That isn't pretty but given that only very small number of files will
be marked this way, do we care?

>   Would you be happy to have all specially identified attributes be
>   limited to 127 characters IO max?  Then I would just use an on-stack
>   buffer for those which would remove the allocation and simplify some
>   of the code.

It's not really about the length of buffer or saving memory.

Thanks.

-- 
tejun
