Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab3EDLPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 07:15:42 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:57765 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3EDLPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 07:15:40 -0400
Date: Sat, 4 May 2013 13:15:35 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Stas Sergeev <stsp@list.ru>, Greg KH <gregkh@linuxfoundation.org>
Cc: Jarkko Huijts <jarkko.huijts@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
Message-ID: <20130504111535.GC16818@localhost>
References: <5183D196.2080305@list.ru>
 <20130503163008.GA30699@kroah.com>
 <5183F62A.1020801@list.ru>
 <20130503165231.GA1966@kroah.com>
 <5183FC83.8090602@list.ru>
 <20130503171618.GA16686@kroah.com>
 <51840186.7000608@list.ru>
 <20130503203419.GA25932@kroah.com>
 <51843132.9040304@list.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51843132.9040304@list.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 01:50:42AM +0400, Stas Sergeev wrote:
> 04.05.2013 00:34, Greg KH пишет:
> > On Fri, May 03, 2013 at 10:27:18PM +0400, Stas Sergeev wrote:
> >> 03.05.2013 21:16, Greg KH пишет:

[...]

> >>> There's no guarantee as to how long select or an ioctl will take, and
> >>> now that we have fixed another bug, this device is slower.
> >>>
> >>> If you change hardware types to use a different usb to serial chip, that
> >>> select call might take 4 times as long.  Are we somehow supposed to
> >>> change the kernel to "fix" that?
> >> Previously, the kernel was not calling to a device at all, so
> >> select() was independent of the chip, and it was fast. I was
> >> not aware you changed that willingly.
> > I don't understand, what do you mean by this?  Some drivers just return
> > the value of an internally held number, and don't query the device.
> >
> > The only way the FTDI driver can determine if the hardware buffer on the
> > chip way out on the end of the USB cable is empty or not, is to query
> > it.  So the driver now does so.
> It does so only for one char. And the query takes longer than
> to just xmit that char. So why do you think this even works as
> expected?

The query takes longer than the transmit at decent baudrates (>=38k)
and under the assumption that flow control isn't causing any delays.

But you do have a point, and I have been meaning to look into whether
the added overhead of checking the hardware buffers could be mitigated
by adding wait_until_sent support to usb-serial. This way the we would
only query the hardware buffers on tty_wait_until_sent (e.g. at close)
and select and TIOCMOUTQ would not suffer. This is also the way things
are handled in serial_core.

I'll prepare a series which adds wait_until_sent to usb-serial, but I
doubt it would be stable material (even if it could get into 3.10).

What do you think Greg, is this overhead to chars_in_buffer reason
enough to disable it in the stable trees or should we simply fix it in
3.11 (or 3.10)? (The overhead is about 3-400 us per call when the port
fifo is empty, which makes chars_in_buffer about 100 times slower on my
test system.)

Thanks,
Johan
