Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaGWNwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbaGWNwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:52:53 -0400
Date: Wed, 23 Jul 2014 09:52:45 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mmarek@suse.cz, LKML <linux-kernel@vger.kernel.org>
Subject: Re: genksyms: separating public headers from private header files
Message-ID: <20140723135245.GL7959@redhat.com>
References: <20140716151915.GS7959@redhat.com>
 <53CF8E500200007800024FD1@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF8E500200007800024FD1@mail.emea.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:28:32AM +0100, Jan Beulich wrote:
> >>> On 16.07.14 at 17:19, <dzickus@redhat.com> wrote:
> > Hi Jan, Michal,
> > 
> > I am not sure who maintains genksyms officially, so I am sending this
> > question to the two of you as folks who seemed to have contributed to the
> > tool. :-)
> > 
> > I noticed with genksyms that a symbol is opaquely defined in a
> > public header file (on purpose) and then fully defined in a private
> > header.  This is normal practice.  Further, symbol checksumming is done on
> > EXPORT_SYMBOLs in a private c file that includes the private header
> > files.
> > 
> > As a result, even though a struct symbol is intentionally opaquely defined
> > in a public header file consumed by a third party module, the symbol
> > checksumming still includes the full definition (because the private c
> > file with the actual export symbol has the full definition).  This has
> > made it difficult to modify the private header file struct because it
> > breaks the symbol checksumming.
> > 
> > For example, let's consider
> > 
> > block/blk-core.c:EXPORT_SYMBOL(blk_put_queue);
> > 
> > blk_put_queue will eventually depend on struct blkcq_gq.
> > 
> > Now publicly blkcg_gq is defined opaquely in 
> > 
> > include/linux/blkdev.h
> > 
> > and privately in
> > 
> > block/block-cgroup.h
> > 
> > Now when we checksum blk_put_queue both include/linux/blkdev.h and
> > block/block-cgroup.h are included in block/blk-core.c, so blkcg_gq is
> > fully defined for checksumming.
> > 
> > Later if we modify blkcq_gq in block/block-cgroup.h the checksum changes,
> > even though it can debated that block-cgroup.h is a private header file
> > and it should not impact kabi for third party modules.
> > 
> > Have either of you run into this?  Or is the argument that private files
> > should not impact the checksum not as strong as I might think?  Or is it a
> > technical problem of how to separate the public includes from the private
> > includes in the preprocessed file?
> 
> Yes, I think we've run into this (if not elsewhere then by seeing [and
> having to wave] false positive kABI changes). Besides being a
> technical problem of separating one kind of header from the other, I'm
> also unsure whether uniformly ignoring definitions in private headers
> would always be correct. Hence I think a possible solution to this ought
> to involve manual annotation of structures not to participate in CRC
> calculations.

Yeah, I wasn't sure how feasible this would be or how to logically prove
the correctness of this approach.

I can how tagging each struct could help, just a lot of tagging has to be
done and I know our developers may not be proactive in all the right
cases.

Thanks for the feedback!  I'll see if I can come up with a solution though
we can't utilize it for a few years as our RHEL6/7 products kabi checksums
are locked down. :-/

Cheers,
Don
