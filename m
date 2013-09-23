Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3IWN1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab3IWN1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:27:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Josh Durgin <josh.durgin@inktank.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: check CAP_SYS_ADMIN before calling driver BLKROSET
References: <1379622557-11042-1-git-send-email-josh.durgin@inktank.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Sep 2013 09:27:02 -0400
In-Reply-To: <1379622557-11042-1-git-send-email-josh.durgin@inktank.com> (Josh
	Durgin's message of "Thu, 19 Sep 2013 13:29:17 -0700")
Message-ID: <x49y56ny8gp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Durgin <josh.durgin@inktank.com> writes:

> Calling the driver-specific ioctl first, then bailing because
> CAP_SYS_ADMIN is not set, can lead to an inconsistency between the
> driver and the block layer, where one thinks the device is read only,
> and the other considers it readwrite.

How?  If the driver returns anything other than EINVAL, ENOTTY or
ENOIOCTLCMD, that return code is propagated to the caller (that's what
the is_unrecognized_ioctl bit is about).

So, what problem are you actually running into?

> Fix this by checking the capability first, like the rest of the block
> ioctls that require it. This bug was introduced pre-git in commit
> 23deaf89e3075b9271c7f48a2764ae3ed8f9573a.

Mentioning a commit pre-git is confusing, to say the least.  You could
at least include a pointer to the tree you are using to generate this
hash, or maybe even include the commit message.

Anyway, if it wasn't clear:

NACK

Cheers,
Jeff

>
> Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
> ---
>  block/ioctl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/ioctl.c b/block/ioctl.c
> index a31d91d..6e5933e 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -293,11 +293,11 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  		return 0;
>  
>  	case BLKROSET:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
>  		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
>  		if (!is_unrecognized_ioctl(ret))
>  			return ret;
> -		if (!capable(CAP_SYS_ADMIN))
> -			return -EACCES;
>  		if (get_user(n, (int __user *)(arg)))
>  			return -EFAULT;
>  		set_device_ro(bdev, n);
