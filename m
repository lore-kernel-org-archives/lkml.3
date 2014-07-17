Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaGQVXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:23:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:41839 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbaGQVXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:23:02 -0400
Date: Thu, 17 Jul 2014 17:14:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717211425.GU1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <53C8319A.8090108@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C8319A.8090108@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:27:06PM -0700, Andy Lutomirski wrote:
> > +	return urandom_read(NULL, buf, count, NULL);
> 
> This can return -ERESTARTSYS.  Does it need any logic to restart correctly?

Nope; because we only return -ERESTARTSYS when we haven't generated
any randomness yet.  The way /dev/urandom and /dev/random devices work
is that if we get interrupted, we return a short read.  We do *not*
resume generation of random bytes from where we got interrupted from
the signal handler.

This is consistent with the definition in the signal(7) man page:

       If a blocked call to one of the following interfaces is
       interrupted by a signal handler, then the call will be
       automatically restarted after the signal handler returns if the
       SA_RESTART flag was used; otherwise the call will fail with the
       error EINTR:

           * read(2), readv(2), write(2), writev(2), and ioctl(2)
             calls on "slow" devices.  A "slow" device is one where
             the I/O call may block for an indefinite time, for
             example, a terminal, pipe, or socket.  (A disk is not a
             slow device according to this definition.)  If an I/O
             call on a slow device has already transferred some data
             by the time it is interrupted by a signal handler, then
             the call will return a success status (normally, the
             number of bytes transferred).

And in answer to Zach's question along these lines, ERESTARTSYS gets
restarted or transformed into EINTR by the system call layer, so long
as you only set ERESTARTSYS when signal_pending(current) is true.  If
you accidentally set the return value to ERESTARTSYS when a signal is
not pending, this error code can escape out to user space, which is
considered a bug.  But we're using this correctly in
drivers/char/random.c.

						- Ted
