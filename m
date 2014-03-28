Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaC1Syw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:54:52 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:53280 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaC1Syg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:54:36 -0400
MIME-Version: 1.0
In-Reply-To: <1395179766-31575-3-git-send-email-pantelis.antoniou@konsulko.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1395179766-31575-3-git-send-email-pantelis.antoniou@konsulko.com>
Date: Fri, 28 Mar 2014 13:54:35 -0500
Message-ID: <CANk1AXSUr03wqSFqB_cmPHS88GkmMB-ierAxmrc+v5hKFVT01g@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] OF: Introduce DT overlay support.
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 4:56 PM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Introduce DT overlay support.
> Using this functionality it is possible to dynamically overlay a part of
> the kernel's tree with another tree that's been dynamically loaded.
> It is also possible to remove node and properties.
>
> The creation/destruction of the devices is handled by calling in to
> bus specific handlers which can deal with the peculiarities of each
> device.
>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  Documentation/devicetree/overlay-notes.txt | 187 ++++++
>  drivers/of/Kconfig                         |  10 +
>  drivers/of/Makefile                        |   1 +
>  drivers/of/overlay.c                       | 895 +++++++++++++++++++++++++++++
>  include/linux/of.h                         | 153 +++++
>  5 files changed, 1246 insertions(+)
>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>  create mode 100644 drivers/of/overlay.c
>
> diff --git a/Documentation/devicetree/overlay-notes.txt b/Documentation/devicetree/overlay-notes.txt
> new file mode 100644
> index 0000000..882d512
> --- /dev/null
> +++ b/Documentation/devicetree/overlay-notes.txt
> @@ -0,0 +1,187 @@
> +Device Tree Overlay Notes
> +-------------------------
> +
> +This document describes the implementation of the in-kernel
> +device tree overlay functionality residing in drivers/of/overlay.c and is a
> +companion document to Documentation/devicetree/dt-object-internal.txt[1] &
> +Documentation/devicetree/dynamic-resolution-notes.txt[2]
> +
> +How overlays work
> +-----------------
> +
> +A Device Tree's overlay purpose is to modify the kernel's live tree, and
> +have the modification affecting the state of the the kernel in a way that
> +is reflecting the changes.
> +Since the kernel mainly deals with devices, any new device node that result
> +in an active device should have it created while if the device node is either
> +disabled or removed all together, the affected device should be deregistered.

Suggestion for readability:

Since the kernel mainly deals with devices, any new device node that results
in an active device should have that device created. If the device node is
either disabled or removed altogether, the affected device should be
deregistered.

> +/**
> + * of_overlay  - Apply @count overlays pointed at by @ovinfo_tab
> + * @count:     Number of of_overlay_info's
> + * @ovinfo_tab:        Array of overlay_info's to apply
> + *
> + * Applies the overlays given, while handling all error conditions
> + * appropriately. Either the operation succeeds, or if it fails the
> + * live tree is reverted to the state before the attempt.
> + * Returns 0, or an error if the overlay attempt failed.
> + */
> +int of_overlay(int count, struct of_overlay_info *ovinfo_tab);

Suggest renaming this function of_overlay_apply() for grep-ability

Alan Tull
aka
delicious quinoa

> +
> +/**
> + * of_overlay_revert   - Revert a previously applied overlay
> + * @count:     Number of of_overlay_info's
> + * @ovinfo_tab:        Array of overlay_info's to apply
> + *
> + * Revert a previous overlay. The state of the live tree
> + * is reverted to the one before the overlay.
> + * Returns 0, or an error if the overlay table is not given.
> + */
> +int of_overlay_revert(int count, struct of_overlay_info *ovinfo_tab);
