Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966025Ab3FTULT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:11:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43783 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965998Ab3FTULR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:11:17 -0400
Date: Thu, 20 Jun 2013 21:06:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] drm/i2c: tda998x: fix sync generation and
	calculation
Message-ID: <20130620200624.GQ2718@n2100.arm.linux.org.uk>
References: <1371757563-27862-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371757563-27862-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:46:03PM +0200, Sebastian Hesselbarth wrote:
> +	ref_pix      = 3 + mode->hsync_start - mode->hdisplay;
> +	de_pix_s     = mode->htotal - mode->hdisplay;
> +	de_pix_e     = de_pix_s + mode->hdisplay;
> +	hs_pix_s     = mode->hsync_start - mode->hdisplay;
> +	hs_pix_e     = hs_pix_s + mode->hsync_end - mode->hsync_start;

Correct, however, these can be simplified.

For de_pix_e:

	de_pix_e = de_pix_s + mode->hdisplay;
	de_pix_s = mode->htotal - mode->hdisplay;

Putting de_pix_s into de_pix_e's equation, you get:

	de_pix_e = mode->htotal - mode->hdisplay + mode->hdisplay;

which ends up simply as:

	de_pix_e = mode->htotal;

Now, doing the same for hs_pix_e:

	hs_pix_e = mode->hsync_start - mode->hdisplay + mode->hsync_end - mode->hsync_start;

which ends up as:

	hs_pix_e = mode->hsync_end - mode->hdisplay;

So overall these come out as:

	de_pix_e = mode->htotal;
	de_pix_s = mode->htotal - mode->hdisplay;
	hs_pix_e = mode->hsync_end - mode->hdisplay;
	hs_pix_s = mode->hsync_start - mode->hdisplay;

I've listed them in reverse order because it makes more sense to me when
thinking about it.  What we're basically doing is rotating this by
hdisplay pixel clocks to the left, so using abbreviations:

ht=htotal
hds=hdisplay start
hde=hdisplay end
hss=hsync_start
hse=hsync_end

0                                                ht
hds                                hde  hss hse   |
|-----------------------------------|----|---|----|

becomes:
0                                                ht
0   hss hse  hds                                hde
|----|---|----|-----------------------------------|

and from that you can visualize taking hdisplay (being hde-hds) off each
timing parameter modulo htotal gives you the above equations.

These calculations are the same as what was originally in the driver:

+       de_start   = mode->htotal - mode->hdisplay;
+       de_end     = mode->htotal;
+       hs_start   = mode->hsync_start - mode->hdisplay;
+       hs_end     = mode->hsync_end - mode->hdisplay;

when it was first committed.

This is otherwise exactly what I came up with which gets my TV working
again in HDMI mode.
