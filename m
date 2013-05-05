Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3EES3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:29:20 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:32995 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3EES3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 14:29:18 -0400
Date: Sun, 5 May 2013 20:29:13 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <jhovold@gmail.com>, Stas Sergeev <stsp@list.ru>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
Message-ID: <20130505182913.GE16818@localhost>
References: <20130503163008.GA30699@kroah.com>
 <5183F62A.1020801@list.ru>
 <20130503165231.GA1966@kroah.com>
 <5183FC83.8090602@list.ru>
 <20130503171618.GA16686@kroah.com>
 <51840186.7000608@list.ru>
 <20130503203419.GA25932@kroah.com>
 <51843132.9040304@list.ru>
 <20130504111535.GC16818@localhost>
 <5184F38D.9090507@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5184F38D.9090507@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 07:39:57AM -0400, Peter Hurley wrote:
> On 05/04/2013 07:15 AM, Johan Hovold wrote:
> > On Sat, May 04, 2013 at 01:50:42AM +0400, Stas Sergeev wrote:
> >> 04.05.2013 00:34, Greg KH пишет:
> >>> On Fri, May 03, 2013 at 10:27:18PM +0400, Stas Sergeev wrote:
> >>>> 03.05.2013 21:16, Greg KH пишет:

[...]

> > But you do have a point, and I have been meaning to look into whether
> > the added overhead of checking the hardware buffers could be mitigated
> > by adding wait_until_sent support to usb-serial. This way the we would
> > only query the hardware buffers on tty_wait_until_sent (e.g. at close)
> > and select and TIOCMOUTQ would not suffer. This is also the way things
> > are handled in serial_core.
> 
> Agreed. This is the correct solution.
> 
> > I'll prepare a series which adds wait_until_sent to usb-serial, but I
> > doubt it would be stable material (even if it could get into 3.10).
> >
> > What do you think Greg, is this overhead to chars_in_buffer reason
> > enough to disable it in the stable trees or should we simply fix it in
> > 3.11 (or 3.10)? (The overhead is about 3-400 us per call when the port
> > fifo is empty, which makes chars_in_buffer about 100 times slower on my
> > test system.)
> 
> A better solution for stable would be to set port->drain_delay. It
> won't help tcdrain() but at least the port won't shutdown on live
> outbound data.

Removing the hardware-buffer checks from chars_in_buffer would mean
breaking tty_wait_until_sent and thus also, for example, tcdrain,
tcsendbreak, and close. Using drain_delay would partially work-around
the problem with close, but at the cost of adding delays for all users
while still not being able to guarantee that the buffers have been
drained. Either way, this seems to amount to a regression.

On the other hand, the added overhead to chars_in_buffer seems to break
at least one application as well.

I've implemented wait_until_sent-support for usb-serial, which fixes the
problem without any such trade-offs and which I believe needs to go in
to v3.10.

For the stable trees I think keeping the current, less efficient (but
more complete) chars_in_buffer implementations is preferred over
introducing further regressions. Back-porting wait_until_sent-support
could perhaps also be considered.

I'm responding to this mail with a wait_until_sent-support series.

Thanks,
Johan
