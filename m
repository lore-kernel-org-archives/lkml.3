Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3AWJpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:45:47 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9537 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3AWJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:45:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 23 Jan 2013 01:45:28 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>, "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
Date: Wed, 23 Jan 2013 18:45:39 +0900
Message-ID: <2178053.V0UsGT5PW9@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.5 (Linux/3.6.11-1-ARCH; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130122070630.GA14728@avionic-0098.adnet.avionic-design.de>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <12033649.LY58cllSHv@percival> <20130122070630.GA14728@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm confused. Why would you want to call into pwm_bl directly? If we're
> going to split this up into separate platform devices, why not look up a
> given backlight device and use the backlight API on that? The pieces of
> the puzzle are all there: you can use of_find_backlight_by_node() to
> obtain a backlight device from a device tree node, so I'd expect the DT
> to look something like this:
> 
> 	backlight: backlight {
> 		compatible = "pwm-backlight";
> 		...
> 	};

This would still prevent any power control from the backlight driver. I.e. if 
someone sets the brightness to 0 through sysfs, we cannot power the backlight 
off as pwm-backlight cannot control more than the PWM without platform 
callbacks. Backlight could only be powered off as a result of a fb blank event.

> 	panel: panel {
> 		compatible = "...";
> 		...
> 		backlight = <&backlight>;
> 		...
> 	};

So all the power control of both the panel and backlight would be performed 
from this device's driver. How would it plug into tegra-drm? I would see 
tegra_panel as a new member of the tegra_output structure, with one callback 
invoked from tegra_encoder_dpms(). Does that look sane?

> After that you can wire it up with host1x using something like:
> 
> 	host1x {
> 		dc@54200000 {
> 			rgb {
> 				status = "okay";
> 
> 				nvidia,panel = <&panel>;
> 			};
> 		};
> 	};

Indeed. So if we do that, the DRM DPMS functions would take care of the 
panel/backlight powering and the backlight driver will control the PWM after 
this, through the FB notifier. This is a little bit different from the "official" 
power sequence, but I just tested controlling the PWM at the very end of the 
sequence and it works just as well. If you think this looks better I don't 
mind doing it that way, it is actually a good excuse for me to dive into the 
DRM code.

Anyway, this will only be a temporary solution, CDF is the only way to do this 
right.

Alex.

