Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3KFTK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:10:29 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57940 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3KFTK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:10:28 -0500
MIME-Version: 1.0
In-Reply-To: <1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
	<1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
Date: Wed, 6 Nov 2013 13:10:27 -0600
Message-ID: <CAL_Jsq+k9NoHxOaNujTG2=0MHm=s4Mh+xhXCZbhPG1EnHvo50A@mail.gmail.com>
Subject: Re: [PATCH 3/3] DT: proc: Add runtime overlay interface in /proc
From: Rob Herring <robherring2@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 12:41 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> Add a runtime interface to /proc to enable generic device tree overlay
> usage.
>
> Two new /proc files are added:
>
> /proc/device-tree-overlay & /proc/device-tree-overlay-status

I think we really want all this to live under sysfs. Grant did patches
to move /proc/device-tree to /sys, but it never went upstream:

v2: https://lkml.org/lkml/2013/3/21/215
v1: https://lkml.org/lkml/2013/3/20/311

> /proc/device-tree-overlay accepts a stream of a device tree objects and
> applies it to the running kernel's device tree.
>
>         $ cat ~/BB-UART2-00A0.dtbo >device-tree-overlay
>         overlay_proc_release: Applied #2 overlay segments @0
>
> /proc/device-tree-overlay-status displays the the overlays added using
> the /proc interface
>
>         $ cat device-tree-overlay-status
>         0: 861 bytes BB-UART2:00A0

Is the size useful information?

>
> The format of the status line is
>         <ID>: <SIZE> bytes <part-number>:<version>
>
> <ID> is the id of the overlay
> <SIZE> is the size of the overlay in bytes
> <part-number>, <version> are (optional) root level properties of the DTBO
>
> You can remove an overlay by echoing the <ID> number of the overlay
> precedded with a '-'
>
> So
>         $ echo "-0" >device-tree-overlay-status
>
> Removes the overlay.

This interface seems racy. Could the id change on you between reading
the status and echoing to remove the overlay?

I would rather see a file created for each overlay and simply echo 0
or "remove" to remove the overlay. Or possibly it needs to be a
directory per overlay with several files for info and control. This
would be more inline with typical sysfs design.

Rob
