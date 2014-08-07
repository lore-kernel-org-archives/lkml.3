Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaHGIea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:34:30 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:63652 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaHGIe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:34:26 -0400
Date: Thu, 7 Aug 2014 12:34:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Question on release_one_tty
Message-ID: <20140807083423.GQ20553@moon>
References: <20140807082544.GP20553@moon>
 <53E338CA.9070503@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E338CA.9070503@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 12:28:58PM +0400, Pavel Emelyanov wrote:
> On 08/07/2014 12:25 PM, Cyrill Gorcunov wrote:
> > Hi guys, could you please explain me the sequence
> > 
> > static void release_one_tty(struct work_struct *work)
> > {
> > 	struct tty_struct *tty =
> > 		container_of(work, struct tty_struct, hangup_work);
> > 	struct tty_driver *driver = tty->driver;
> > 
> > 	if (tty->ops->cleanup)
> > 		tty->ops->cleanup(tty);
> > 
> > 	tty->magic = 0;
> > -->	tty_driver_kref_put(driver);
> > -->	module_put(driver->owner);
> > 
> > why tty_driver_kref_put is called before module_put? As far as I understand
> > tty_driver_kref_put may call the destruct_tty_driver which eventually does
> > 
> > static void destruct_tty_driver(struct kref *kref)
> > {
> > 	struct tty_driver *driver = container_of(kref, struct tty_driver, kref);
> > 	...
> > 	kfree(driver->cdevs);
> > 	kfree(driver->ports);
> > 	kfree(driver->termios);
> > 	kfree(driver->ttys);
> > -->	kfree(driver);
> > }
> > 
> > so that the module_put(driver->owner) would access freed memory. Should not we
> > call the reverse module_put and then tty_driver_kref_put, or I miss something
> > obvious?
> 
> If you put the module it can be unloaded at any time killing the code that would
> be potentially required by kref_put.

So how this code supposed to work then? I mean tty_driver_kref_put must never call
for destruct_tty_driver, otherwise we're accessing freed memory.
