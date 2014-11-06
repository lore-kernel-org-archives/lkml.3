Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaKFCdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:33:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaKFCdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:33:11 -0500
Date: Wed, 5 Nov 2014 18:33:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH -next v2 10/26] tty: Don't take tty_mutex for tty count
 changes
Message-ID: <20141106023310.GA5035@kroah.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-11-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415207589-15967-11-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 12:12:53PM -0500, Peter Hurley wrote:
> Holding tty_mutex is no longer required to serialize changes to
> the tty_count or to prevent concurrent opens of closing ttys;
> tty_lock() is sufficient.
> 
> Reviewed-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_io.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index ea8c6cae8d12..e59de81c39a9 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1804,10 +1804,6 @@ int tty_release(struct inode *inode, struct file *filp)
>  	 * each iteration we avoid any problems.
>  	 */
>  	while (1) {
> -		/* Guard against races with tty->count changes elsewhere and
> -		   opens on /dev/tty */
> -
> -		mutex_lock(&tty_mutex);
>  		tty_lock_pair(tty, o_tty);
>  		tty_closing = tty->count <= 1;
>  		o_tty_closing = o_tty &&
> @@ -1840,7 +1836,6 @@ int tty_release(struct inode *inode, struct file *filp)
>  		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
>  				__func__, tty_name(tty, buf));
>  		tty_unlock_pair(tty, o_tty);
> -		mutex_unlock(&tty_mutex);
>  		schedule();
>  	}
>  

The code in my tree in this section of tty_release() looks a bit
different, so I had to hand-apply this patch.  I've included the version
I used below, please verify I didn't mess it up.

thanks,

greg k-h



diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index ea8c6cae8d12..e59de81c39a9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1804,10 +1804,6 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * each iteration we avoid any problems.
 	 */
 	while (1) {
-		/* Guard against races with tty->count changes elsewhere and
-		   opens on /dev/tty */
-
-		mutex_lock(&tty_mutex);
 		tty_lock_pair(tty, o_tty);
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
@@ -1840,7 +1836,6 @@ int tty_release(struct inode *inode, struct file *filp)
 		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
 				__func__, tty_name(tty, buf));
 		tty_unlock_pair(tty, o_tty);
-		mutex_unlock(&tty_mutex);
 		schedule();
 	}
 
@@ -1891,7 +1886,6 @@ int tty_release(struct inode *inode, struct file *filp)
 		read_unlock(&tasklist_lock);
 	}
 
-	mutex_unlock(&tty_mutex);
 	tty_unlock_pair(tty, o_tty);
 	/* At this point, the tty->count == 0 should ensure a dead tty
 	   cannot be re-opened by a racing opener */
