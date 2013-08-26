Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3HZQFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:05:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab3HZQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:05:40 -0400
Message-ID: <1377533136.25163.159.camel@ul30vt.home>
Subject: Re: [PATCH v2] i915: Update VGA arbiter support for newer devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Aug 2013 10:05:36 -0600
In-Reply-To: <20130826122319.GO11428@intel.com>
References: <20130824144701.23370.42110.stgit@bling.home>
	 <20130826122319.GO11428@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-26 at 15:23 +0300, Ville Syrjälä wrote:
> On Sat, Aug 24, 2013 at 08:53:40AM -0600, Alex Williamson wrote:
> > This is intended to add VGA arbiter support for Intel HD graphics on
> > Core processors.  The old GMCH registers no longer exist, so even
> > though it appears that i915 participates in VGA arbitration, it doesn't
> > work.  On Intel HD graphics we already attempt to disable VGA regions
> > of the device.  This makes registering as a VGA client unnecessary since
> > we don't intend to operate differently depending on how many VGA devices
> > are present.  We can disable VGA memory regions by clearing the memory
> > enable bit in the VGA MSR.  That only leaves VGA IO, which we update
> > the VGA arbiter to know that we don't participate in VGA memory
> > arbitration.  We also add a hook on unload to re-enable memory and
> > reinstate VGA memory arbitration.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> > v2: I915_READ/WRITE accessors don't work in i915_disable_vga, use inb/outb
> >     directly.  Also, on the driver unbind VGA enable path, acquire legacy
> >     IO to re-enable VGA memory.  Correct comment.
> > 
> > As with v1, this depends on "vgaarb: Fixes for partial VGA opt-out".  With
> > all patches I'm able to assign a discrete PEG VGA device to a guest and
> > execute the VBIOS w/o interference from IGD or corruption of the IGD
> > framebuffer.
> 
> I glanced through those before, but I'll try to do a more thorough
> review soon.

Thanks!

> > 
> >  drivers/gpu/drm/i915/i915_dma.c      |    9 ++++++---
> >  drivers/gpu/drm/i915/intel_display.c |   24 ++++++++++++++++++++++++
> >  2 files changed, 30 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> > index f466980..d9cf216 100644
> > --- a/drivers/gpu/drm/i915/i915_dma.c
> > +++ b/drivers/gpu/drm/i915/i915_dma.c
> > @@ -1287,9 +1287,12 @@ static int i915_load_modeset_init(struct drm_device *dev)
> >  	 * then we do not take part in VGA arbitration and the
> >  	 * vga_client_register() fails with -ENODEV.
> >  	 */
> > -	ret = vga_client_register(dev->pdev, dev, NULL, i915_vga_set_decode);
> > -	if (ret && ret != -ENODEV)
> > -		goto out;
> > +	if (!HAS_PCH_SPLIT(dev)) {
> > +		ret = vga_client_register(dev->pdev, dev, NULL,
> > +					  i915_vga_set_decode);
> > +		if (ret && ret != -ENODEV)
> > +			goto out;
> > +	}
> 
> I think we should do something to fix i915_redisable_vga() for !pch
> platforms too. The MSR method should work for everything, so I'm leaning
> towards using it all the time. The other option would be add an mmio
> codepath into intel_disable_vga(), but then we have several codepaths
> to worry about.

Do you have time, systems, and interest to be able to test !pch?  I
assume that at some point in the past VGA arbiter did work on i915 with
the right hardware, so I didn't want to go breaking code that I can't
test.
  
> >  	intel_register_dsm_handler();
> >  
> > diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> > index 5fb3058..2bb805c 100644
> > --- a/drivers/gpu/drm/i915/intel_display.c
> > +++ b/drivers/gpu/drm/i915/intel_display.c
> > @@ -9519,6 +9519,15 @@ static void i915_disable_vga(struct drm_device *dev)
> >  	outb(SR01, VGA_SR_INDEX);
> >  	sr1 = inb(VGA_SR_DATA);
> >  	outb(sr1 | 1<<5, VGA_SR_DATA);
> > +
> > +	/* Disable VGA memory on Intel HD */
> > +	if (HAS_PCH_SPLIT(dev)) {
> > +		outb(inb(VGA_MSR_READ) & ~VGA_MSR_MEM_EN, VGA_MSR_WRITE);
> > +		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
> > +						   VGA_RSRC_NORMAL_IO |
> > +						   VGA_RSRC_NORMAL_MEM);
> > +	}
> > +
> >  	vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
> >  	udelay(300);
> >  
> > @@ -9526,6 +9535,19 @@ static void i915_disable_vga(struct drm_device *dev)
> >  	POSTING_READ(vga_reg);
> >  }
> >  
> > +static void i915_enable_vga(struct drm_device *dev)
> > +{
> 
> Not sure we need this actually. We don't re-enable the VGA display
> on unload, so you'll never see anything on the display anyway. But
> then again, I don't see any real harm in doing this either.

Right, I actually get a flood of DMAR errors from VT-d when I unbind the
device from i915, but that happens regardless of this patch.  I did
confirm that VGA memory is re-added to VGA arbitration though, which is
important because even if i915 doesn't leave the device in a usable
state we might still be able to pass it to a guest, which will rely on
the VGA arbiter control being re-enabled.

> > +	/* Enable VGA memory on Intel HD */
> > +	if (HAS_PCH_SPLIT(dev)) {
> > +		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
> > +		outb(inb(VGA_MSR_READ) | VGA_MSR_MEM_EN, VGA_MSR_WRITE);
> 
> I was thinking we might save the MSR state during driver load and
> restore to that same state, but it could be a bit overkill.

It seems unnecessary for just this bit, but if i915 wanted to restore
the device to a working VGA state it might make sense.  I have no idea
what would be involved for that.

> > +		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_MASK |
> 
> Maybe spell out IO and MEM for legacy too. Otherwise it looks a
> bit cryptic.

Ok.  Thanks,

Alex

> > +						   VGA_RSRC_NORMAL_IO |
> > +						   VGA_RSRC_NORMAL_MEM);
> > +		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
> > +	}
> > +}
> > +
> >  void intel_modeset_init_hw(struct drm_device *dev)
> >  {
> >  	intel_init_power_well(dev);
> > @@ -9983,6 +10005,8 @@ void intel_modeset_cleanup(struct drm_device *dev)
> >  
> >  	intel_disable_fbc(dev);
> >  
> > +	i915_enable_vga(dev);
> > +
> >  	intel_disable_gt_powersave(dev);
> >  
> >  	ironlake_teardown_rc6(dev);
> 



