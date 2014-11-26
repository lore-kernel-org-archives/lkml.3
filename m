Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaKZOXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:23:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaKZOXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:23:22 -0500
Message-ID: <1417011800.5928.9.camel@linux-0dmf.site>
Subject: Re: bluetooth related firmware loader spew on resume.
From: Oliver Neukum <oneukum@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, pgynther@google.com,
        linux-bluetooth@vger.kernel.org
Date: Wed, 26 Nov 2014 15:23:20 +0100
In-Reply-To: <s5hioi2xmf9.wl-tiwai@suse.de>
References: <20141111181228.GA27815@redhat.com>
	 <s5hsih7xmgg.wl-tiwai@suse.de>
	 <D19A9DA1-3706-4351-B2E9-25D5ABA662E7@holtmann.org>
	 <s5h7fyijqc9.wl-tiwai@suse.de> <1416996623.3171.7.camel@linux-0dmf.site>
	 <s5hlhmyxng0.wl-tiwai@suse.de> <1416998616.3171.13.camel@linux-0dmf.site>
	 <s5hioi2xmf9.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 11:53 +0100, Takashi Iwai wrote:
> At Wed, 26 Nov 2014 11:43:36 +0100,
> Oliver Neukum wrote:
> > 
> > On Wed, 2014-11-26 at 11:31 +0100, Takashi Iwai wrote:
> > > At Wed, 26 Nov 2014 11:10:23 +0100,
> > > Oliver Neukum wrote:
> > > > 
> > > > On Wed, 2014-11-26 at 09:52 +0100, Takashi Iwai wrote:
> > > > > At Wed, 26 Nov 2014 14:15:27 +0900,
> > > > 
> > > > > In order to paper over this, we may also remember the failing firmware
> > > > > and avoid loading it.  This might be an easer way than the endless
> > > > > fight against UMH race...
> > > > 
> > > > Hi,
> > > > 
> > > > the full fix would be to implement reset_resume() for btusb.
> > > > It seems to me that setup() should be split in two methods,
> > > > one to request the firmware from user space and the second
> > > > to transfer it to the device. reset_resume() would just need
> > > > to repeat the second operation.
> > > 
> > > I'm not against it, but one slight drawback is that you'll have to
> > > remember the firmware content to transfer by the driver itself in this
> > > scenario.   In the firmware loader framework, the content is re-read
> > > at resume so that the largish content isn't kept unnecessarily during
> > > the whole operation. 
> > 
> > That isn't a drawback but an advantage. Firmware for devices that
> > do power management needs to be in RAM. The right time to free it
> > is in disconnect(). But why does that mean that the driver has to
> > manage the firmware? Can't the firmware layer do it?
> 
> The f/w loader remembers the f/w names of the successful loads, and
> retries to load them automatically at the suspend time.  But it
> doesn't remember/cache the failed loads.  So, when the driver retires

Two issues

1. the firmware may be added later. So we could only record the name,
not the result of the query.
2. a driver may query several firmwares in turn to find its firmware

It seems to me that a firmware that will be needed again should
just not be evicted from RAM.

> request_firmware() for a non-existing file in the resume path, it
> actually reaches to the f/w loading part again unexpectedly.

And that is probably a bug. We just cannot request a firmware during
resumption. On anything but a leave node it is potentially deadly.

	Regards
		Oliver


