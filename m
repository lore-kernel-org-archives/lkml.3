Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaKFCki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:40:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKFCkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:40:36 -0500
Date: Wed, 5 Nov 2014 18:40:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH -next v2 11/26] tty: Don't release tty locks for wait
 queue sanity check
Message-ID: <20141106024035.GA14424@kroah.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-12-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415207589-15967-12-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 12:12:54PM -0500, Peter Hurley wrote:
> Releasing the tty locks while waiting for the tty wait queues to
> be empty is no longer necessary nor desirable. Prior to
> "tty: Don't take tty_mutex for tty count changes", dropping the
> tty locks was necessary to reestablish the correct lock order between
> tty_mutex and the tty locks. Dropping the global tty_mutex was necessary;
> otherwise new ttys could not have been opened while waiting.
> 
> However, without needing the global tty_mutex held, the tty locks for
> the releasing tty can now be held through the sleep. The sanity check
> is for abnormal conditions caused by kernel bugs, not for recoverable
> errors caused by misbehaving userspace; dropping the tty locks only
> allows the tty state to get more sideways.
> 
> Reviewed-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_io.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index e59de81c39a9..b008e2b38d54 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1798,13 +1798,10 @@ int tty_release(struct inode *inode, struct file *filp)
>  	 * first, its count will be one, since the master side holds an open.
>  	 * Thus this test wouldn't be triggered at the time the slave closes,
>  	 * so we do it now.
> -	 *
> -	 * Note that it's possible for the tty to be opened again while we're
> -	 * flushing out waiters.  By recalculating the closing flags before
> -	 * each iteration we avoid any problems.
>  	 */
> +	tty_lock_pair(tty, o_tty);
> +
>  	while (1) {
> -		tty_lock_pair(tty, o_tty);
>  		tty_closing = tty->count <= 1;
>  		o_tty_closing = o_tty &&
>  			(o_tty->count <= (pty_master ? 1 : 0));
> @@ -1835,7 +1832,6 @@ int tty_release(struct inode *inode, struct file *filp)
>  
>  		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
>  				__func__, tty_name(tty, buf));
> -		tty_unlock_pair(tty, o_tty);
>  		schedule();
>  	}
>  

This patch had the same type of fuzz as the previous one, the version I
used was:


diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e59de81c39a9..b008e2b38d54 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1798,13 +1798,10 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * first, its count will be one, since the master side holds an open.
 	 * Thus this test wouldn't be triggered at the time the slave closes,
 	 * so we do it now.
-	 *
-	 * Note that it's possible for the tty to be opened again while we're
-	 * flushing out waiters.  By recalculating the closing flags before
-	 * each iteration we avoid any problems.
 	 */
+	tty_lock_pair(tty, o_tty);
+
 	while (1) {
-		tty_lock_pair(tty, o_tty);
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
 			(o_tty->count <= (pty_master ? 1 : 0));
@@ -1835,7 +1832,6 @@ int tty_release(struct inode *inode, struct file *filp)
 
 		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
 				__func__, tty_name(tty, buf));
-		tty_unlock_pair(tty, o_tty);
 		schedule();
 	}
 
