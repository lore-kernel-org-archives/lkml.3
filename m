Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3HNMld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:41:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41526 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3HNMlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:41:31 -0400
Date: Wed, 14 Aug 2013 13:41:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drm/i2c: tda998x: fix sync generation and
	calculation
Message-ID: <20130814124118.GD23840@n2100.arm.linux.org.uk>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-7-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375741218-10225-7-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:20:16AM +0200, Sebastian Hesselbarth wrote:
> +	de_pix_s     = mode->htotal - mode->hdisplay;
> +	de_pix_e     = de_pix_s + mode->hdisplay;
> +	hs_pix_s     = mode->hsync_start - mode->hdisplay;
> +	hs_pix_e     = hs_pix_s + mode->hsync_end - mode->hsync_start;

I still think the above is over-complicating the calculation and making it
less readable.

The values in 'mode' represent this timing representation:
0=hds                                    hde    hss  hse   ht
|-----------------------------------------|----->|--->|---->|

What we want to do is to rotate that around to this:
0     hss  hse   hds                                       ht=hde
|----->|--->|---->|-----------------------------------------|

>From that, you can see quite clearly that the end of the displayed line
is now at htotal, and the start of the displayed line (hds) is hdisplay
clocks before that.  So:

	de_pix_e = mode->htotal;
	de_pix_s = de_pix_e - mode->hdisplay;

Everything else (hss, hse) has moved to the left by hdisplay clocks, so:

	hs_pix_s = mode->hsync_start - mode->hdisplay;
	hs_pix_e = mode->hsync_end - mode->hdisplay;

That's what you get if you simplify your calculations as well.  If we then
go back and look at the original code:

-       hs_start   = mode->hsync_start - mode->hdisplay;
-       hs_end     = mode->hsync_end - mode->hdisplay;
-       de_start   = mode->htotal - mode->hdisplay;
-       de_end     = mode->htotal;

it's what was originally there, so I don't see any point in touching that
calculation.

We also have:

-       ref_pix = 3 + hs_start;
+       ref_pix      = 3 + mode->hsync_start - mode->hdisplay;

which we can see is also the same calculation in essence.  I don't think
the change helps readability.
