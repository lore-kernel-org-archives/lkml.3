Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3CQSuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:50:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:35143 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab3CQSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:50:11 -0400
Date: Sun, 17 Mar 2013 19:50:00 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 00/23] ldisc fixes
Message-ID: <20130317185000.GC12749@linutronix.de>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
 <20130305205033.GA5771@linutronix.de>
 <1362522029.18799.145.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362522029.18799.145.camel@thor.lan>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley | 2013-03-05 17:20:29 [-0500]:

>> Not sure I understood. tty_hangup() is only called from within
>> gserial_disconnect() which calls right after usb_ep_disable(). After
>> usb_ep_disable() no further serial packets can be received until the
>> endpoints are re-enabled. This happens in gserial_connect().
>
>That's why I asked. There are two potential issues:
>
>First, tty_hangup() is asynchronous -- ie., it returns immediately. It
>does not wait for the tty device to actually perform the hangup. So if
>the gadget layers start cleanup immediately after, expecting that they
>won't get a flurry of tty calls, that would be bad.

tty_hangup() is called from interrupt context usually after the USB
cable has been unplugged. It is also possible that if the host requests
the function twice, it will (on the second invocation without a reset)
call tty_hangup() followed by tty_wakeup() to start the new session.

>
>tty_vhangup() is synchronous -- ie., you wait while it cleans up. This
>is what the usb serial core does on it's disconnect() method. But I
>didn't research further if the circumstances were the same.
Okay.

>Second, when the hangup actually does run -- in __tty_hangup() -- it
>expects the tty to exist. I didn't go looking through the gadget layers
>to see if the tty was disposed some other way, which might race the
>asynchronous tty hangup.

It calls wake_up_interruptible() expecting the user to leave. The
node is removed on module removal.

Is there any change of API you suggest?

>Thanks,
>Peter Hurley

Sebastian
