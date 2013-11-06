Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3KFUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:16:28 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58853 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3KFUQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:16:26 -0500
Date: Wed, 6 Nov 2013 15:16:20 -0500
From: Matt Porter <matt.porter@linaro.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] DT: proc: Add runtime overlay interface in /proc
Message-ID: <20131106201620.GN28156@beef>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
 <CAL_Jsq+k9NoHxOaNujTG2=0MHm=s4Mh+xhXCZbhPG1EnHvo50A@mail.gmail.com>
 <8EBC2D5B-74A4-4A85-8BEE-9EAEBFF045D4@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8EBC2D5B-74A4-4A85-8BEE-9EAEBFF045D4@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:24:12PM +0200, Pantelis Antoniou wrote:
> Hi Rob,
> 
> On Nov 6, 2013, at 9:10 PM, Rob Herring wrote:
> 
> > On Tue, Nov 5, 2013 at 12:41 PM, Pantelis Antoniou
> > <panto@antoniou-consulting.com> wrote:
> >> Add a runtime interface to /proc to enable generic device tree overlay
> >> usage.
> >> 
> >> Two new /proc files are added:
> >> 
> >> /proc/device-tree-overlay & /proc/device-tree-overlay-status
> > 
> > I think we really want all this to live under sysfs. Grant did patches
> > to move /proc/device-tree to /sys, but it never went upstream:
> > 
> > v2: https://lkml.org/lkml/2013/3/21/215
> > v1: https://lkml.org/lkml/2013/3/20/311
> > 
> 
> Yes, I'm aware; the location of this control interface in /proc is
> unusual, but had to go somewhere. It should be easy enough to move it to
> /sys.
> 
> >> /proc/device-tree-overlay accepts a stream of a device tree objects and
> >> applies it to the running kernel's device tree.
> >> 
> >>        $ cat ~/BB-UART2-00A0.dtbo >device-tree-overlay
> >>        overlay_proc_release: Applied #2 overlay segments @0
> >> 
> >> /proc/device-tree-overlay-status displays the the overlays added using
> >> the /proc interface
> >> 
> >>        $ cat device-tree-overlay-status
> >>        0: 861 bytes BB-UART2:00A0
> > 
> > Is the size useful information?
> > 
> 
> If the overlay doesn't contain part-number/version properties there is nothing
> to differentiate each one loaded. No file information, it is just a byte stream
> interface.
> 
> >> 
> >> The format of the status line is
> >>        <ID>: <SIZE> bytes <part-number>:<version>
> >> 
> >> <ID> is the id of the overlay
> >> <SIZE> is the size of the overlay in bytes
> >> <part-number>, <version> are (optional) root level properties of the DTBO
> >> 
> >> You can remove an overlay by echoing the <ID> number of the overlay
> >> precedded with a '-'
> >> 
> >> So
> >>        $ echo "-0" >device-tree-overlay-status
> >> 
> >> Removes the overlay.
> > 
> > This interface seems racy. Could the id change on you between reading
> > the status and echoing to remove the overlay?
> > 
> > I would rather see a file created for each overlay and simply echo 0
> > or "remove" to remove the overlay. Or possibly it needs to be a
> > directory per overlay with several files for info and control. This
> > would be more inline with typical sysfs design.
> > 
> 
> It was suggested to use a configfs interface. IIRC configfs can do what you
> propose.
> 
> Something like 
> 
> /config/dto/add 	<- load by cat overlay.dtbo >/config/dto/load

In a configfs it makes more sense to mkdir. FWIW, USB gadget configfs
is a good example of this.

	mkdir /config/dto/0

which would cause the kernel to create the attribute under that
directory:

	/config/dto/0/load

Which you use to load as noted above.

Only problem is that configfs doesn't support binary attributes like
sysfs. If it is a agreed that overlays are configuration then that would
be a strong argument to bring over the binary attribute feature.


> /config/dto/0/remove 	<- unload by echo 1 >/config/dto/0/remove

	rmdir /config/dto/0

> /config/dto/0/${prop}   <- root level properties that are ignore by the overlay
> 			   mechanism

-Matt
