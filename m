Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaIWFwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:52:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58340 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbaIWFwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:52:00 -0400
Date: Tue, 23 Sep 2014 01:51:56 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923055156.GC11740@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
 <20140923041817.GA11740@mtj.dyndns.org>
 <20140923144650.2aa71b39@notabene.brown>
 <20140923045549.GB11740@mtj.dyndns.org>
 <20140923154058.6a1c2449@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923154058.6a1c2449@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:40:58PM +1000, NeilBrown wrote:
> > Oh, I meant the buffer seqfile read op writes to, so it depends on the
> > fact that the allocation is only on the first read?  That seems
> > extremely brittle to me, especially for an issue which tends to be
> > difficult to reproduce.
> 
> It is easy for user-space to ensure they read once before any critical time..

Sure, but it's a hard and subtle dependency on an extremely obscure
implementation detail.

> > I'd much rather keep things direct and make it explicitly allocate r/w
> > buffer(s) on open and disallow seq_file operations on such files.
> 
> As far as I can tell, seq_read is used on all sysfs files that are
> readable except for 'binary' files.  Are you suggesting all files that might
> need to be accessed without a kmalloc have to be binary files?

kernfs ->direct_read() callback doesn't go through seq_file.  sysfs
can be extended to support that for regular files, I guess.  Or just
make those special files binary?

> Having to identify those files which are important in advance seems the more
> "brittle" approach to me.  I would much rather it "just worked"

I disagree.  The files which shouldn't involve memory allocations must
be identified no matter what.  They're *very* special.  And the rules
that userland has to follow seem completely broken to me.  "Small"
writes are okay, whatever that means, and "small" reads are okay too
as long as it isn't the first read.  Ooh, BTW, if the second read ends
up expanding the initial buffer, it isn't okay - the initial boundary
is PAGE_SIZE and the buffer is expanded twice on each overflow.  How
are these rules okay?  This is borderline crazy.  In addition, the
read path involves a lot more code this way.  It ends up locking down
buffer policies of the whole seqfile implementation.

> Would you prefer a new per-attribute flag which directed sysfs to
> pre-allocate a full page, or a 'max_size' attribute which caused a buffer of
> that size to be allocated on open?
> The same size would be used to pre-allocate the seqfile buf (like
> single_open_size does) if reads were supported.

Yes but I really think we should avoid seqfile dependency.

Thanks.

-- 
tejun
