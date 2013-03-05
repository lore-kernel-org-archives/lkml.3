Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3CEXOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:14:51 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:57286 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3CEXOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:14:49 -0500
Message-ID: <1362525272.18799.165.camel@thor.lan>
Subject: Re: [PATCH v3 00/23] ldisc fixes
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 05 Mar 2013 18:14:32 -0500
In-Reply-To: <51367433.4060408@suse.cz>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	  <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	  <20130305205033.GA5771@linutronix.de>
	 <1362522029.18799.145.camel@thor.lan> <51367433.4060408@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[now this discussion has turned to usb gadget
+cc Felipe Balbi, linux-usb, -cc Dave Jones, Ilya Zykov]

On Tue, 2013-03-05 at 23:39 +0100, Jiri Slaby wrote:
> On 03/05/2013 11:20 PM, Peter Hurley wrote:
> > [--cc Alan Cox]
> > 
> > On Tue, 2013-03-05 at 21:50 +0100, Sebastian Andrzej Siewior wrote:
> >> * Peter Hurley | 2013-02-05 15:20:15 [-0500]:
> >>
> >>>  Please re-test with your dummy_hcd/g_nokia testcase, although
> >>>  I'm not convinced that usb gadget is using tty_hangup() appropriately.
> >>>  tty drivers use this for async carrier loss coming from an IRQ
> >>>  which will be disabled if the tty has been shutdown. Does gserial
> >>>  prevent async hangup to a dead tty in a similar fashion?
> >>
> >> Not sure I understood. tty_hangup() is only called from within
> >> gserial_disconnect() which calls right after usb_ep_disable(). After
> >> usb_ep_disable() no further serial packets can be received until the
> >> endpoints are re-enabled. This happens in gserial_connect().
> > 
> > That's why I asked. There are two potential issues:
> > 
> > First, tty_hangup() is asynchronous -- ie., it returns immediately. It
> > does not wait for the tty device to actually perform the hangup. So if
> > the gadget layers start cleanup immediately after, expecting that they
> > won't get a flurry of tty calls, that would be bad.
> 
> Sorry, I missed what driver is this?

g_serial.

drivers/usb/gadget/u_serial.c

> > tty_vhangup() is synchronous -- ie., you wait while it cleans up. This
> > is what the usb serial core does on it's disconnect() method. But I
> > didn't research further if the circumstances were the same.
> 
> Even when tty_vhangup returns, it does not guarantee a closed tty. And
> it also does not guarantee that any of tty->ops won't be called. The
> latter is true only for devices that can be consoles. (For those,
> file->ops are not redirected.) In that case one needs to wait for
> port->count to become 0.

Perhaps I was oversimplifying.

But my point was I doubt usb gadget is conducting its teardown safely
wrt tty.

Regards,
Peter Hurley



