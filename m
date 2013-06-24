Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3FXSaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:30:13 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45294 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FXSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:30:11 -0400
Date: Mon, 24 Jun 2013 20:30:08 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk,
        imre.deak@intel.com, daniel.vetter@ffwll.ch, airlied@linux.ie,
        airlied@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: make compact dma scatter lists creation work
 with SWIOTLB backend.
Message-ID: <20130624183008.GI5823@phenom.ffwll.local>
Mail-Followup-To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk,
	imre.deak@intel.com, airlied@linux.ie, airlied@gmail.com,
	linux-kernel@vger.kernel.org
References: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
 <1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
X-Operating-System: Linux phenom 3.10.0-rc5+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 11:47:48AM -0400, Konrad Rzeszutek Wilk wrote:
> Git commit 90797e6d1ec0dfde6ba62a48b9ee3803887d6ed4
> ("drm/i915: create compact dma scatter lists for gem objects") makes
> certain assumptions about the under laying DMA API that are not always
> correct.
> 
> On a ThinkPad X230 with an Intel HD 4000 with Xen during the bootup
> I see:
> 
> [drm:intel_pipe_set_base] *ERROR* pin & fence failed
> [drm:intel_crtc_set_config] *ERROR* failed to set mode on [CRTC:3], err = -28
> 
> Bit of debugging traced it down to dma_map_sg failing (in
> i915_gem_gtt_prepare_object) as some of the SG entries were huge (3MB).
> 
> That unfortunately are sizes that the SWIOTLB is incapable of handling -
> the maximum it can handle is a an entry of 512KB of virtual contiguous
> memory for its bounce buffer. (See IO_TLB_SEGSIZE).
> 
> Previous to the above mention git commit the SG entries were of 4KB, and
> the code introduced by above git commit squashed the CPU contiguous PFNs
> in one big virtual address provided to DMA API.
> 
> This patch is a simple semi-revert - were we emulate the old behavior
> if we detect that SWIOTLB is online. If it is not online then we continue
> on with the new compact scatter gather mechanism.
> 
> An alternative solution would be for the the '.get_pages' and the
> i915_gem_gtt_prepare_object to retry with smaller max gap of the
> amount of PFNs that can be combined together - but with this issue
> discovered during rc7 that might be too risky.
> 
> Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: Chris Wilson <chris@chris-wilson.co.uk>
> CC: Imre Deak <imre.deak@intel.com>
> CC: Daniel Vetter <daniel.vetter@ffwll.ch>
> CC: David Airlie <airlied@linux.ie>
> CC: <dri-devel@lists.freedesktop.org>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Queued for -next (with cc: stable), thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
