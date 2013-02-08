Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946496Ab3BHO76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:59:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758658Ab3BHO75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:59:57 -0500
Date: Fri, 8 Feb 2013 15:59:45 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] fs: Take mapping lock in generic read paths
Message-ID: <20130208145945.GA10030@quack.suse.cz>
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
 <1359668994-13433-3-git-send-email-jack@suse.cz>
 <20130131155940.7b1f8e0e.akpm@linux-foundation.org>
 <20130204124715.GF7523@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204124715.GF7523@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 04-02-13 13:47:15, Jan Kara wrote:
> On Thu 31-01-13 15:59:40, Andrew Morton wrote:
> > On Thu, 31 Jan 2013 22:49:50 +0100
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > Add mapping lock to struct address_space and grab it in all paths
> > > creating pages in page cache to read data into them. That means buffered
> > > read, readahead, and page fault code.
> > 
> > Boy, this does look expensive in both speed and space.
>   I'm not sure I'll be able to do much with the space cost but hopefully
> the CPU cost could be reduced.
> 
> > As you pointed out in [0/n], it's 2-3%.  As always with pagecache
> > stuff, the cost of filling the page generally swamps any inefficiencies
> > in preparing that page.
>   Yes, I measured it with with ramdisk backed fs exactly to remove the cost
> of filling the page from the picture. But there are systems where IO is CPU
> bound (e.g. when you have PCIe attached devices) and although there is the
> additional cost of block layer which will further hide the cost of page
> cache itself I assume the added 2-3% incurred by page cache itself will be
> measurable on such systems. So that's why I'd like to reduce the CPU cost
> of range locking.
  So I played a bit more with the code and I was able to reduce the space
cost to a single pointer in struct address_space and unmeasurable impact in
write path. I still see ~ 1% regression in the read path and I'm not sure
why that is as the fast path now only adds a test for one value. But maybe
there's some thinko somewhere. Anyway I'm optimistic that at least in
the current form the code could be massaged so that the CPU cost is in the
noise.

I write "in the current form" because as Dave Chinner pointed out we need
to lock the whole range used by write() at once to ever have a chance to
drop i_mutex and that will require some non-trivial changes. So I'll be
looking into that now...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
