Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab3HOTbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:31:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:44228 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab3HOTbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:31:36 -0400
Date: Thu, 15 Aug 2013 15:31:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        david@fromorbit.com, Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Message-ID: <20130815193122.GA19536@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andy Lutomirski <luto@amacapital.net>
References: <520BB9EF.5020308@linux.intel.com>
 <20130815150506.GA10415@thunk.org>
 <520D13A5.2070808@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520D13A5.2070808@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 10:45:09AM -0700, Dave Hansen wrote:
> 
> I _believe_ this is because the block allocation is occurring during the
> warmup, even in those numbers I posted previously.  will-it-scale forks
> things off early and the tests spend most of their time in those while
> loops.  Each "page fault handled" (the y-axis) is a trip through the
> while loop, *not* a call to testcase().

Ah, OK.  Sorry, I misinterpreted what was going on.

So basically, what we have going on in the test is (a) we're bumping
i_version and/or mtime, and (b) the munmap() implies an msync(), so
writeback is happening in the background concurrently with the write
page faults, and we may be (actually, almost certainly) seeing some
interference between the writeback and the page_mkwrite operations.

That implies that if you redid the test using a ramdisk, which will
significantly speed up the writeback and overhead caused by the
journal transactions for the metadata updates, the results might very
well be different.

Cheers,

						- Ted
