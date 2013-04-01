Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab3DAQ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:28:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38925 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab3DAQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:28:07 -0400
Date: Mon, 1 Apr 2013 17:28:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
        sqazi@google.com, yan@linux.vnet.ibm.com
Subject: Re: [PATCH] loop: prevent bdev freeing while device in use
Message-ID: <20130401162800.GB21522@ZenIV.linux.org.uk>
References: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 04:58:05AM -0700, Anatol Pomozov wrote:
>  		lo->lo_flags |= LO_FLAGS_PARTSCAN;
>  	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
>  		ioctl_by_bdev(bdev, BLKRRPART, 0);
> +
> +	/* bdev lifecycle is defined by its bd_inode (see
> +	 * struct bdev_inode usage). In case of loop device we need to make
> +	 * sure that bdev deallocation will not happen between loop_set_fd()
> +	 * and loop_clr_fd() invocations. To do this we need to hold
> +	 * bdev inode here and put it later in loop_clr_fd().
> +	 */
> +	ihold(bdev->bd_inode);

That's open-coded bdgrab()

> +	if (bdev) {
> +		BUG_ON(atomic_read(&bdev->bd_inode->i_count) < 2);
> +		iput(bdev->bd_inode);

... and that - bdput() (I'd drop that BUG_ON())
