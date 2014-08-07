Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbaHGIZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:25:48 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39586 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaHGIZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:25:46 -0400
Date: Thu, 7 Aug 2014 12:25:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Subject: Question on release_one_tty
Message-ID: <20140807082544.GP20553@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, could you please explain me the sequence

static void release_one_tty(struct work_struct *work)
{
	struct tty_struct *tty =
		container_of(work, struct tty_struct, hangup_work);
	struct tty_driver *driver = tty->driver;

	if (tty->ops->cleanup)
		tty->ops->cleanup(tty);

	tty->magic = 0;
-->	tty_driver_kref_put(driver);
-->	module_put(driver->owner);

why tty_driver_kref_put is called before module_put? As far as I understand
tty_driver_kref_put may call the destruct_tty_driver which eventually does

static void destruct_tty_driver(struct kref *kref)
{
	struct tty_driver *driver = container_of(kref, struct tty_driver, kref);
	...
	kfree(driver->cdevs);
	kfree(driver->ports);
	kfree(driver->termios);
	kfree(driver->ttys);
-->	kfree(driver);
}

so that the module_put(driver->owner) would access freed memory. Should not we
call the reverse module_put and then tty_driver_kref_put, or I miss something
obvious?

	Cyrill
