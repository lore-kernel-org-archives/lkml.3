Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3C2Aq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 20:46:59 -0400
Received: from relay03.pair.com ([209.68.5.17]:4098 "HELO relay03.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753779Ab3C2Aq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 20:46:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 20:46:57 EDT
X-pair-Authenticated: 108.45.91.222
Message-ID: <5154E2EF.70404@flaterco.com>
Date: Thu, 28 Mar 2013 20:40:15 -0400
From: David Flater <vger@flaterco.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: perex@perex.cz, abelay@mit.edu, bhelgaas@google.com
Subject: [PATCH] pnp: restore automatic resolution of DMA conflicts
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Flater <dave@flaterco.com>

To fix a 5-year-old regression, reverse the changes made in the
following commit:

commit 7ef36390fabe2168fe31f245e49eb4e5f3762622
Author: Jan Beulich <jbeulich@novell.com>
Date:   Tue Oct 16 23:31:07 2007 -0700

    PNP: don't fail device init if no DMA channel available
    
    Most drivers for devices supporting ISA DMA can operate without
    DMA as well (falling back zo PIO).  Thus it seems inappropriate
    for PNP to fail device initialization in case none of the possible
    DMA channels are available.  Instead, it should be left to the
    driver to decide what to do if request_dma() fails.
    
    The patch at once adjusts the code to account for the fact that
    pnp_assign_dma() now doesn't need to report failure anymore.

As an example to show the problem, my sound card provides a
prioritized list of PnP "dependent sets" of requested resources:

  dependent set 0 (preferred) wants DMA 5.
  dependent set 1 (acceptable) will take DMA 5, 6, or 7.
  ...
  dependent set 4 (acceptable) doesn't request a high DMA.

If DMA 5 is not available, pnp_assign_dma has to fail on set 0 so that
pnp_auto_config_dev will move on to set 1 and get DMA 6 or 7.
Instead, pnp_assign_dma adds the resource with flags |=
IORESOURCE_DISABLED and returns success.  pnp_auto_config_dev just
sees success and therefore chooses set 0 with a disabled DMA and never
tries the sets that would have resolved the conflict.

Furthermore, this mode of "success" is unexpected and unhandled in
sound/isa/sb and probably other drivers.  sb assumes that the returned
DMA is enabled and obliviously uses the invalid DMA number.  Observed
consequences were sb successfully grabbing a DMA that was expressly
forbidden by the kernel parameter pnp_reserve_dma.

The only upside to the original change would be as a kludge for
devices that can operate in degraded mode without a DMA but that don't
provide the corresponding non-preferred dependent set.  The right
workaround for those devices is to synthesize the missing set in
quirks.c; otherwise, you're reinventing PnP fallback functionality at
the driver level for that device and all others.

Signed-off-by: David Flater <dave@flaterco.com>
---
 drivers/pnp/manager.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
index 95cebf0..1c25959 100644
--- a/drivers/pnp/manager.c
+++ b/drivers/pnp/manager.c
@@ -218,11 +218,9 @@ static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 				goto __add;
 		}
 	}
-#ifdef MAX_DMA_CHANNELS
-	res->start = res->end = MAX_DMA_CHANNELS;
-#endif
-	res->flags |= IORESOURCE_DISABLED;
-	pnp_dbg(&dev->dev, "  disable dma %d\n", idx);
+
+	pnp_dbg(&dev->dev, "  couldn't assign dma %d\n", idx);
+	return -EBUSY;
 
 __add:
 	pnp_add_dma_resource(dev, res->start, res->flags);
