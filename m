Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab3ECQkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:40:42 -0400
Received: from smtp1.mail.ru ([94.100.176.129]:50206 "EHLO smtp1.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760490Ab3ECQkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:40:41 -0400
Message-ID: <5183F62A.1020801@list.ru>
Date: Fri, 03 May 2013 21:38:50 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jarkko Huijts <jarkko.huijts@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
References: <5183D196.2080305@list.ru> <20130503163008.GA30699@kroah.com>
In-Reply-To: <20130503163008.GA30699@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.05.2013 20:30, Greg KH пишет:
> We need some way to check the chars in the buffer, is the device you are
> using just very slow to respond to this request?  How slow?  Do you have
> a test case that we can see how it is affected?
Greg, unfortunately, I do have nothing.
The customer is in CC list, so maybe he will
provide the test-case, but I doubt.

Please, what are your concerns here?
The patch in question does this:
---
+ ret = usb_control_msg(port->serial->dev,
+ usb_rcvctrlpipe(port->serial->dev, 0),
+ FTDI_SIO_GET_MODEM_STATUS_REQUEST,
+ FTDI_SIO_GET_MODEM_STATUS_REQUEST_TYPE,
+ 0, priv->interface,
+ buf, 2, WDR_TIMEOUT);
---
Obviously, this is too expensive to call too frequently,
or am I missing something?
I asked the customer to comment out
tty_chars_in_buffer(tty) < WAKEUP_CHARS
line in n_tty.c, and he said that cured his problems,
so I think my guess was right.

The patch claims it only affects tcdrain() and close().
Its trivial to see it also affects poll(), select() and TIOCOUTQ
ioctl, so even from that it is already broken.
Why do you need a test-case for this?
