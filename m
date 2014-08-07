Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbaHGJSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:18:17 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59422 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaHGJSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:18:15 -0400
Date: Thu, 7 Aug 2014 13:18:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Question on release_one_tty
Message-ID: <20140807091812.GR20553@moon>
References: <20140807082544.GP20553@moon>
 <53E338CA.9070503@parallels.com>
 <20140807083423.GQ20553@moon>
 <53E34158.9070009@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E34158.9070009@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 01:05:28PM +0400, Pavel Emelyanov wrote:
> > 
> > So how this code supposed to work then? I mean tty_driver_kref_put must never call
> > for destruct_tty_driver, otherwise we're accessing freed memory.
> 
> mod = driver->owner;
> tty_driver_kref_put(driver);
> module_put(mod);
> 
> Check the upstream whether the same issue exists there.

Same in tty.git

static void release_one_tty(struct work_struct *work)
{
	struct tty_struct *tty =
		container_of(work, struct tty_struct, hangup_work);
	struct tty_driver *driver = tty->driver;

	if (tty->ops->cleanup)
		tty->ops->cleanup(tty);

	tty->magic = 0;
	tty_driver_kref_put(driver);
	module_put(driver->owner);

	spin_lock(&tty_files_lock);
	list_del_init(&tty->tty_files);
	spin_unlock(&tty_files_lock);

	put_pid(tty->pgrp);
	put_pid(tty->session);
	free_tty_struct(tty);
}

so I think yes, the fix is needed. I'll prepare the patch
and test/post for review.
