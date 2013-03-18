Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3CRREw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:04:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:55765 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab3CRREt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="304577325"
Date: Mon, 18 Mar 2013 17:04:24 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Vetter <daniel@ffwll.ch>, Greg KH <greg@kroah.com>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re:
 [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses))
Message-ID: <20130318170424.GB5571@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Kosina <jkosina@suse.cz>, Daniel Vetter <daniel@ffwll.ch>,
	Greg KH <greg@kroah.com>, Harald Arnesen <skogtun.linux@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Peter Hurley <peter@hurleysoftware.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thomas Meyer <thomas@m3y3r.de>,
	Shawn Starr <shawn.starr@rogers.com>,
	USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Yinghai Lu <yinghai@kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Imre Deak <imre.deak@intel.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	dri-devel@lists.freedesktop.org
References: <1363280764.26318.4.camel@thor.lan>
 <5657408.cYX6iimiA4@vostro.rjw.lan>
 <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
 <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
 <20130315153249.GA32425@kroah.com>
 <alpine.LNX.2.00.1303151636481.9529@pobox.suse.cz>
 <20130315154739.GA1024@kroah.com>
 <20130318082156.GO9021@phenom.ffwll.local>
 <alpine.LNX.2.00.1303181522460.9529@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303181522460.9529@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 04:56:02PM +0100, Jiri Kosina wrote:
> Okay, so I think that for 3.9 we want the patch below, and if eventually 
> hardware root cause / workaround is found for GM45, we can have it merged 
> later.
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips
> 
> Commit 28c70f162 ("drm/i915: use the gmbus irq for waits") switched to
> using GMBUS irqs instead of GPIO bit-banging for chipset generations 4
> and above.
> 
> It turns out though that on many systems this leads to spurious interrupts
> being generated, long after the register write to disable the IRQs has been
> issued.
> 
> Flushing of the register writes by POSTING_READ() directly after the register
> write doesn't work either.
> 
> Disable using of GMBUS IRQs on Gen4 systems before the root cause is found and
> revert back to old behavior.
> 
> Also be more careful about not issuing GMBUS4 register reads in 
> gmbus_wait_hw_status() if we are not using GMBUS IRQs.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/gpu/drm/i915/intel_i2c.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index acf8aec..8638036 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -58,12 +58,14 @@ to_intel_gmbus(struct i2c_adapter *i2c)
>  	return container_of(i2c, struct intel_gmbus, adapter);
>  }
>  
> +#define HAS_GMBUS_IRQ(dev) (INTEL_INFO(dev)->gen >= 5)
>  void
>  intel_i2c_reset(struct drm_device *dev)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS0, 0);
> -	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS4, 0);
> +	if (HAS_GMBUS_IRQ(dev))
> +		I915_WRITE(dev_priv->gpio_mmio_base + GMBUS4, 0);

There should not be any harm in always clearing GMBUS4, it exists on all
platforms.

>  }
>  
>  static void intel_i2c_quirk_set(struct drm_i915_private *dev_priv, bool enable)
> @@ -203,7 +205,6 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
>  	algo->data = bus;
>  }
>  
> -#define HAS_GMBUS_IRQ(dev) (INTEL_INFO(dev)->gen >= 4)
>  static int
>  gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
>  		     u32 gmbus2_status,
> @@ -214,6 +215,13 @@ gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
>  	u32 gmbus2 = 0;
>  	DEFINE_WAIT(wait);
>  
> +	if (!HAS_GMBUS_IRQ(dev_priv->dev)) {
> +		int ret;
> +		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
> +				(GMBUS_SATOER | gmbus2_status),
> +				50);

This should couple up to the normal return code that chooses the
appropriate return value based on gmbus2.

How about just using:
  if (!HAS_GMBUS_IRQ(dev_priv->dev)) gmbus4_irq_en = 0;
and the existing wait loop?

> +		return ret;
> +	}
>  	/* Important: The hw handles only the first bit, so set only one! Since
>  	 * we also need to check for NAKs besides the hw ready/idle signal, we
>  	 * need to wake up periodically and check that ourselves. */

-- 
Chris Wilson, Intel Open Source Technology Centre
