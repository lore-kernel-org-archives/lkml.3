Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3HEWmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:42:12 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53234 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753632Ab3HEWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:42:11 -0400
Date: Mon, 5 Aug 2013 15:42:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Furquan Shaikh <furquan@google.com>
Cc: intel-gfx@lists.freedesktop.org, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Josh Triplett <josh.triplett@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ronald Minnich <rminnich@google.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: add fast boot support for Haswell
Message-ID: <20130805154230.57f3ae07@jbarnes-desktop>
In-Reply-To: <1375391542-21936-1-git-send-email-furquan@google.com>
References: <1375391542-21936-1-git-send-email-furquan@google.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Aug 2013 14:12:22 -0700
Furquan Shaikh <furquan@google.com> wrote:

> @@ -1282,6 +1283,13 @@ static void intel_ddi_get_config(struct intel_encoder *encoder,
>  		flags |= DRM_MODE_FLAG_NVSYNC;
>  
>  	pipe_config->adjusted_mode.flags |= flags;
> +
> +	if (port == PORT_A) {
> +		if ((I915_READ(DP_A) & DP_PLL_FREQ_MASK) == DP_PLL_FREQ_160MHZ)
> +			pipe_config->port_clock = 162000;
> +		else
> +			pipe_config->port_clock = 270000;
> +	}

Sorry Furquan, I should have checked this earlier, I knew it was too
good to be true. :)

On HSW, DP_A is actually DDI_BUF_CTL, and it has a different layout
than the old DP_A reg.  Like Daniel said, doing it the old way is
invalid on HSW.  It might work in your configs, but I think that's just
coincidence, since bit 16 is the port reversal bit on HSW, not the
clock freq.

To get the clock freq, you need to look at 0x45020 to find the refclk,
then look at the WRPLL_CTL for the pipe to get the dividers.  That's
what Daniel meant when he asked for a full "clock_get" function.  It's
only a little more complicated, but you'll need docs for it.  Charlie
Huang ought to be able to get you the NDA docs that should have the
info you need.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
