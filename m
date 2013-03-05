Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3CEWUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:20:49 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:53488 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CEWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:20:48 -0500
Message-ID: <1362522029.18799.145.camel@thor.lan>
Subject: Re: [PATCH v3 00/23] ldisc fixes
From: Peter Hurley <peter@hurleysoftware.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Date: Tue, 05 Mar 2013 17:20:29 -0500
In-Reply-To: <20130305205033.GA5771@linutronix.de>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <20130305205033.GA5771@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[--cc Alan Cox]

On Tue, 2013-03-05 at 21:50 +0100, Sebastian Andrzej Siewior wrote:
> * Peter Hurley | 2013-02-05 15:20:15 [-0500]:
> 
> >  Please re-test with your dummy_hcd/g_nokia testcase, although
> >  I'm not convinced that usb gadget is using tty_hangup() appropriately.
> >  tty drivers use this for async carrier loss coming from an IRQ
> >  which will be disabled if the tty has been shutdown. Does gserial
> >  prevent async hangup to a dead tty in a similar fashion?
> 
> Not sure I understood. tty_hangup() is only called from within
> gserial_disconnect() which calls right after usb_ep_disable(). After
> usb_ep_disable() no further serial packets can be received until the
> endpoints are re-enabled. This happens in gserial_connect().

That's why I asked. There are two potential issues:

First, tty_hangup() is asynchronous -- ie., it returns immediately. It
does not wait for the tty device to actually perform the hangup. So if
the gadget layers start cleanup immediately after, expecting that they
won't get a flurry of tty calls, that would be bad.

tty_vhangup() is synchronous -- ie., you wait while it cleans up. This
is what the usb serial core does on it's disconnect() method. But I
didn't research further if the circumstances were the same.

Second, when the hangup actually does run -- in __tty_hangup() -- it
expects the tty to exist. I didn't go looking through the gadget layers
to see if the tty was disposed some other way, which might race the
asynchronous tty hangup.

Thanks,
Peter Hurley



