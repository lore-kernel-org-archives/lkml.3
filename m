Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbaHGI3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:29:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:55348 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaHGI3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:29:08 -0400
Message-ID: <53E338CA.9070503@parallels.com>
Date: Thu, 7 Aug 2014 12:28:58 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Question on release_one_tty
References: <20140807082544.GP20553@moon>
In-Reply-To: <20140807082544.GP20553@moon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 12:25 PM, Cyrill Gorcunov wrote:
> Hi guys, could you please explain me the sequence
> 
> static void release_one_tty(struct work_struct *work)
> {
> 	struct tty_struct *tty =
> 		container_of(work, struct tty_struct, hangup_work);
> 	struct tty_driver *driver = tty->driver;
> 
> 	if (tty->ops->cleanup)
> 		tty->ops->cleanup(tty);
> 
> 	tty->magic = 0;
> -->	tty_driver_kref_put(driver);
> -->	module_put(driver->owner);
> 
> why tty_driver_kref_put is called before module_put? As far as I understand
> tty_driver_kref_put may call the destruct_tty_driver which eventually does
> 
> static void destruct_tty_driver(struct kref *kref)
> {
> 	struct tty_driver *driver = container_of(kref, struct tty_driver, kref);
> 	...
> 	kfree(driver->cdevs);
> 	kfree(driver->ports);
> 	kfree(driver->termios);
> 	kfree(driver->ttys);
> -->	kfree(driver);
> }
> 
> so that the module_put(driver->owner) would access freed memory. Should not we
> call the reverse module_put and then tty_driver_kref_put, or I miss something
> obvious?

If you put the module it can be unloaded at any time killing the code that would
be potentially required by kref_put.

> 	Cyrill
> .
> 

