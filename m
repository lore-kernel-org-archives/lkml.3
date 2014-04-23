Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaDWNLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:11:15 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44393 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaDWNLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:11:11 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
To: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>
In-Reply-To: <20140423104528.GD30036@e106331-lin.cambridge.arm.com>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
	<1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
	<CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
	<20140418125924.GF5904@bivouac.eciton.net>
	<20140422133515.E7A0BC40754@trevor.secretlab.ca>
	<20140423104528.GD30036@e106331-lin.cambridge.arm.com>
Date: Wed, 23 Apr 2014 14:10:58 +0100
Message-Id: <20140423131058.D94B6C408D2@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 11:45:28 +0100, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Apr 22, 2014 at 02:35:15PM +0100, Grant Likely wrote:
> > On Fri, 18 Apr 2014 13:59:24 +0100, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > > Hi Geert,
> > > 
> > > On Fri, Apr 18, 2014 at 10:04:15AM +0200, Geert Uytterhoeven wrote:
> > > > On Thu, Apr 17, 2014 at 7:42 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > > > > In order to deal with an firmware bug on a specific ppc32 platform
> > > > > (longtrail), early_init_dt_scan_memory() looks for a node called
> > > > > memory@0 on all platforms. Restrict this quirk to ppc32 kernels only.
> > > > 
> > > > This breaks backwards compatibilty with old DTSes (at least on ARM/MIPS,
> > > > where you added the missing property in patches 1 and 2 of the series)?
> > > 
> > > As Rob said in response to 0/3, the MIPSs would likely not be affected,
> > > since they embed the DT.
> > > 
> > > > For the Longtrail, I don't care much anymore, as mine died in 2004.
> > > > AFAIK, there have never been many users anyway.
> > > 
> > > There are still a few mentions of it under arch/powerpc/, so I wouldn't
> > > want to be the one to kill it off...
> > > 
> > > How about the below v2 3/3 to address the ARM platform?
> > 
> > The problem with this approach is that selecting one board that needs it
> > automatically makes it active for all boards. It would need to be
> > something more like the following:
> > 
> > diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> > index 399e242e1a42..55d65b2b4c74 100644
> > --- a/drivers/of/fdt.c
> > +++ b/drivers/of/fdt.c
> > @@ -887,12 +887,10 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
> >  
> >  	/* We are scanning "memory" nodes only */
> >  	if (type == NULL) {
> > -		/*
> > -		 * The longtrail doesn't have a device_type on the
> > -		 * /memory node, so look for the node called /memory@0.
> > -		 */
> >  		if (depth != 1 || strcmp(uname, "memory@0") != 0)
> >  			return 0;
> > +		if (!of_flat_dt_match(dt_root, memory_quirk_list))
> > +			return 0;
> >  	} else if (strcmp(type, "memory") != 0)
> >  		return 0;
> >  
> > With a list of compatible properties for affected boards.
> 
> That looks sane to me.
> 
> Does anyone have a LongTrail DT to hand, and if so does the root have a
> compatible string? From grepping through the kernel I could only find a
> model string ("IBM,LongTrail").

Actually, on LongTrail this can be removed from the common code
entirely. It has real open firmware and PowerPC already has the
infrastructure for fixing up the device tree.

Here's a draft patch that I've compile tested, but nothing else.

g.

---

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 078145acf7fb..18b2c3fee98f 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2587,9 +2587,18 @@ static void __init fixup_device_tree_chrp(void)
 	phandle ph;
 	u32 prop[6];
 	u32 rloc = 0x01006000; /* IO space; PCI device = 12 */
-	char *name;
+	char *name, strprop[16];
 	int rc;
 
+	/* Deal with missing device_type in LongTrail memory node */
+	name = "/memory@0";
+	ph = call_prom("finddevice", 1, 1, ADDR(name));
+	rc = prom_getprop(ph, "device_type", strprop, sizeof(strprop));
+	if (rc == PROM_ERROR || strcmp(strprop, "memory") != 0) {
+		prom_printf("Fixing up missing device_type on /memory@0 node...\n");
+		prom_setprop(ph, name, "device_type", "memory", sizeof("memory"));
+	}
+
 	name = "/pci@80000000/isa@c";
 	ph = call_prom("finddevice", 1, 1, ADDR(name));
 	if (!PHANDLE_VALID(ph)) {
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 7a2ef7bb8022..7cda0d279cbe 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -886,14 +886,7 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 	unsigned long l;
 
 	/* We are scanning "memory" nodes only */
-	if (type == NULL) {
-		/*
-		 * The longtrail doesn't have a device_type on the
-		 * /memory node, so look for the node called /memory@0.
-		 */
-		if (depth != 1 || strcmp(uname, "memory@0") != 0)
-			return 0;
-	} else if (strcmp(type, "memory") != 0)
+	if (!type || strcmp(type, "memory") != 0)
 		return 0;
 
 	reg = of_get_flat_dt_prop(node, "linux,usable-memory", &l);

