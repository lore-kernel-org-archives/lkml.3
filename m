Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaDYODu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:03:50 -0400
Received: from imap.thunk.org ([74.207.234.97]:60993 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbaDYODs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:03:48 -0400
Date: Fri, 25 Apr 2014 10:03:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/1] random vs blk-mq
Message-ID: <20140425140344.GG11124@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20140425073610.GA2143@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425073610.GA2143@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:36:10AM -0700, Christoph Hellwig wrote:
> But this also brings up an interesting question:  blk-mq currently
> does not set QUEUE_FLAG_ADD_RANDOM in the default queue flags, so
> simply converting a driver to blk-mq will mean it stops contributing
> to the random pool.  Do we need a more fine grained way to control
> this, especially for SCSI?

In general, more fine grained control is always good.

But getting the defaults right is even more important.  It occurs to
me that what might make sense is to turn on QUEUE_FLAG_ADD_RANDOM if
we know that it is a rotational disk.  But in the case where we know
it's a SSD or a NVMe, it's likely that add_disk_randomness() is not
going to do much in the way that's useful, since we estimate entropy
credits based on the jiffies delta, so if we interrupts more
frequently than the 10ms, we're not going to get any entropy credit
anyway.

Besides, we are sampling all interrupts, so we'll be gathering timing
information and granting a minimal amount of entropy credit (on
average 1/64'th of a bit of entropy per interupt) for each disk
interrupt evenw/o the QUEUE_FLAG_ADD_RANDOM.  The only reason to call
add_disk_randomness() is if we want to give credit for the higher
grade of entropy theoretically available from a disk interrupt ---
which would only be true if we're talking about a rotational storage
device anyway.

							- Ted
