Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3AaDwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:52:36 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:55676 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756869Ab3AaDwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:52:31 -0500
Message-ID: <1359604220.3325.55.camel@thor.lan>
Subject: Re: [PATCH] tty: Fix ptmx open without closed slave.
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Wed, 30 Jan 2013 22:50:20 -0500
In-Reply-To: <50D20EB5.30900@ilyx.ru>
References: <50D20EB5.30900@ilyx.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilya,

On Wed, 2012-12-19 at 23:00 +0400, Ilya Zykov wrote:
> When we are opening ptmx, we have closed pts, by description.
> Now only if we open and after close all pts' descriptions, pty_close() sets
> this bit correctly
> 
> Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
> ---
>  drivers/tty/pty.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index 1ce1362..7b69307 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -659,6 +659,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
>  	retval = ptm_driver->ops->open(tty, filp);
>  	if (retval)
>  		goto err_release;
> +	set_bit(TTY_OTHER_CLOSED, &tty->flags); /* THE SLAVE STILL CLOSED */

I'm not sure this is a good idea.

Ideally, if you were only trying to make the logic "more correct", this
change would be here, instead:
	mutex_unlock(&tty_mutex);

	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
+	set_bit(TTY_OTHER_CLOSED, &tty->flags); /* THE SLAVE STILL CLOSED */
	tty->driver_data = inode;

	tty_add_file(tty, filp);

Of course, that would be a bad idea because then the master pty_open()
would fail because of the test in pty_open().

Setting TTY_OTHER_CLOSED after the open() -- as you've done -- appears
to leave a race open when this bit is not set but while a slave open()
may still be attempted.

But as far as I can tell, this change doesn't actually affect any code
branches -- that is, doesn't actually do anything -- so no such race
exists. Is that correct?

Regards,
Peter Hurley

