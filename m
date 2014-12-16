Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaLPLmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:42:52 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:42808 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaLPLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:42:50 -0500
Date: Tue, 16 Dec 2014 12:42:48 +0100
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeremiah Mahler <jmmahler@gmail.com>, Johan Hovold <johan@kernel.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] usb: serial: handle -ENODEV and -EPROTO quietly
Message-ID: <20141216114248.GH6778@localhost>
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
 <20141215102321.GD6778@localhost>
 <20141215125305.GA18251@hudson.localdomain>
 <20141215163801.GB1470@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215163801.GB1470@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 08:38:01AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Dec 15, 2014 at 04:53:05AM -0800, Jeremiah Mahler wrote:
> > Johan,
> > 
> > On Mon, Dec 15, 2014 at 11:23:21AM +0100, Johan Hovold wrote:
> > > On Thu, Dec 11, 2014 at 03:29:52PM -0800, Jeremiah Mahler wrote:
> > > > If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
> > > > unplugged, a bunch of -ENODEV and -EPROTO errors will be produced in the
> > > > logs.  This patch set quiets these messages without changing the
> > > > original behavior.
> > > 
> > > Don't unplug devices that are in use then. ;)
> > > 
> > I knew someone was going to say that :-)
> > 
> > > > This change is beneficial when using daemons such as slcand, which is
> > > > similar to pppd or slip, that cannot determine whether they should exit
> > > > until after the USB serial device is unplugged.  Producing these error
> > > > messages for a normal use case is not helpful.
> > > 
> > > Your patches would hide these errors when they occur during normal use
> > > (e.g. EPROTO).
> > > 
> > > Receiving an error message when unplugging an active device should not
> > > surprise anyone. And at least you know where it came from (and it's
> > > right there in the logs as well).
> > > 
> > > Johan
> > 
> > Hmm.  Yes, I can see why quieting -EPROTO would be bad because it would
> > hide protocol errors which we want to know about.
> 
> Do you really want to "know about" them?  What can a user do with them?
> Nothing, so just resubmit and you should be fine.

Knowing that a device is flakey (and should be replaced) might be of
some worth?

And wouldn't silencing such errors mean that we could be quietly
dropping data?

> > I need to re-think this patch.
> > Nack.
> 
> I like this patch, putting crud in the kernel log that no one can do
> anything with for a "normal" operation like yanking a USB device out
> while it is open should not happen.

The problem is that several errors may be returned from the
host-controller driver as a consequence of disconnect (before the hub
driver can process the disconnect). At least -EPROTO, -EILSEQ, -ETIME
are -EPIPE explicitly listed in Documentation/usb/error-codes.txt for
this, and of those, -EPROTO, -EILSEQ could also indicate hardware
problems.

I don't see how we can get around the trade-off between having a few
error messages in the log in the short window prior to a processed (and
also logged) disconnect, and not reporting potential hardware issues.

Thanks,
Johan
