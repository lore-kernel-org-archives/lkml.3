Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3GANjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:39:31 -0400
Received: from canardo.mork.no ([148.122.252.1]:44734 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab3GANj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:39:29 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: linux-kernel@vger.kernel.org
Subject: Wrapping EXPORT_SYMBOL_GPL symbols and re-exporting the wrappers with EXPORT_SYMBOL
Organization: m
Date: Mon, 01 Jul 2013 15:32:27 +0200
Message-ID: <87bo6m2yok.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got a new wireless router and stumbled across an odd set of
out-of-tree modules, where two GPL licensed modules were used by a third
proprietary licensed one.

The nice router vendor sent me the GPL'd source code, and as expected
the GPL modules are little more than wrappers working around the
EXPORT_SYMBOL_GPL restrictions.  Here's a complete example of one of
them:


/*
 * Copyright (C) 2010 silex technology, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/version.h>
#include <linux/workqueue.h>

MODULE_LICENSE("GPL");
MODULE_VERSION("1.0.0");
MODULE_AUTHOR("silex technology, Inc.");

static struct workqueue_struct *sxuptp_wq = NULL;

void sxuptp_wq_init_work(
	struct work_struct *work,
	void (*fn)(struct work_struct *))
{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
	INIT_WORK(work, (void (*)(void *))fn, work);
#else
	INIT_WORK(work, fn);
#endif
}
EXPORT_SYMBOL(sxuptp_wq_init_work);

int sxuptp_wq_enqueue(struct work_struct *work)
{
	return queue_work(sxuptp_wq, work);
}
EXPORT_SYMBOL(sxuptp_wq_enqueue);

void sxuptp_wq_flush(void)
{
	flush_workqueue(sxuptp_wq);
}
EXPORT_SYMBOL(sxuptp_wq_flush);

static int __init sxuptp_wq_init(void)
{
	sxuptp_wq = create_singlethread_workqueue("sxuptp-wq");
	if (!sxuptp_wq) {
		return -ENOMEM;
	}

	return 0;
}

static void __exit sxuptp_wq_cleanup(void)
{
	destroy_workqueue(sxuptp_wq);
}

module_init(sxuptp_wq_init);
module_exit(sxuptp_wq_cleanup);


create_singlethread_workqueue() expands to __alloc_workqueue_key() which
is EXPORT_SYMBOL_GPL, and flush_workqueue is also EXPORT_SYMBOL_GPL. The
wrapper around the latter can hardly be justified...

Is this sort of thing really acceptable?  The 3 symbols exported here
are all used by the proprietary module:

bjorn@nemi:~/tmp$ nm sxuptp.ko|grep _wq
         U sxuptp_wq_enqueue
         U sxuptp_wq_flush
         U sxuptp_wq_init_work
bjorn@nemi:~/tmp$ modinfo sxuptp.ko 
filename:       /home/bjorn/tmp/sxuptp.ko
author:         silex technology, Inc.
version:        1.2.3b2
license:        Proprietary
srcversion:     B0DEB8927F8F543614E5C47
depends:        sxuptp_wq
vermagic:       2.6.36.4 mod_unload modversions ARMv7 
parm:           netif:Name of the network interface to which the driver is bound (string)
parm:           numconn:Number of USB interface connections (read only) (int)
parm:           maxconn:Maximum number of USB interface connections (int)


Well, I don't like it one bit.  But I am not holding any copyrights
here, and even for those who are the fight is probably not worth it.
I just wanted to share my disgust with this.

And publicly naming the leeching company cannot harm. If I were a router
vendor I'd be really careful about dealing with these guys.  They are
most likely crossing a legal line, and if you choose to buy any of their
software then you are taking responsibility.  You may get away with it,
but is it really worth the risk?



Bjørn
