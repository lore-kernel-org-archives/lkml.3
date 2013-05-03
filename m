Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363Ab3ECUeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:34:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762729Ab3ECUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:34:20 -0400
Date: Fri, 3 May 2013 13:34:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stas Sergeev <stsp@list.ru>
Cc: Jarkko Huijts <jarkko.huijts@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
Message-ID: <20130503203419.GA25932@kroah.com>
References: <5183D196.2080305@list.ru>
 <20130503163008.GA30699@kroah.com>
 <5183F62A.1020801@list.ru>
 <20130503165231.GA1966@kroah.com>
 <5183FC83.8090602@list.ru>
 <20130503171618.GA16686@kroah.com>
 <51840186.7000608@list.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51840186.7000608@list.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:27:18PM +0400, Stas Sergeev wrote:
> 03.05.2013 21:16, Greg KH пишет:
> 
> >Sounds like an application is doing a foolish thing and should stop it.
> Its not.
> The app is quering only for _input_ (specifying only read fds
> to select). But the select() in linux is implemented the way that
> even when it polls for input, it will still call tty_chars_in_buffer()...

I think that's the line dicipline doing this, not select itself.

> >There's no guarantee as to how long select or an ioctl will take, and
> >now that we have fixed another bug, this device is slower.
> >
> >If you change hardware types to use a different usb to serial chip, that
> >select call might take 4 times as long.  Are we somehow supposed to
> >change the kernel to "fix" that?
> Previously, the kernel was not calling to a device at all, so
> select() was independent of the chip, and it was fast. I was
> not aware you changed that willingly.

I don't understand, what do you mean by this?  Some drivers just return
the value of an internally held number, and don't query the device.

The only way the FTDI driver can determine if the hardware buffer on the
chip way out on the end of the USB cable is empty or not, is to query
it.  So the driver now does so.

> >>>>I asked the customer to comment out
> >>>>tty_chars_in_buffer(tty) < WAKEUP_CHARS
> >>>>line in n_tty.c, and he said that cured his problems,
> >>>>so I think my guess was right.
> >>>What exactly is the "problem" being seen?
> >>No idea.
> >>Well, I can make a test-case that does 1000000 select() calls
> >>in a loop and time it. This is probably the best I can do.
> >That's really not a valid test case, as it's nothing that we ever
> >optimize a serial driver for.  Throughput is the proper thing to care
> >about, right?
> Sure, but the throughput was not improved by the aforementioned
> patch, so what was the upside of it?
> 
> >To actually determine how many characters the device has in its buffer.
> You are adding only 1 char, but the time to query TEMT is
> probably longer than to xmit 1 char. So how could it help
> in some real scenario? When you done quering TEMT, the
> char is actually already sent, so the effect is quite the reverse.
> 
> My scenario is:
> the app calls select() before xmitting every char.

Every character?  Why?  That defeats all of the buffering that the
kernel, and the hardware, provide for you.  No wonder the program is so
slow, that's just crazy.

> It seems it can never fill up the output buffer now, so the throughput
> have suffered.
> What would you suggest to improve it?

Don't call select for every character :)

thanks,

greg k-h
