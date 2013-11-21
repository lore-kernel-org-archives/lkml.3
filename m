Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3KUKLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:11:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3KUKLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:11:11 -0500
Date: Thu, 21 Nov 2013 02:11:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chinmay V S <cvs268@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131121101101.GA18404@infradead.org>
References: <528CA73B.9070604@profihost.ag>
 <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
 <528CC36A.7080003@profihost.ag>
 <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
 <20131120153703.GA23160@thunk.org>
 <20131120155507.GA5380@fieldses.org>
 <CAK-9PRCQ6qWvzpdvK8BswpS+TfgM7NeoRaVdChFHhyDjwtUGTw@mail.gmail.com>
 <20131120175807.GC5380@fieldses.org>
 <CAK-9PRDNxHAX70cN88kRt03FkYbDB_x1cFQQYmVzqiCX=aZD6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-9PRDNxHAX70cN88kRt03FkYbDB_x1cFQQYmVzqiCX=aZD6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 1. Most drives do NOT respond to CMD_FLUSH immediately i.e. they wait
> until the data is actually moved to the non-volatile media (which is
> the right behaviour) i.e. performance drops.

Which is what the specification sais they must do.

> 2. Some drives may implement CMD_FLUSH to return immediately i.e. no
> guarantee the data is actually on disk.

In which case they aren't spec complicant.  While I've seen countless
data integrity bugs on lower end ATA SSDs I've not seen one that simpliy
ingnores flush.  If you'd want to cheat that bluntly you'd be better
of just claiming to not have a writeback cache.

> 3. Anyway, CMD_FLUSH does NOT guarantee atomicity. (Consider power
> failure in the middle of an ongoing CMD_FLUSH on non battery-backed
> disks).

It does not guarantee atomicy by itself, but it's the only low-level
primitive a filesystem or database can use build atomic transaction
at a higher level on an ATA disk with the writeback cache enabled.

> In case the application cannot be modified to perform ASYNC IO, there
> exists a way to disable the behaviour of issuing a CMD_FLUSH for each
> sync() within the block device driver for SATA/SCSI disks. This is
> what is described by
> https://gist.github.com/TheCodeArtist/93dddcd6a21dc81414ba

Which is utterly broken, and your insistance on pushing it shows you
do not understand the problem space.

You solve your performance problem by completely disabling any chance
of having data integrity guarantees, and do so in a way that is not
detectable for applications or users.

If you have a workload with lots of small synchronous writes disabling
the writeback cache on the disk does indeed often help, especially with
the non-queueable FLUSH on all but the most recent ATA devices.

If you do have workloads where you do lots of synchronous writes

> Just to be clear, i am NOT recommending that this change be mainlined;
> rather it is a reference to improve performance in the rare cases(like
> in the OP Stefan's case) where both the app performing DIRECT SYNC
> block IO and the disk firmware implementing CMD_FLUSH can NOT be
> modified. In which case the standard block driver behaviour of issuing
> a CMD_FLUSH with each write is too restrictive and thus modified using
> the patch.

Again, what your patch does is to explicitly ignore the data integrity
request from the application.  While this will usually be way faster,
it will also cause data loss.  Simply disabling the writeback cache
feature of the disk using hdparm will give you much better performance
than issueing all the FLUSH command, especially if they are non-queued,
but without breaking the gurantee to the application.
