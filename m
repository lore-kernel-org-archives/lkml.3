Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3IOP0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 11:26:45 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52902 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab3IOP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 11:26:44 -0400
Message-ID: <5235DFD2.4050008@kernel.org>
Date: Sun, 15 Sep 2013 17:26:58 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yann Droneaud <ydroneaud@opteya.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH v3 8/8] industrialio: use anon_inode_getfd() with O_CLOEXEC
 flag
References: <cover.1378460926.git.ydroneaud@opteya.com> <91c7332bc0616447587ec64a0c8f512a1d9e498d.1378460926.git.ydroneaud@opteya.com>
In-Reply-To: <91c7332bc0616447587ec64a0c8f512a1d9e498d.1378460926.git.ydroneaud@opteya.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/13 11:39, Yann Droneaud wrote:
> IIO uses anon_inode_get() to allocate file descriptors as part
> of its ioctls. But those ioctls are lacking a flag argument
> allowing userspace to choose options for the newly opened file
> descriptor.
> 
> In such case it's advised to use O_CLOEXEC by default so that
> userspace is allowed to choose, without race, if the file descriptor
> is going to be inherited across exec().
> 
> KVM usage of anon_inode_getfd() was fixed in a previous patchset [1],
> so IIO is the only subsystem using anon_inode_getfd() with a fixed set
> of flags not including O_CLOEXEC.
> 
> This patch set O_CLOEXEC flag on the event file descriptor created
> with anon_inode_getfd() to not leak file descriptors across exec().
> 
> Links:
> 
> - Secure File Descriptor Handling (Ulrich Drepper, 2008)
>   http://udrepper.livejournal.com/20407.html
> 
> - Excuse me son, but your code is leaking !!! (Dan Walsh, March 2012)
>   http://danwalsh.livejournal.com/53603.html
> 
> - [1] kvm: use anon_inode_getfd() with O_CLOEXEC flag
>   http://lkml.kernel.org/r/cover.1377372576.git.ydroneaud@opteya.com
> 
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> Link: http://lkml.kernel.org/r/cover.1378460926.git.ydroneaud@opteya.com

Thanks Yann.  I had no idea about this issue but your well supported description
above made this easy to review.

Applied to the togreg branch of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
as it's not a regression but if there is support for pushing this back to stable
I personally am not against it.

Jonathan
>
 ---
>  drivers/iio/industrialio-event.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
> index 10aa9ef..2390e3d 100644
> --- a/drivers/iio/industrialio-event.c
> +++ b/drivers/iio/industrialio-event.c
> @@ -159,7 +159,7 @@ int iio_event_getfd(struct iio_dev *indio_dev)
>  	}
>  	spin_unlock_irq(&ev_int->wait.lock);
>  	fd = anon_inode_getfd("iio:event",
> -				&iio_event_chrdev_fileops, ev_int, O_RDONLY);
> +				&iio_event_chrdev_fileops, ev_int, O_RDONLY | O_CLOEXEC);
>  	if (fd < 0) {
>  		spin_lock_irq(&ev_int->wait.lock);
>  		__clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
> 
