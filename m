Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3LPHwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 02:52:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3LPHwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 02:52:02 -0500
Date: Sun, 15 Dec 2013 23:53:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-fbdev@vger.kernel.org,
        "'Kyungmin Park'" <kmpark@infradead.org>, kay@vrfy.org,
        Jingoo Han <jg1.han@samsung.com>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [ibm-acpi-devel] [PATCH] video: backlight: Remove backlight
 sysfs uevent
Message-Id: <20131215235336.49d49a25.akpm@linux-foundation.org>
In-Reply-To: <20131124035311.GC19499@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
	<002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
	<20131112005628.GA2914@khazad-dum.debian.net>
	<1384990859.20536.4.camel@x230>
	<20131121114332.GA23710@khazad-dum.debian.net>
	<20131121143326.GA19773@srcf.ucam.org>
	<20131122113601.GB27196@khazad-dum.debian.net>
	<20131122171556.GA15680@srcf.ucam.org>
	<20131124004015.GA19499@khazad-dum.debian.net>
	<20131124010257.GA6376@srcf.ucam.org>
	<20131124035311.GC19499@khazad-dum.debian.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Nov 2013 01:53:11 -0200 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Sun, 24 Nov 2013, Matthew Garrett wrote:
> > On Sat, Nov 23, 2013 at 10:40:15PM -0200, Henrique de Moraes Holschuh wrote:
> > > On Fri, 22 Nov 2013, Matthew Garrett wrote:
> > > > We have userspace that relies on uevents of type 
> > > > BACKLIGHT_UPDATE_HOTKEY. I don't know that we have userspace that relies 
> > > > on uevents of type BACKLIGHT_UPDATE_SYSFS.
> > > 
> > > Any OSD application would have to rely on both uevent types, or it is broken
> > > (and to test that, just write a level to sysfs and watch the OSD app fail to
> > > tell you about the backlight level change...)
> > 
> > Right, OSDs are supposed to respond to keypresses, not arbitrary changes 
> > of backlight. If the user's just echoed 8 into brightness, they know 
> > they set the brightness to 8 - they don't need an OSD to tell them that. 
> 
> It is not just the user that sets the brightness.
> 
> Still, if you're sure that all userspace users react only to the hotkey type
> of event, removing the sysfs one won't break anything any further.
> 
> But it will be *really* annoying the day we revisit this because someone
> started abusing the hotkey uevent and we have to deploy a proper fix (rate
> limiting or switching to a proper event report interface that doesn't use
> uevents).
> 
> > BACKLIGHT_UPDATE_HOTKEY is when the firmware itself has changed the 
> > brightness in response to a keypress, and so reporting the keypress 
> > would result in additional backlight changes.
> 
> Yeah, I know that bug quite well, thinkpads were the first victims of
> idiotic feedback event loops caused by braindead userspace.

I'm not seeing a lot of consensus here and afaict the v2 patch:

--- a/drivers/video/backlight/backlight.c~drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent
+++ a/drivers/video/backlight/backlight.c
@@ -175,8 +175,6 @@ static ssize_t brightness_store(struct d
 	}
 	mutex_unlock(&bd->ops_lock);
 
-	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
-
 	return rc;
 }
 static DEVICE_ATTR_RW(brightness);

will still break userspace which relies on BACKLIGHT_UPDATE_SYSFS
uevents.  I see no way we can guarantee that there is no such userspace
so the patch is worrying.

Should we instead be looking for a way of avoiding this risk?  Say, add
a new knob which people can set if they don't want to generate this
event?  Ugly, but that's the price we pay for mucking it up originally.
