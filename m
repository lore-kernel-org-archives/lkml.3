Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3FKXOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 19:14:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3FKXOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 19:14:43 -0400
Date: Tue, 11 Jun 2013 16:15:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>
Cc: linux-kernel@vger.kernel.org, jslaby@suse.cz, olof@lixom.net,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/tty: Don't hangup shared ttys
Message-ID: <20130611231518.GA28106@kroah.com>
References: <1370991787-24141-1-git-send-email-marcheu@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370991787-24141-1-git-send-email-marcheu@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:03:07PM -0700, Stéphane Marchesin wrote:
> When quickly restarting X servers, we can run into a situation where
> one X server quits while another one starts on the same tty. For a
> while, two X servers share the tty, and when the old X server
> eventually quits, the tty layer hangs up the tty, which among other
> things stubs out the tty's ioctl functions. Later on, the new X
> server (which shares the tty functions) tries to call some ioctls
> on the tty and fails because they have been replaced with the hungup
> versions. This in turn causes the new X server to abort.
> 
> This patch checks the tty->count to make sure we're the last
> consumer before hanging up a tty.
> 
> Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
> ---
>  drivers/tty/tty_io.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 6464029..62a0f02 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -619,6 +619,9 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
>  	if (!tty)
>  		return;
>  
> +	/* Don't hangup if there are other users */
> +	if (tty->count > 1)
> +		return;

What happens when you have a "real" tty that was hungup because it was
disconnected physically from the system yet userspace had a tty open?
You want those ttys to be hungup properly, right?  Doesn't this change
break that?

thanks,

greg k-h
