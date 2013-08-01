Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3HAArC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:47:02 -0400
Received: from imap.thunk.org ([74.207.234.97]:37620 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3HAArA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:47:00 -0400
Date: Wed, 31 Jul 2013 20:46:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca, bpm@sgi.com,
        elder@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801004645.GC11378@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca,
	bpm@sgi.com, elder@kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
 <20130731220154.GA11378@thunk.org>
 <20130801002341.GI7118@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801002341.GI7118@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:23:41AM +1000, Dave Chinner wrote:
> On Wed, Jul 31, 2013 at 06:01:54PM -0400, Theodore Ts'o wrote:
> > Have you considered what happens if you have a 10 megabyte file, of
> > which the first 5 megs are mmap'ed into a userspace process.
> > 
> > Now suppose you call COLLAPASE_RANGE on a one megabyte range starting
> > at offset 1024k from the beginning of the file.
> > 
> > Does the right thing happen to the mmap'ed region in memory?
> 
> Implementation detail. like a hole punch, it needs to invalidate the
> range that it is operating over so mmap()d regions are refaulted
> after the operation is done.

It's not just the range that it's operating on, but also the region
beyond the range that's been collapsed out.  That's because the page
that had formerly located at offset 3072k would now be located at
2048k.  And you had better make sure that any dirty pages located
beyond that are written out to disk before you do the invalidate and
collapse.  As a result, there's going to be potential races that don't
exist with truncate and punch.

A quick eyeball of the patch didn't seem to show any code that handled
this, which is why I asked the question.

      	    				- Ted
