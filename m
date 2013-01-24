Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3AXGKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:10:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11495 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3AXGKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:10:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 23 Jan 2013 22:10:10 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Purdie <rpurdie@rpsys.net>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>, "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
Date: Thu, 24 Jan 2013 15:10:08 +0900
Message-ID: <3533873.vHaQr9T5V0@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.5 (Linux/3.6.11-1-ARCH; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2178053.V0UsGT5PW9@percival>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <20130122070630.GA14728@avionic-0098.adnet.avionic-design.de> <2178053.V0UsGT5PW9@percival>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 17:45:39 Alex Courbot wrote:
> > I'm confused. Why would you want to call into pwm_bl directly? If we're
> > going to split this up into separate platform devices, why not look up a
> > given backlight device and use the backlight API on that? The pieces of
> > the puzzle are all there: you can use of_find_backlight_by_node() to
> > obtain a backlight device from a device tree node, so I'd expect the DT
> > to look something like this:
> > 	backlight: backlight {
> > 	
> > 		compatible = "pwm-backlight";
> > 		...
> > 	
> > 	};
> 
> This would still prevent any power control from the backlight driver. I.e.
> if someone sets the brightness to 0 through sysfs, we cannot power the
> backlight off as pwm-backlight cannot control more than the PWM without
> platform callbacks. Backlight could only be powered off as a result of a fb
> blank event.

In order to solve this, how about adding a backlight notifier call chain to 
broadcast backlight events in a fashion similar to what is done in 
fbmem/fbcon? Then backlight_update_status() could send events like 
BACKLIGHT_EARLY_EVENT_UPDATE and BACKLIGHT_EVENT_UPDATE to which panel drivers 
could subscribe in order to power the backlight up and down as needed.

Then as the backlight is mentioned in the panel's DT node,

>       panel: panel {
>               compatible = "...";
>               ...
>               backlight = <&backlight>;
>               ...
>       };

the panel's driver could listen to backlight-related events and do its stuff 
transparently, without changing anything to the backlight drivers. This would 
be a good way to replace pwm-backlight's callbacks for platforms that use the 
DT, and would also be applicable to any backlight class device.

Generally speaking, having a mean to monitor backlights state in the kernel 
does not seem too crazy, especially since we already have a way to notify user 
space through backlight_generate_event().

Richard, does that sound ok to you?

Alex.

