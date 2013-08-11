Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3HKFLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 01:11:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3HKFK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 01:10:58 -0400
Date: Sat, 10 Aug 2013 22:12:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Marineau <michael.marineau@coreos.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: send uevent after adding/removing mount_tag attribute
Message-ID: <20130811051223.GA17146@kroah.com>
References: <1376196825-19793-1-git-send-email-michael.marineau@coreos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376196825-19793-1-git-send-email-michael.marineau@coreos.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 12:53:45AM -0400, Michael Marineau wrote:
> This driver adds an attribute to the existing virtio device so a CHANGE
> event is required in order udev rules to make use of it. The ADD event
> happens before this driver is probed and unlike a more typical driver
> like a block device there isn't a higher level device to watch for.
> 
> Signed-off-by: Michael Marineau <michael.marineau@coreos.com>
> ---
>  net/9p/trans_virtio.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index e1c26b1..990afab 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -577,6 +577,10 @@ static int p9_virtio_probe(struct virtio_device *vdev)
>  	mutex_lock(&virtio_9p_lock);
>  	list_add_tail(&chan->chan_list, &virtio_chan_list);
>  	mutex_unlock(&virtio_9p_lock);
> +
> +	/* Let udev rules use the new mount_tag attribute. */
> +	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);

Ick, this is due to the sysfs file being added to the device after udev
was told the device was present.

I'm working on cleaning all of this up, to keep stuff like this from
happening in the first place, by creating all of the needed files before
userspace is told about the object, but it's a long slog, and will take
a year or so to get it all right, the first pieces of this are going to
be showing up in 3.12 or .13 at the earliest.

For now, I have no objection to this patch at all, especially as it
solves the problem for you.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

