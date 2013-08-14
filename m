Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3HNOPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:15:05 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:52271 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3HNOPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:15:03 -0400
Message-ID: <520B90E1.5000803@gmail.com>
Date: Wed, 14 Aug 2013 16:14:57 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drm/i2c: tda998x: fix sync generation and calculation
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130814124118.GD23840@n2100.arm.linux.org.uk>
In-Reply-To: <20130814124118.GD23840@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/13 14:41, Russell King - ARM Linux wrote:
> On Tue, Aug 06, 2013 at 12:20:16AM +0200, Sebastian Hesselbarth wrote:
>> +	de_pix_s     = mode->htotal - mode->hdisplay;
>> +	de_pix_e     = de_pix_s + mode->hdisplay;
>> +	hs_pix_s     = mode->hsync_start - mode->hdisplay;
>> +	hs_pix_e     = hs_pix_s + mode->hsync_end - mode->hsync_start;
>
> I still think the above is over-complicating the calculation and making it
> less readable.

Yeah, you also didn't like it the last time. I must admit, I have
left it that way because I did all the near-end/far-end scope checks
on the calculation above and I wasn't that eager to touch them again.

But I agree and will revert the lines in question and update the
others accordingly.

> The values in 'mode' represent this timing representation:
> 0=hds                                    hde    hss  hse   ht
> |-----------------------------------------|----->|--->|---->|
>
> What we want to do is to rotate that around to this:
> 0     hss  hse   hds                                       ht=hde
> |----->|--->|---->|-----------------------------------------|
>
>  From that, you can see quite clearly that the end of the displayed line
> is now at htotal, and the start of the displayed line (hds) is hdisplay
> clocks before that.  So:
>
> 	de_pix_e = mode->htotal;
> 	de_pix_s = de_pix_e - mode->hdisplay;
>
> Everything else (hss, hse) has moved to the left by hdisplay clocks, so:
>
> 	hs_pix_s = mode->hsync_start - mode->hdisplay;
> 	hs_pix_e = mode->hsync_end - mode->hdisplay;
>
> That's what you get if you simplify your calculations as well.  If we then
> go back and look at the original code:
>
> -       hs_start   = mode->hsync_start - mode->hdisplay;
> -       hs_end     = mode->hsync_end - mode->hdisplay;
> -       de_start   = mode->htotal - mode->hdisplay;
> -       de_end     = mode->htotal;
>
> it's what was originally there, so I don't see any point in touching that
> calculation.
>
> We also have:
>
> -       ref_pix = 3 + hs_start;
> +       ref_pix      = 3 + mode->hsync_start - mode->hdisplay;
>
> which we can see is also the same calculation in essence.  I don't think
> the change helps readability.
>

