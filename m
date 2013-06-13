Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3FMQOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:14:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51893 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3FMQO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:14:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+mLMdLRTdSpg9DyLACaY7m
Date: Thu, 13 Jun 2013 09:14:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130613161418.GJ8164@atomide.com>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613155240.GB3775@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [130613 08:58]:
> Hi!
> 
> > * Pavel Machek <pavel@ucw.cz> [130613 07:34]:
> > > On Thu 2013-06-13 07:10:01, Tony Lindgren wrote:
> > > > * Pavel Machek <pavel@ucw.cz> [130613 06:32]:
> > > >  
> > > > > If I init spi manually (and some more hacks), it works in the
> > > > > qemu. But I have not tested on real hw for a while.
> > > > 
> > > > You should be able to initialize spi by adding the .dts entry,
> > > > or is there something missing in drivers/spi/spi-omap2-mcspi.c?
> > > 
> > > Not sure, I guess I'll find out soon. Do you have example dts that
> > > uses drivers/spi/spi-omap2-mcspi.c? Grepping spi in dts/ was not too
> > > successful.
> > 
> > Hmm I think all we have is what's written in
> > Documentation/devicetree/bindings/spi/omap-spi.txt and
> > omap4-sdp.dts.
> 
> Ok, this was easier than expected.

Cool.
 
> Now, by chance, any idea what is DT equivalent of 
> 
> omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);

You can try the attached hack after calling the above to grep for
pins in /sys/kernel/debug/omap_mux/board/core and you get the pins
in DT suitable format. There's a bug where the the pins are not
correctly split between core and wkup domains in the legacy mux fwk,
but you probably won't need to mux many wkup domain pins.

Then you just need to add the pinctr-single entries for each device,
but AFAIK most of the pins are muxed correctly in the bootloader
for the Nokia boards.
 
> (Plus I'll still have to figure out why it works on emulator but not
> on hw).

Might be the muxing..

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Fri, 7 Jun 2013 08:54:59 -0700
Subject: [PATCH] Not for merging: Allows dumping out mux entries in .dts format using legacy mux

For pinctrl-single.c we should eventually have a user space
app to configure and display pin settings. Meanwhile, allow
using the legacy mux interface to do that:

# mount -t debugfs debugfs /sys/kernel/debug
# cat /sys/kernel/debug/omap_mux/board/wkup | grep fref_clk0_out
	0x14 0x2        /* fref_clk0_out.sys_drm_msecure gpio6 OUTPUT | MODE2 */

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 48094b58..6f5224a 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -35,11 +35,10 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-
 #include "omap_hwmod.h"
-
 #include "soc.h"
 #include "control.h"
+#include "id.h"
 #include "mux.h"
 #include "prm.h"
 #include "common.h"
@@ -505,17 +504,17 @@ void omap_hwmod_mux(struct omap_hwmod_mux_info *hmux, u8 state)
 #define OMAP_MUX_TEST_FLAG(val, mask)				\
 	if (((val) & (mask)) == (mask)) {			\
 		i++;						\
-		flags[i] =  #mask;				\
+		flags[i] =  #mask + sizeof("OMAP_PIN_") - 1;	\
 	}
 
 /* REVISIT: Add checking for non-optimal mux settings */
 static inline void omap_mux_decode(struct seq_file *s, u16 val)
 {
 	char *flags[OMAP_MUX_MAX_NR_FLAGS];
-	char mode[sizeof("OMAP_MUX_MODE") + 1];
+	char mode[sizeof("MODE") + 1];
 	int i = -1;
 
-	sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);
+	sprintf(mode, "MODE%d", val & 0x7);
 	i++;
 	flags[i] = mode;
 
@@ -553,7 +552,7 @@ static inline void omap_mux_decode(struct seq_file *s, u16 val)
 		}
 	} else {
 		i++;
-		flags[i] = "OMAP_PIN_OUTPUT";
+		flags[i] = "OUTPUT";
 	}
 
 	do {
@@ -568,15 +567,26 @@ static inline void omap_mux_decode(struct seq_file *s, u16 val)
 static int omap_mux_dbg_board_show(struct seq_file *s, void *unused)
 {
 	struct omap_mux_partition *partition = s->private;
+	int pbase = (int)partition->base;
 	struct omap_mux_entry *e;
-	u8 omap_gen = omap_rev() >> 28;
+
+	if (!(pbase & 0xfff))
+		pbase = 0x40;
+	else
+		pbase = 0;
+
+	seq_printf(s, "\t\tpinctrl-single,pins = <\n");
 
 	list_for_each_entry(e, &partition->muxmodes, node) {
 		struct omap_mux *m = &e->mux;
 		char m0_def[OMAP_MUX_DEFNAME_LEN];
 		char *m0_name = m->muxnames[0];
 		u16 val;
-		int i, mode;
+		int padconf_offset, i, mode;
+
+		padconf_offset = m->reg_offset - pbase;
+		if (cpu_is_omap3630() && padconf_offset > 0x5ca)
+			continue;
 
 		if (!m0_name)
 			continue;
@@ -591,18 +601,14 @@ static int omap_mux_dbg_board_show(struct seq_file *s, void *unused)
 		}
 		val = omap_mux_read(partition, m->reg_offset);
 		mode = val & OMAP_MUX_MODE7;
-		if (mode != 0)
-			seq_printf(s, "/* %s */\n", m->muxnames[mode]);
-
-		/*
-		 * XXX: Might be revisited to support differences across
-		 * same OMAP generation.
-		 */
-		seq_printf(s, "OMAP%d_MUX(%s, ", omap_gen, m0_def);
+		seq_printf(s, "\t\t\t0x%x 0x%x\t/* %s.%s gpio%i ",
+			   padconf_offset, val, m->muxnames[0], m->muxnames[mode], m->gpio);
 		omap_mux_decode(s, val);
-		seq_printf(s, "),\n");
+		seq_printf(s, " */\n");
 	}
 
+	seq_printf(s, "\t\t>;\n");
+
 	return 0;
 }
 
