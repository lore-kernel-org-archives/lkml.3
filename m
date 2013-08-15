Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3HOPFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:05:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:44092 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3HOPFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:05:15 -0400
Date: Thu, 15 Aug 2013 11:05:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        david@fromorbit.com, Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Message-ID: <20130815150506.GA10415@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andy Lutomirski <luto@amacapital.net>
References: <520BB9EF.5020308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BB9EF.5020308@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 10:10:07AM -0700, Dave Hansen wrote:
> We talked a little about this issue in this thread:
> 
> 	http://marc.info/?l=linux-mm&m=137573185419275&w=2
> 
> but I figured I'd follow up with a full comparison.  ext4 is about 20%
> slower in handling write page faults than ext3.

Let's take a step back from the details of whether the benchmark is
measuring what it claims to be measuring, and address this a different
way --- what's the workload which might be run on an 8-socket, 80-core
system, which is heavily modifying mmap'ed pages in such a way that
all or most of the memory writes are to clean pages that require write
page fault handling?

We can talk about isolating the test so that we remove block
allocation, timestamp modifications, etc., but then are we stil
measuring whatever motivated Dave's work in the first place?

IOW, if it really is about write page fault handling, the simplest
test to do is to mmap /dev/zero and then start dirtying pages.  At
that point we will be measuring the VM level write page fault code.

If we start trying to add in file system specific behavior, then we
get into questions about block allocation vs. inode updates
vs. writeback code paths, depending on what we are trying to measure,
which then leads to the next logical question --- why are we trying to
measure this?

Is there a specific scalability problem that is show up in some real
world use case?  Or is this a theoretical exercise?  It's Ok if it's
just theoretical, since then we can try to figure out some kind of
useful scalability limitation which is of practical importance.  But
if there was some original workload which was motivating this
exercise, it would be good if we kept this in mind....

Cheers,

		     	      	      	 - Ted
