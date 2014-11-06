Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbaKFDqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:46:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKFDqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:46:36 -0500
Date: Wed, 5 Nov 2014 19:46:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH -next v2 10/26] tty: Don't take tty_mutex for tty count
 changes
Message-ID: <20141106034636.GA26944@kroah.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-11-git-send-email-peter@hurleysoftware.com>
 <20141106023310.GA5035@kroah.com>
 <545ADF52.9030401@hurleysoftware.com>
 <545AE1EE.30902@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545AE1EE.30902@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 09:50:22PM -0500, Peter Hurley wrote:
> On 11/05/2014 09:39 PM, Peter Hurley wrote:
> > On 11/05/2014 09:33 PM, Greg Kroah-Hartman wrote:
> >> On Wed, Nov 05, 2014 at 12:12:53PM -0500, Peter Hurley wrote:
> >>> Holding tty_mutex is no longer required to serialize changes to
> >>> the tty_count or to prevent concurrent opens of closing ttys;
> >>> tty_lock() is sufficient.
> >>>
> >>> Reviewed-by: Alan Cox <alan@linux.intel.com>
> >>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> >>> ---
> >>>  drivers/tty/tty_io.c | 6 ------
> >>>  1 file changed, 6 deletions(-)
> >>>
> >>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> >>> index ea8c6cae8d12..e59de81c39a9 100644
> >>> --- a/drivers/tty/tty_io.c
> >>> +++ b/drivers/tty/tty_io.c
> >>> @@ -1804,10 +1804,6 @@ int tty_release(struct inode *inode, struct file *filp)
> >>>  	 * each iteration we avoid any problems.
> >>>  	 */
> >>>  	while (1) {
> >>> -		/* Guard against races with tty->count changes elsewhere and
> >>> -		   opens on /dev/tty */
> >>> -
> >>> -		mutex_lock(&tty_mutex);
> >>>  		tty_lock_pair(tty, o_tty);
> >>>  		tty_closing = tty->count <= 1;
> >>>  		o_tty_closing = o_tty &&
> >>> @@ -1840,7 +1836,6 @@ int tty_release(struct inode *inode, struct file *filp)
> >>>  		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
> >>>  				__func__, tty_name(tty, buf));
> >>>  		tty_unlock_pair(tty, o_tty);
> >>> -		mutex_unlock(&tty_mutex);
> >>>  		schedule();
> >>>  	}
> >>>  
> >>
> >> The code in my tree in this section of tty_release() looks a bit
> >> different, so I had to hand-apply this patch.
> > 
> > Although there's nothing wrong with your version, I'm wondering why this
> > didn't apply cleanly.
> > 
> > While I go look at your tree, can you check that these patches are
> > sitting on top of the earlier two patches you applied to your tty-linus
> > branch; specifically 'tty: Fix high cpu load if tty is unreleasable' and
> > 'tty: Prevent "read/write wait queue active!" log flooding'?
> 
> Yep, that's the problem: your 'tty-testing' branch doesn't have the 3 patches
> from me that you put in your 'tty-linus' branch earlier this evening. Those are:
> 
> serial: Fix divide-by-zero fault in uart_get_divisor()
> tty: Fix high cpu load if tty is unreleasable
> tty: Prevent "read/write wait queue active!" log flooding
> 
> How can I help fix this?

Ah, didn't realize that was the issue, I've merged the branches together
now, so all should be good.

Sorry for the noise,

greg k-h
