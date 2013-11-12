Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3KLA4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:56:40 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54719 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996Ab3KLA4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:56:32 -0500
X-Sasl-enc: zozWQna8CSR4t4YAuy13pwpApPAyTBtCAy21ZTltEa7s 1384217790
Date: Mon, 11 Nov 2013 22:56:28 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay@vrfy.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
Message-ID: <20131112005628.GA2914@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Jingoo Han wrote:
> On Tuesday, November 12, 2013 8:57 AM, Kyungmin Park wrote:
> > From: Kyungmin Park <kyungmin.park@samsung.com>
> > 
> > The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
> > It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
> > 
> > Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes
> > about 5ms. The main problem is that it hurts other process activities. so remove it.
> > 
> > Kay said
> > "Uevents are for the major, low-frequent, global device state-changes,
> >  not for carrying-out any sort of measurement data. Subsystems which
> >  need that should use other facilities like poll()-able sysfs file or
> >  any other subscription-based, client-tracking interface which does not
> >  cause overhead if it isn't used. Uevents are not the right thing to
> >  use here, and upstream udev should not paper-over broken kernel
> >  subsystems."

True.

Now, let's take a look at reality: should you poll()/select() on a sysfs
node that doesn't suport it, it will wait until the poll/select timeout
happens (or EINTR happens), and userspace has absolutely NO way to detect
whether a sysfs node has poll/select support.

What happens if the sysfs interface did not provide poll/select support
since day one, but rather added it later?  Nobody will use it for a *long*
time, if ever... unless you actually took pains to version the sysfs
interface, and people actually care.

> 'thinkpad_acpi.c' uses the 'BACKLIGHT_UPDATE_SYSFS'.
> Henrique, can we remove it?

Can't you fix this by rate-limiting, or otherwise adding an attribute that
backlight devices should set when they need to supress change events?

Is there a proper on-screen-display support path for the backlight class
nowadays?  Otherwise, you'd be removing the only way userspace ever had to
do proper OSD of backlight changes...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
