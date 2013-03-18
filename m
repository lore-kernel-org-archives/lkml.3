Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3CRTQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:16:23 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33156 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3CRTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:16:20 -0400
Date: Mon, 18 Mar 2013 20:19:03 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Yinghai Lu <yinghai@kernel.org>, Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.9-rc1] irq 16: nobody cared (was [3.9-rc1] very poor
 interrupt responses)
Message-ID: <20130318191903.GS9021@phenom.ffwll.local>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Yinghai Lu <yinghai@kernel.org>,
	Harald Arnesen <skogtun.linux@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Peter Hurley <peter@hurleysoftware.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thomas Meyer <thomas@m3y3r.de>,
	Shawn Starr <shawn.starr@rogers.com>,
	USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Imre Deak <imre.deak@intel.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	dri-devel@lists.freedesktop.org
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org>
 <1460519.ejNFI1DrGk@vostro.rjw.lan>
 <1363280764.26318.4.camel@thor.lan>
 <5657408.cYX6iimiA4@vostro.rjw.lan>
 <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
 <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
 <alpine.LNX.2.00.1303151609480.9529@pobox.suse.cz>
 <CAE9FiQUqPTUqPOzANnxpdfoRYPr+OiU5pFEoLKRiOFHd9Py4XQ@mail.gmail.com>
 <alpine.LNX.2.00.1303181010080.9529@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303181010080.9529@pobox.suse.cz>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:12:49AM +0100, Jiri Kosina wrote:
> On Fri, 15 Mar 2013, Yinghai Lu wrote:
> 
> > > Just a datapoint -- I have put a trivial debugging patch in place, and it
> > > reveals that "nobody cared" for irq 16 happens long after last
> > >
> > >         I915_WRITE(GMBUS4 + reg_offset, 0);
> > >
> > > has been performed in gmbus_wait_hw_status(). On the other hand, if I
> > > comment out both GMBUS4 register offset writes in gmbus_wait_hw_status(),
> > > then it of course falls back to GPIO bit-banging, but the "nobody cared"
> > > for irq 16 is gone.
> > >
> > > So it seems like something gets severely confused by the I915_WRITE to
> > > GMBUS4 + reg_offset. So far this seems to have been reported solely on
> > > Lenovos as far as I can see (although a completely different types), so it
> > > might be some platform-specific quirk?
> > >
> > > Honestly, I still don't understand how all the GMBUS stuff relates to IRQ
> > > 16 at all.
> > 
> > that device is using
> > i915 0000:00:02.0: irq 44 for MSI/MSI-X
> > 
> > so can you try to boot with pci=nomsi?
> 
> Yes, switching from MSI to IO-APIC-fasteoi makes the report about lost 
> interrupts go away.
> 
> My understanding from the other mail is that DAniel Vetter already has an 
> idea what might be going wrong with IRQ acking on GM45 chipsets; hopefully 
> this datapoint regarding MSI will fit into it.

Yep, there's a big comment in the irq handler for that chipset that we
have a gaping race with when using MSI interrupts. Although the comment
bodly claims that the race is small enough to avoid the dreaded "nobody
cared" message. Looks like gmbus is good at hitting that race - on newer
chips it already brought up a similar race in handling pch interrupts.

Can you please give the below patch a whirl? It removes the probably race
msi race avoidance code and replaces it with the same trick Paulo used to
fix pch irq handling races.

Thanks, Daniel
---
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 3c7bb04..13de12e 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2684,7 +2684,7 @@ static irqreturn_t i965_irq_handler(int irq, void *arg)
 {
 	struct drm_device *dev = (struct drm_device *) arg;
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	u32 iir, new_iir;
+	u32 iir, new_iir, ier;
 	u32 pipe_stats[I915_MAX_PIPES];
 	unsigned long irqflags;
 	int irq_received;
@@ -2692,9 +2692,14 @@ static irqreturn_t i965_irq_handler(int irq, void *arg)
 
 	atomic_inc(&dev_priv->irq_received);
 
+	/* irq race avoidance, copy&pasta from Paulo's PCH irq fix */
+	ier = I915_READ(IER);
+	I915_WRITE(IER, 0);
+	POSTING_READ(IER);
+
 	iir = I915_READ(IIR);
 
-	for (;;) {
+	do {
 		bool blc_event = false;
 
 		irq_received = iir != 0;
@@ -2792,7 +2797,10 @@ static irqreturn_t i965_irq_handler(int irq, void *arg)
 		 * stray interrupts.
 		 */
 		iir = new_iir;
-	}
+	} while (0);
+
+	I915_WRITE(IER, ier);
+	POSTING_READ(IER);
 
 	i915_update_dri1_breadcrumb(dev);
 
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
