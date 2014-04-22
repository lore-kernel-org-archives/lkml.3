Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaDVNf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:35:28 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46637 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbaDVNf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:35:27 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
To: Leif Lindholm <leif.lindholm@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches@linaro.org,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>
In-Reply-To: <20140418125924.GF5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
	<1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
	<CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
	<20140418125924.GF5904@bivouac.eciton.net>
Date: Tue, 22 Apr 2014 14:35:15 +0100
Message-Id: <20140422133515.E7A0BC40754@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014 13:59:24 +0100, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> Hi Geert,
> 
> On Fri, Apr 18, 2014 at 10:04:15AM +0200, Geert Uytterhoeven wrote:
> > On Thu, Apr 17, 2014 at 7:42 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > > In order to deal with an firmware bug on a specific ppc32 platform
> > > (longtrail), early_init_dt_scan_memory() looks for a node called
> > > memory@0 on all platforms. Restrict this quirk to ppc32 kernels only.
> > 
> > This breaks backwards compatibilty with old DTSes (at least on ARM/MIPS,
> > where you added the missing property in patches 1 and 2 of the series)?
> 
> As Rob said in response to 0/3, the MIPSs would likely not be affected,
> since they embed the DT.
> 
> > For the Longtrail, I don't care much anymore, as mine died in 2004.
> > AFAIK, there have never been many users anyway.
> 
> There are still a few mentions of it under arch/powerpc/, so I wouldn't
> want to be the one to kill it off...
> 
> How about the below v2 3/3 to address the ARM platform?

The problem with this approach is that selecting one board that needs it
automatically makes it active for all boards. It would need to be
something more like the following:

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 399e242e1a42..55d65b2b4c74 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -887,12 +887,10 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 
 	/* We are scanning "memory" nodes only */
 	if (type == NULL) {
-		/*
-		 * The longtrail doesn't have a device_type on the
-		 * /memory node, so look for the node called /memory@0.
-		 */
 		if (depth != 1 || strcmp(uname, "memory@0") != 0)
 			return 0;
+		if (!of_flat_dt_match(dt_root, memory_quirk_list))
+			return 0;
 	} else if (strcmp(type, "memory") != 0)
 		return 0;
 
With a list of compatible properties for affected boards.

g.

