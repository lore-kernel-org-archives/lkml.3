Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3CRTSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:18:54 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44292 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3CRTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:18:52 -0400
Date: Mon, 18 Mar 2013 20:21:36 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Vetter <daniel@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
        Greg KH <greg@kroah.com>, Harald Arnesen <skogtun.linux@gmail.com>,
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
Message-ID: <20130318192135.GT9021@phenom.ffwll.local>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Chris Wilson <chris@chris-wilson.co.uk>, Greg KH <greg@kroah.com>,
	Harald Arnesen <skogtun.linux@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Peter Hurley <peter@hurleysoftware.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thomas Meyer <thomas@m3y3r.de>,
	Shawn Starr <shawn.starr@rogers.com>,
	USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Yinghai Lu <yinghai@kernel.org>, Imre Deak <imre.deak@intel.com>,
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
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 04:56:02PM +0100, Jiri Kosina wrote:
> Okay, so I think that for 3.9 we want the patch below, and if eventually 
> hardware root cause / workaround is found for GM45, we can have it merged 
> later.

I'd prefer if we dig into this for a bit more. I've been traveling last
week and only just now recovered from the mail backlog, hence my delays in
handling this.

Also the "nobody cared" showing up only very late after the last gmbus
transaction isn't too surprising: It only fires after 100k interrupts, and
apparently the irq handler is already a bit racy, so any interrupt might
push it over the edge. gmbus interrupts are apparently just help to expose
the race (presuming it's indeed the msi race already docuemented in the
code).
-Daniel

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
> +		return ret;
> +	}
>  	/* Important: The hw handles only the first bit, so set only one! Since
>  	 * we also need to check for NAKs besides the hw ready/idle signal, we
>  	 * need to wake up periodically and check that ourselves. */
> 
> -- 
> Jiri Kosina
> SUSE Labs

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
