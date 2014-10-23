Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaJWHsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:48:21 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:64537 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbaJWHsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:48:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Thu, 23 Oct 2014 08:47:39 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Robert Bragg <robert@sixbynine.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [RFC PATCH 3/3] i915: Expose PMU for Observation Architecture
Message-ID: <20141023074739.GH13512@nuc-i3427.alporthouse.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <1413991731-20628-4-git-send-email-robert@sixbynine.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413991731-20628-4-git-send-email-robert@sixbynine.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:28:51PM +0100, Robert Bragg wrote:
> +	/* XXX: Not sure that this is really acceptable...
> +	 *
> +	 * i915_gem_context.c currently owns pinning/unpinning legacy
> +	 * context buffers and although that code has a
> +	 * get_context_alignment() func to handle a different
> +	 * constraint for gen6 we are assuming it's fixed for gen7
> +	 * here. Another option besides pinning here would be to
> +	 * instead hook into context switching and update the
> +	 * OACONTROL configuration on the fly.
> +	 */
> +	if (dev_priv->oa_pmu.specific_ctx) {
> +		struct intel_context *ctx = dev_priv->oa_pmu.specific_ctx;
> +		int ret;
> +
> +		ret = i915_gem_obj_ggtt_pin(ctx->legacy_hw_ctx.rcs_state,
> +					    4096, 0);

Right if you pin it here with a different alignment, when we try to pin
it with the required hw ctx alignment it will fail. Easiest way is to
record the ctx->legacy_hw_ctx.alignment and reuse that here.

> +		if (ret) {
> +			DRM_DEBUG_DRIVER("Couldn't pin %d\n", ret);
> +			ret = -EBUSY;

As an exercise, think of all the possible error values from pin() and
tell me why overriding that here is a bad, bad idea.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
