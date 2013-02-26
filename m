Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab3BZWSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:18:42 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50142 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab3BZWR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:17:29 -0500
Date: Tue, 26 Feb 2013 17:17:23 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Marcus Sundman <marcus@hibox.fi>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130226221723.GC27235@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Marcus Sundman <marcus@hibox.fi>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org
References: <20121121233021.GA8730@quack.suse.cz>
 <50B4E6F2.6010000@hibox.fi>
 <20121205153216.GF5706@quack.suse.cz>
 <51248C5F.4040606@hibox.fi>
 <5124B613.6040400@hibox.fi>
 <20130222205144.GA30600@quack.suse.cz>
 <5127FEEA.60207@hibox.fi>
 <20130224001222.GB5551@dastard>
 <20130224012052.GC1196@thunk.org>
 <512D01E0.7010009@hibox.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512D01E0.7010009@hibox.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 08:41:36PM +0200, Marcus Sundman wrote:
> 
> So, after reading up a bit on this trimming I'm thinking maybe my
> filesystem's block sizes don't match up with my SSD's blocks (or
> whatever its write unit is called). Then writing a FS block would
> always write to multiple SSD blocks, causing multiple
> read-erase-write sequences, right? So how can I check this, and how
> can I make the FS blocks match the SSD blocks?

The erase block size for SSD's is typically in the area of 2MB (that's
megabytes), with a page size of typically 4k, 8k, or 16k.  So that
means that erases take place with a granularity of 2 megabytes, and
writes take place in chunks of the page size.  It's up to the Flash
Translation Layer to take the writes and map them to the NAND flash in
an efficient way.  This is the difference between high quality SSD's
and really crappy SSD's.  One of the best ways of measuring how good
your SSD is to do random 4k write test, and see how well it handles a
random write workload.  I'm guessing you have a SSD which is really
terrible at this.

In general you don't need to worry about alignment for most SSD's
(eMMC/SD devices are a different story) since historically, Windows
systems had partition offset by 63 (512 byte) sectors, which is the
worst possible alignment.  So SSD's in general can handle misaligned
writes without any problems, or otherwise on Windows XP systems, their
performance would be really crappy.  SD card or eMMC devices don't
deal with this well, so you need to worry about aligning your
partitions appropriately.  If your SSD is sensitive to partition
alrignment, then it truly is a really crappy SSD.  My suggestion to
you is that the next time you buy an SSD, take a look at the reviews
at web sites such as Anandtech, and in particular take a look at the
4k random write benchmark numbers and see how they compare with the
competition.

As far as what you should do with your current SSD, if it's really
that bad, I'm not sure I'd trust precious data on it, and I'd
seriously consider simply getting a new SSD if budget allows this.
Intel has historically does a really good job with their QA.  They
spent several months qual'ing the Sandforce controller, and so they
were late to the market as a result, and their SSDs are generally a
bit more expensive.  However, the agreement they signed with Sandforce
meant that the reliability/performance fixes in the Sandforce firmware
which were the result of Intel's extended QA period would remain
exclusive to Intel SSD's for some period of time and hence wouldn't be
available to their competition.  Guess which manufacturer's SSDs I
generally tend to buy?  :-)

Regards,

						- Ted
