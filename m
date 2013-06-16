Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3FPRe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 13:34:59 -0400
Received: from smtp1.uu.se ([130.238.7.54]:53092 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab3FPRe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 13:34:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20925.63113.555846.464236@pilspetsen.it.uu.se>
Date: Sun, 16 Jun 2013 19:31:53 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Howells <dhowells@redhat.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Orion Poplawski <orion@cora.nwra.com>
Subject: Re: [PATCH] tty: Fix transient pty write() EIO
In-Reply-To: <1371153397-3687-1-git-send-email-peter@hurleysoftware.com>
References: <51B9F36B.6020802@hurleysoftware.com>
	<1371153397-3687-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley writes:
 > Commit 699390354da6c258b65bf8fa79cfd5feaede50b6
 > ('pty: Ignore slave pty close() if never successfully opened')
 > introduced a bug with ptys whereby a write() in parallel with an
 > open() on an existing pty could mistakenly indicate an I/O error.
 > 
 > Only indicate an I/O error if the condition on open() actually exists.
 > 
 > Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
 > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

I've tested this for two days on 3.9.0 (where the bug reproduces
easily for me, for some reason I can't seem to trigger it with
3.10-rc5), and with the patch I no longer see the bug.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

 > ---
 >  drivers/tty/pty.c | 13 +++++--------
 >  1 file changed, 5 insertions(+), 8 deletions(-)
 > 
 > diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
 > index 9c2f1bc..dd08d3d 100644
 > --- a/drivers/tty/pty.c
 > +++ b/drivers/tty/pty.c
 > @@ -238,14 +238,9 @@ static void pty_flush_buffer(struct tty_struct *tty)
 >  
 >  static int pty_open(struct tty_struct *tty, struct file *filp)
 >  {
 > -	int	retval = -ENODEV;
 > -
 >  	if (!tty || !tty->link)
 > -		goto out;
 > -
 > -	set_bit(TTY_IO_ERROR, &tty->flags);
 > +		return -ENODEV;
 >  
 > -	retval = -EIO;
 >  	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
 >  		goto out;
 >  	if (test_bit(TTY_PTY_LOCK, &tty->link->flags))
 > @@ -256,9 +251,11 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 >  	clear_bit(TTY_IO_ERROR, &tty->flags);
 >  	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 >  	set_bit(TTY_THROTTLED, &tty->flags);
 > -	retval = 0;
 > +	return 0;
 > +
 >  out:
 > -	return retval;
 > +	set_bit(TTY_IO_ERROR, &tty->flags);
 > +	return -EIO;
 >  }
 >  
 >  static void pty_set_termios(struct tty_struct *tty,
 > -- 
 > 1.8.1.2
 > 
