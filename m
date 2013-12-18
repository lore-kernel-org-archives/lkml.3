Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3LRL2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:28:06 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46943 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab3LRL2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:28:04 -0500
X-Sasl-enc: xP5Ei+Mm3buVFh7ItCPemYELB5EhqANyQLQ9NVNmBvF6 1387366082
Date: Wed, 18 Dec 2013 09:27:59 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] video: backlight: Remove backlight
 sysfs uevent
Message-ID: <20131218112759.GA29631@khazad-dum.debian.net>
References: <20131112005628.GA2914@khazad-dum.debian.net>
 <1384990859.20536.4.camel@x230>
 <20131121114332.GA23710@khazad-dum.debian.net>
 <20131121143326.GA19773@srcf.ucam.org>
 <20131122113601.GB27196@khazad-dum.debian.net>
 <20131122171556.GA15680@srcf.ucam.org>
 <20131124004015.GA19499@khazad-dum.debian.net>
 <20131124010257.GA6376@srcf.ucam.org>
 <20131124035311.GC19499@khazad-dum.debian.net>
 <20131215235336.49d49a25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215235336.49d49a25.akpm@linux-foundation.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Dec 2013, Andrew Morton wrote:
> On Sun, 24 Nov 2013 01:53:11 -0200 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > On Sun, 24 Nov 2013, Matthew Garrett wrote:
> > > On Sat, Nov 23, 2013 at 10:40:15PM -0200, Henrique de Moraes Holschuh wrote:
> > > > On Fri, 22 Nov 2013, Matthew Garrett wrote:
> > > > > We have userspace that relies on uevents of type 
> > > > > BACKLIGHT_UPDATE_HOTKEY. I don't know that we have userspace that relies 
> > > > > on uevents of type BACKLIGHT_UPDATE_SYSFS.
> > > > 
> > > > Any OSD application would have to rely on both uevent types, or it is broken
> > > > (and to test that, just write a level to sysfs and watch the OSD app fail to
> > > > tell you about the backlight level change...)
> > > 
> > > Right, OSDs are supposed to respond to keypresses, not arbitrary changes 
> > > of backlight. If the user's just echoed 8 into brightness, they know 
> > > they set the brightness to 8 - they don't need an OSD to tell them that. 
> > 
> > It is not just the user that sets the brightness.
> > 
> > Still, if you're sure that all userspace users react only to the hotkey type
> > of event, removing the sysfs one won't break anything any further.
> > 
> > But it will be *really* annoying the day we revisit this because someone
> > started abusing the hotkey uevent and we have to deploy a proper fix (rate
> > limiting or switching to a proper event report interface that doesn't use
> > uevents).
> > 
> > > BACKLIGHT_UPDATE_HOTKEY is when the firmware itself has changed the 
> > > brightness in response to a keypress, and so reporting the keypress 
> > > would result in additional backlight changes.
> > 
> > Yeah, I know that bug quite well, thinkpads were the first victims of
> > idiotic feedback event loops caused by braindead userspace.
> 
> I'm not seeing a lot of consensus here and afaict the v2 patch:
> 
> --- a/drivers/video/backlight/backlight.c~drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent
> +++ a/drivers/video/backlight/backlight.c
> @@ -175,8 +175,6 @@ static ssize_t brightness_store(struct d
>  	}
>  	mutex_unlock(&bd->ops_lock);
>  
> -	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
> -
>  	return rc;
>  }
>  static DEVICE_ATTR_RW(brightness);
> 
> will still break userspace which relies on BACKLIGHT_UPDATE_SYSFS
> uevents.  I see no way we can guarantee that there is no such userspace
> so the patch is worrying.
> 
> Should we instead be looking for a way of avoiding this risk?  Say, add
> a new knob which people can set if they don't want to generate this
> event?  Ugly, but that's the price we pay for mucking it up originally.

Well, either that, or a smart rate limiter with a sane default.  It could
well be configurable to suppress all events, for the benefit of embedded
devices.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
