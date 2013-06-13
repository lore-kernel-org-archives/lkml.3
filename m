Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab3FMKjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:39:53 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:58689 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3FMKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:39:52 -0400
Date: Thu, 13 Jun 2013 12:39:50 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Howells <dhowells@redhat.com>
Subject: Re: Strange intermittent EIO error when writing to stdout since
 v3.8.0
Message-ID: <20130613103950.GB519@x4>
References: <20130606115417.GA520@x4>
 <51B09A26.3080603@hurleysoftware.com>
 <20130606143750.GB520@x4>
 <51B1FEB1.8040103@hurleysoftware.com>
 <20914.9444.867518.719403@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20914.9444.867518.719403@pilspetsen.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.06.07 at 20:22 +0200, Mikael Pettersson wrote:
> Peter Hurley writes:
>  > Based on the other reports from Mikael and David, I suspect this problem
>  > may have to do with my commit 699390354da6c258b65bf8fa79cfd5feaede50b6:
>  > 
>  >    pty: Ignore slave pty close() if never successfully opened
>  > 
>  > This commit poisons the pty under certain error conditions that may
>  > occur from parallel open()s (or parallel close() with pending write()).
>  > 
>  > It's unclear to me which error condition is triggered and how user-space
>  > got an open file descriptor but that seems the most likely. Is the problem
>  > reproducible enough that a debug patch would likely trigger?
> 
> In my case the problem occurred frequently enough that I've been forced
> to change my build procedures to avoid it.  I'd welcome a debug patch.

Since apparently no debugging patch is forthcoming, maybe it's time to
test the simple revert of commit 699390354da.

So can you guys please apply the following patch and see if the issue
goes away?

Thanks.

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 59bfaec..f5801a6 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -38,12 +38,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	if (tty->driver->subtype == PTY_TYPE_MASTER)
 		WARN_ON(tty->count > 1);
 	else {
-		if (test_bit(TTY_IO_ERROR, &tty->flags))
-			return;
 		if (tty->count > 2)
 			return;
 	}
-	set_bit(TTY_IO_ERROR, &tty->flags);
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
 	tty->packet = 0;
@@ -249,8 +246,6 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	if (!tty || !tty->link)
 		goto out;
 
-	set_bit(TTY_IO_ERROR, &tty->flags);
-
 	retval = -EIO;
 	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
 		goto out;
@@ -259,7 +254,6 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	if (tty->driver->subtype == PTY_TYPE_SLAVE && tty->link->count != 1)
 		goto out;
 
-	clear_bit(TTY_IO_ERROR, &tty->flags);
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;

-- 
Markus
