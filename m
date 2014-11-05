Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaKEQyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:54:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbaKEQyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:54:23 -0500
Date: Wed, 5 Nov 2014 17:54:18 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] chardev: Increment cdev reference count when i_cdev
 references it
Message-ID: <20141105165418.GD30558@quack.suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
 <1414008853-13200-3-git-send-email-jack@suse.cz>
 <20141104144611.GE7996@ZenIV.linux.org.uk>
 <20141104153752.GB21902@quack.suse.cz>
 <20141104154030.GI7996@ZenIV.linux.org.uk>
 <20141104155543.GD21902@quack.suse.cz>
 <20141104160301.GJ7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160301.GJ7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 16:03:03, Al Viro wrote:
> On Tue, Nov 04, 2014 at 04:55:43PM +0100, Jan Kara wrote:
> > > That consequence looks broken, IMO.
> >   Hum, it already behaves for block devices that way (and noone complained
> > - but admittedly block devices tied to strange modules are less common than
> > character devices). Also rmmod isn't that common IMO, but I see your point
> > that it's unintuitive behavior.
> 
> Umm...  Since when?  The last time I looked, bdev module refcounts were
> tied to struct gendisk, not to struct block_device.
  Ah, right you are. So how about clearing i_cdev and dropping reference to
it when inode is not open anymore? Doing first open after a cleanup would
be more expensive but it doesn't seem too much. For block devices first
open of it is also more expensive - although there bd_openers is per block
device while for character devices we would have the openers per device
inode.  I don't think that's a real difference in practice unless you run
some container service. If you think it would help, we could add some
intermediate structure for character devices with similar rules like struct
block_device for block devices (and character device references would be
handled in the same way as we handle gendisk references for block devices).
However I don't think it's really worth the bother...


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
