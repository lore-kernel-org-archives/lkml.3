Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab3CGVxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:53:08 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:42764 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab3CGVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:53:04 -0500
Message-ID: <1362693143.4219.1.camel@thor.lan>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
From: Peter Hurley <peter@hurleysoftware.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Mar 2013 16:52:23 -0500
In-Reply-To: <20130307094320.GB23635@localhost>
References: <1362085054.3337.20.camel@thor.lan> <51361724.4050107@suse.cz>
	 <20130306165211.GA23635@localhost> <1362597296.18799.198.camel@thor.lan>
	 <20130307094320.GB23635@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 10:43 +0100, Johan Hovold wrote:
> On Wed, Mar 06, 2013 at 02:14:56PM -0500, Peter Hurley wrote:
> > On Wed, 2013-03-06 at 17:52 +0100, Johan Hovold wrote:
> > > Yes, I did. First, the order should not matter for blocked opens as they
> > > will exit their wait loops based on tty_hung_up_p(filp) either way.
> > 
> > Only if the open() was ever successful, otherwise the filp won't be in
> > the tty->tty_files list. That's why the blocking opens also check
> > ASYNC_INITIALIZED (or ASYNCB_INITIALIZED depending on which they use).
> > Which is why I said it was actually better to shutdown() first, then
> > wake up the blocked opens.
> 
> ASYNC_INITIALIZED have also been cleared when the blocked opens are
> being woken up from tty_port_close_end.
> 
> And the filp is added to tty_files before open() is called:
> 
> ===>    tty_add_file(tty, filp);
> 
> 	check_tty_count(tty, __func__);
> 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
> 	    tty->driver->subtype == PTY_TYPE_MASTER)
> 		noctty = 1;
> #ifdef TTY_DEBUG_HANGUP
> 	printk(KERN_DEBUG "%s: opening %s...\n", __func__, tty->name);
> #endif
> 	if (tty->ops->open)
> ===>		retval = tty->ops->open(tty, filp);
> 
> so a blocked open must have hung_up_tty_fops when woken up from hangup,
> right?

You're right, my mistake.

> Either way, postponing wake-up somewhat in tty_port_hangup should be
> fine.

Yep.

Regards,
Peter Hurley

