Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3CSJDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:03:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:16019 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab3CSJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,870,1355126400"; 
   d="scan'208";a="304977473"
Date: Tue, 19 Mar 2013 09:03:16 +0000
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
Message-ID: <20130319090316.GB3872@cantiga.alporthouse.com>
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
References: <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
 <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
 <20130315153249.GA32425@kroah.com>
 <alpine.LNX.2.00.1303151636481.9529@pobox.suse.cz>
 <20130315154739.GA1024@kroah.com>
 <20130318082156.GO9021@phenom.ffwll.local>
 <alpine.LNX.2.00.1303181522460.9529@pobox.suse.cz>
 <20130318170424.GB5571@cantiga.alporthouse.com>
 <alpine.LNX.2.00.1303190953010.9529@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303190953010.9529@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 09:56:57AM +0100, Jiri Kosina wrote:
> On Mon, 18 Mar 2013, Chris Wilson wrote:
> 
> > > +#define HAS_GMBUS_IRQ(dev) (INTEL_INFO(dev)->gen >= 5)
> > >  void
> > >  intel_i2c_reset(struct drm_device *dev)
> > >  {
> > >  	struct drm_i915_private *dev_priv = dev->dev_private;
> > >  	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS0, 0);
> > > -	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS4, 0);
> > > +	if (HAS_GMBUS_IRQ(dev))
> > > +		I915_WRITE(dev_priv->gpio_mmio_base + GMBUS4, 0);
> > 
> > There should not be any harm in always clearing GMBUS4, it exists on all
> > platforms.
> > 
> > >  }
> > >  
> > >  static void intel_i2c_quirk_set(struct drm_i915_private *dev_priv, bool enable)
> > > @@ -203,7 +205,6 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
> > >  	algo->data = bus;
> > >  }
> > >  
> > > -#define HAS_GMBUS_IRQ(dev) (INTEL_INFO(dev)->gen >= 4)
> > >  static int
> > >  gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
> > >  		     u32 gmbus2_status,
> > > @@ -214,6 +215,13 @@ gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
> > >  	u32 gmbus2 = 0;
> > >  	DEFINE_WAIT(wait);
> > >  
> > > +	if (!HAS_GMBUS_IRQ(dev_priv->dev)) {
> > > +		int ret;
> > > +		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
> > > +				(GMBUS_SATOER | gmbus2_status),
> > > +				50);
> > 
> > This should couple up to the normal return code that chooses the
> > appropriate return value based on gmbus2.
> > 
> > How about just using:
> >   if (!HAS_GMBUS_IRQ(dev_priv->dev)) gmbus4_irq_en = 0;
> > and the existing wait loop?
> 
> I explicitly wanted to avoid touching GMBUS4 register, as the real cause 
> of the failure is not clear.
> 
> But, as Yinghai Lu points out, the problem is most likely caused by 
> interrupt disabling not working properly (see his very good point 
> regarding DisINTx+ and INTx+ discrepancy), so zeroing the register out 
> should work .... and it indeed does in my case, hence the (tested) patch 
> below.
> 
> I think it's a 3.9-rc material, and I am all open to debug this further 
> for 3.10 so that the race is closed and gmbus irqs can be used on Gen4 
> platform properly.

Agreed. Using the IRQ for GMBUS is just a performance feature that can
be deferred until after we determine the root cause - and hope that the
failure is somehow peculiar to GMBUS.

Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
