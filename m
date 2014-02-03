Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaBCLZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:25:03 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35895 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaBCLZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:25:01 -0500
MIME-Version: 1.0
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 3 Feb 2014 12:25:00 +0100
Message-ID: <CANq1E4R=DWp2WBWWBbLHE2FG9HWWP=bM4wvE8etoEr1PAp0+JA@mail.gmail.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
From: David Herrmann <dh.herrmann@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Terje Bergstrom <tbergstrom@nvidia.com>,
        Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[..snip..]
> Finally, support for probing GK20A is added in the last 2 patches. It should be
> noted that contrary to what Nouveau currently expects, GK20A does not embed any
> display hardware (that part being handled by tegradrm). So this driver should
> really be only used through DRM render-nodes and collaborate with the display
> driver using PRIME. I have not yet figured out how to turn GK20A's instantiation
> of Nouveau into a render-node only driver without breaking support for existing
> desktop GPUs, and consequently the driver spawns a /dev/dri/cardX node which we
> should try to get rid of.

You cannot get rid of cardX currently. It is implied by DRIVER_MODESET
and that flag should actually be called NOT_A_LEGACY_DRIVER. So you
cannot remove it. I did try to replace DRIVER_MODESET by an inverted
DRIVER_LEGACY flag some time ago, but I thought it's not worth it.

Anyhow, you can easily add a new flag to make
drm_dev_register()/drm_dev_alloc() not create the drm_minor for
DRM_MINOR_LEGACY, which would prevent the card0 node from showing up.
But people started using the cardX interface as base interface so mesa
might not be able to open render-nodes if the related card-node is not
available (which is a bug in their code, so no reason to support that
by not adding stand-alone render-nodes).

Long story short: If you want to do it properly, just add a flag to
DRM core that prevents DRM_MINOR_LEGACY from showing up. If you just
want it to work, simply keep a dummy card0.

Thanks
David
