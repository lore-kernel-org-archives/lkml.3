Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3KTPhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:37:18 -0500
Received: from imap.thunk.org ([74.207.234.97]:60315 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3KTPhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:37:11 -0500
Date: Wed, 20 Nov 2013 10:37:03 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chinmay V S <cvs268@gmail.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        matthew@wil.cx
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131120153703.GA23160@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Chinmay V S <cvs268@gmail.com>,
	Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, matthew@wil.cx
References: <528CA73B.9070604@profihost.ag>
 <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
 <528CC36A.7080003@profihost.ag>
 <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:52:36PM +0530, Chinmay V S wrote:
> 
> If you have confirmed the performance numbers, then it indicates that
> the Intel 530 controller is more advanced and makes better use of the
> internal disk-cache to achieve better performance (as compared to the
> Intel 520). Thus forcing CMD_FLUSH on each IOP (negating the benefits
> of the disk write-cache and not allowing any advanced disk controller
> optimisations) has a more pronouced effect of degrading the
> performance on Intel 530 SSDs. (Someone with some actual info on Intel
> SSDs kindly confirm this.)

You might also want to do some power fail testing to make sure that
the SSD is actually flusing all of its internal Flash Translation
Layer (FTL) metadata to stable storage on every CMD_FLUSH command.

There are lots of flash media that don't do this, with the result that
I get lots of users whining at me when their file system stored on an
SD card has massive corruption after a power fail event.

Historically, Intel has been really good about avoiding this, but
since they've moved to using 3rd party flash controllers, I now advise
everyone who plans to use any flash storage, regardless of the
manufacturer, to do their own explicit power fail testing (hitting the
reset button is not good enough, you need to kick the power plug out
of the wall, or better yet, use a network controlled power switch you
so you can repeat the power fail test dozens or hundreds of times for
your qualification run) before being using flash storage in a mission
critical situation where you care about data integrity after a power
fail event.

IOW, make sure that the SSD isn't faster because it's playing fast and
loose with the FTL metadata....

Cheers,

						- Ted
