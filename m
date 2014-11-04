Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaKDSCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:02:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKDSCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:02:12 -0500
Date: Tue, 4 Nov 2014 10:02:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 05/10] added media specific (MS) TCP drivers
Message-ID: <20141104180210.GA3940@kroah.com>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-6-git-send-email-stephanie.s.wallick@intel.com>
 <20141104084833.GF26719@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104084833.GF26719@distanz.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:48:33AM +0100, Tobias Klauser wrote:
> On 2014-11-03 at 21:42:52 +0100, Stephanie Wallick <stephanie.s.wallick@intel.com> wrote:
> > This is where we handle media specific packets and transport. The MS driver
> > interfaces with a media agnostic (MA) driver via a series of transfer pairs.
> > Transfer pairs consist of a set of functions to pass MA USB packets back
> > and forth between MA and MS drivers. There is one transfer pair per device
> > endpoint and one transfer pair for control/management traffic. When the MA
> > driver needs to send an MA USB packet, it hands the packet off to the MS
> > layer where the packet is converted into an MS form and sent via TCP over
> > the underlying ethernet or wireless medium. When the MS driver receives a
> > packet, it converts it into an MA USB packet and hands it off the the MA
> > driver for handling.
> > 
> > In addition, the MS driver provides an interface to inititate connection events.
> > Because there are no physical MA USB ports in an MA USB host, the host must be
> > notified via software when a device is connected.
> > 
> > Lastly, the MS driver contains a number of ioctl functions that are used by a
> > utility to adjust medium-related driver parameters and connect or disconnect the
> > MA USB host and device drivers.
> > 
> > Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
> > Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
> > ---
> >  drivers/staging/mausb/drivers/mausb_ioctl.c      | 373 +++++++++++++++++++
> >  drivers/staging/mausb/drivers/mausb_ioctl.h      |  99 +++++
> >  drivers/staging/mausb/drivers/mausb_msapi.c      | 110 ++++++
> >  drivers/staging/mausb/drivers/mausb_msapi.h      | 232 ++++++++++++
> >  drivers/staging/mausb/drivers/mausb_tcp-device.c | 147 ++++++++
> >  drivers/staging/mausb/drivers/mausb_tcp-host.c   | 144 ++++++++
> >  drivers/staging/mausb/drivers/mausb_tcp.c        | 446 +++++++++++++++++++++++
> >  drivers/staging/mausb/drivers/mausb_tcp.h        | 129 +++++++
> >  8 files changed, 1680 insertions(+)
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.c
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.h
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.c
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.h
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-device.c
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-host.c
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.c
> >  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.h
> > 
> > diff --git a/drivers/staging/mausb/drivers/mausb_ioctl.c b/drivers/staging/mausb/drivers/mausb_ioctl.c
> > new file mode 100644
> > index 0000000..0c6c6bd
> > --- /dev/null
> > +++ b/drivers/staging/mausb/drivers/mausb_ioctl.c
> 
> [...]
> 
> > +/**
> > + * This function is used to send a message to the user, in other words, the
> > + * calling process. It basically copies the message one byte at a time.
> > + *
> > + * @msg:	The message to be sent to the user.
> > + * @buffer:	The buffer in which to put the message. This buffer was given to
> > + *	    	us to fill.
> > + */
> > +void to_user(char *msg, long unsigned int buffer)
> > +{
> > +	int length = (int)strlen(msg);
> > +	int bytes = 0;
> > +
> > +	while (length && *msg) {
> > +		put_user(*(msg++), (char *)buffer++);
> > +		length--;
> > +		bytes++;
> > +	}
> 
> Any reason not to use copy_to_user here? That way, access_ok would only
> need to be executed once for the whole range.
> 
> In any case, the return value of put_user/copy_to_user will need to be
> checked.

Never use put_user if you can help it, this whole function should go
away, and copy_to_user() should be used at the caller sites instead as
you point out.

thanks,

greg k-h
