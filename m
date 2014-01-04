Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaADGJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 01:09:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaADGJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 01:09:30 -0500
Date: Sat, 4 Jan 2014 06:09:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [BUG]NULL pointer dereference at 0000000000000008
 __blkdev_put+0x17f/0x1d0
Message-ID: <20140104060925.GF10323@ZenIV.linux.org.uk>
References: <52C19767.60000@profitbricks.com>
 <52C5331E.3050304@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C5331E.3050304@profitbricks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 10:36:30AM +0100, Jack Wang wrote:

> > Bug happened at line 1486, looks disk->fops is NULL here for some
> > reason, is it reasonable to add a check like:
> > 
> > if (disk->fops)
> > 	if (disk->fops->release)
> > 		ret = disk->fops->release(disk, mode);
> > 
> > 
> > Happy New Year and Best regards:)
> > Jack
> > 
> 
> Ping, could you share opnions on this, attached with patch I proposaled.

Sorry, had been sick since mid-December ;-/  The patch is not a good idea -
in the best case it's papering over a bug (and insufficiently so, at that,
since there are other places where disk->fops->some_method is checked).

gendisk->fops should never be assigned NULL; it starts life with NULL
->fops, but that should be assigned a non-NULL value (and never modified
afterwards) before anyone can see it.  Moreover, even if some driver has
fscked up and forgot to initialize the damn thing, get_gendisk() would've
refused to return such a thing to any callers (including __blkdev_get()).
Note that __blkdev_get() would oops on such a thing if get_gendisk()
somehow returned it.

Looks like something is shitting over bdev->bd_disk or bdev->bd_disk->fops.
The offsets in the disassembled code are all wrong (including that from
beginning of function to oopsing instruction), but the code match is good,
so I agree that we are hitting bdev->bd_disk->fops == NULL here.  The
question is how it has happened - that's where the real bug is...

How reproducible it is?  And which kernel, while we are at it?  This area
didn't get a lot of changes lately, but still...
