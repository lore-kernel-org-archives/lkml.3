Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbaISQBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:01:21 -0400
Received: from kanga.kvack.org ([205.233.56.17]:57961 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbaISQBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:01:19 -0400
Date: Fri, 19 Sep 2014 12:01:13 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC 1/2] aio: async readahead
Message-ID: <20140919160113.GE24821@kvack.org>
References: <cover.1410810247.git.milosz@adfin.com> <20140917144925.GU24821@kvack.org> <20140919112612.GC4639@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919112612.GC4639@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:26:12AM -0700, Christoph Hellwig wrote:
> Requiring the block mappings to be entirely async is why we never went
> for full buffered aio.  What would seem more useful is to offload all
> readahead to workqueues to make sure they never block the caller for
> sys_readahead or if we decide to readahead for the nonblocking read.

I can appreciate that it may be difficult for some filesystems to implement 
a fully asynchronous readpage, but at least for some, it is possible 
and not too difficult.

> I tried to implement this, but I couldn't find a good place to hang
> the work_struct for it off.  If we decide to dynamically allocate
> the ra structure separate from struct file that might be an obvious
> place.

The approach I used in the async ext2/3/4 indirect style metadata readpage 
was to put the async state into the page's memory.  That won't work very 
well on 32 bit systems, but it works well and avoids having to perform 
another memory allocation on 64 bit systems.

I'm still of the opinion that the readpage operation should be started by 
the submitting process.  Some of the work I did in tuning things for my 
employer with async reads found that punting reads to another thread 
caused significant degradation of our workload (basically, reading in a 
bunch of persistent messages from disk, with small messages being an 
important corner of performance).  What ended up being the best performing 
for me was to have an async readahead operation to fill the page cache 
with data from the file, and then to issue a read that was essentially 
non-blocking.  This approach meant that the copy of data from the kernel 
into userspace was performed by the thread that was actually using the 
data.  By doing the copy only once all i/o completed, the data was primed 
in the CPU's cache, allowing the code that actually operates on the data 
to benefit.  Any gradual copy over time ended up performing significantly 
worse.

		-ben
-- 
"Thought is the essence of where you are now."
