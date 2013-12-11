Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3LKJao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:30:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:56453 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3LKJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:30:41 -0500
Message-ID: <52A830BE.8080604@linutronix.de>
Date: Wed, 11 Dec 2013 10:30:38 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        jic23@kernel.org, lars@metafoo.de
Subject: Re: [PATCH v2] debugobject: add support for kref
References: <1382609345-29370-1-git-send-email-bigeasy@linutronix.de> <alpine.DEB.2.02.1310241615280.14242@ionos.tec.linutronix.de> <20131103193308.GA20998@linutronix.de> <20131211064538.GA20293@kroah.com>
In-Reply-To: <20131211064538.GA20293@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 07:45 AM, Greg KH wrote:
> I need an ack from Thomas or some other debugobjects-knowledgable
> developer before I can take this...

I have a v3 which I haven't posted yet. Basically the whole thing seems
to work. "Seems" means that I get a bunch of backtraces which I haven't
checked to see if it is a kref-accounting bug (something that should be
fixed) or something that is correct but kref isn't used properly.

One example is serial port init via tty_port_init(): It initializes
&port->kref. To use that kref you need to use tty_port_get()/put() and
more importantly dynamically allocate tty_port _or_ provide
port->ops->destruct callback. This seems not be done by everyone, for
instance gs_port_alloc() [0]. The question is this a bug and should be
fixed (and kref's debugobject is right here) or it is "legal" behavior.

I get another backtrace on "rmmod sg" which shows
ODEBUG: free active (active state 0) object type: kref hint:
kset_init+0xe/0x30
[<c112fec8>] kfree+0x128/0x280
[<c13784c2>] ? class_release+0x22/0x30
[<c13784c2>] class_release+0x22/0x30
[<c12da3bd>] kobject_cleanup+0x2d/0x70
[<c12da2c7>] kobject_put+0x67/0xa0
[<c12da34f>] kset_unregister+0xf/0x20
[<c13787b3>] class_destroy+0x23/0x30
[<f850ee62>] exit_sg+0x17/0x3c [sg]

so it is triggered by class_destory() and I haven't have the time check
what is wrong here.

Based on this I would like to know what could be the best way forward
here. Post v3 and work on this backtraces before it gets merged or
after it gets merged.

[0] drivers/usb/gadget/u_serial.c

> thanks,
> 
> greg k-h
> 
Sebastian
