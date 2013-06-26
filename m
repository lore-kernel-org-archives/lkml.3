Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3FZD6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:58:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:52071 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3FZD6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="260215007"
Message-ID: <1372219125.8177.12.camel@envy.home>
Subject: Re: [PATCH 2/8] pch_uart: Add uart_clk selection for the MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Date: Tue, 25 Jun 2013 20:58:45 -0700
In-Reply-To: <20130626033926.GA27165@kroah.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <6cc125b9eb85dd3cae4a2496fdb7f0d17b18f930.1372211451.git.dvhart@linux.intel.com>
	 <20130626023143.GB23320@kroah.com> <1372216578.8177.9.camel@envy.home>
	 <20130626033926.GA27165@kroah.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 20:39 -0700, Greg Kroah-Hartman wrote:
> On Tue, Jun 25, 2013 at 08:16:18PM -0700, Darren Hart wrote:
> > On Tue, 2013-06-25 at 19:31 -0700, Greg Kroah-Hartman wrote:
> > > On Tue, Jun 25, 2013 at 06:53:22PM -0700, Darren Hart wrote:
> > >   
> > > >  struct pch_uart_buffer {
> > > >  	unsigned char *buf;
> > > > @@ -398,6 +399,10 @@ static int pch_uart_get_uartclk(void)
> > > >  		    strstr(cmp, "nanoETXexpress-TT")))
> > > >  		return NTC1_UARTCLK;
> > > >  
> > > > +	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> > > > +	if (cmp && strstr(cmp, "MinnowBoard"))
> > > > +		return MINNOW_UARTCLK;
> > > > +
> > > 
> > > You know, we do have the DMI interface to handle this in a much nicer
> > > way instead of just randomly trying different strings over and over
> > > until we find one that matches...
> > 
> > I was aiming for minimal change. Partly because I'm lazy. Partly
> > because I don't have all of the impacted hardware to test. Partly
> > because I wanted to keep it simple so I could push this to 3.8 stable.
> 
> Then you should have marked it for the stable tree by putting the proper
> Cc: in the body of the patch...

I had expected there to be some discussion on this series as a whole
and didn't want to confuse things... I suppose that was silly as the
patch will just whither and die if it never makes it into mainline.
Apologies.

> 
> > I can rewrite this detection to use the DMI interface. Would you allow
> > it as a follow-on, to keep the changes to stable minimal?
> > 
> > Also, I do have a PCI subsystem ID for this particular board which I
> > could trigger on, but since that mechanism didn't exist in the driver
> > already and the other boards don't do it, I just followed what was
> > already there (yeah, so I wrote most of what was already there...
> > but.... anyway) :-)
> > 
> > What do you prefer? Rewrite, then add Minnow, or use this, then
> > rewrite?
> 
> How about this, which makes it easy to backport, then you fix it up
> properly for 3.12?  This comes after my tree is pretty much closed for
> 3.11, but a simple device id addition like this is acceptable, but I'll
> not get to it until after 3.11-rc1 is out...

Sure. So something like this is what you have in mind? Build tested
only, I'll include it in V2 with proper testing, but just wanted to
make sure we're on the same page while I have your attention:

>From 22cb21e2421ffcd439f58843422cff0e2579902f Mon Sep 17 00:00:00 2001
Message-Id:
<22cb21e2421ffcd439f58843422cff0e2579902f.1372219079.git.dvhart@linux.intel.com>
From: Darren Hart <dvhart@linux.intel.com>
Date: Tue, 25 Jun 2013 20:54:29 -0700
Subject: [PATCH] pch_uart: Use DMI interface for board detection

Use the DMI interface rather than manually matching DMI strings.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 drivers/tty/serial/pch_uart.c | 71
+++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c
b/drivers/tty/serial/pch_uart.c
index 572d481..271cc73 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -373,35 +373,62 @@ static const struct file_operations port_regs_ops
= {
 };
 #endif	/* CONFIG_DEBUG_FS */
 
+static struct dmi_system_id __initdata pch_uart_dmi_table[] = {
+	{
+		.ident = "CM-iTC",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "CM-iTC"),
+		},
+		(void *)CMITC_UARTCLK,
+	},
+	{
+		.ident = "FRI2",
+		{
+			DMI_MATCH(DMI_BIOS_VERSION, "FRI2"),
+		},
+		(void *)FRI2_64_UARTCLK,
+	},
+	{
+		.ident = "Fish River Island II",
+		{
+			DMI_MATCH(DMI_PRODUCT_NAME, "Fish River Island II"),
+		},
+		(void *)FRI2_48_UARTCLK,
+	},
+	{
+		.ident = "COMe-mTT",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mTT"),
+		},
+		(void *)NTC1_UARTCLK,
+	},
+	{
+		.ident = "nanoETXexpress-TT",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "nanoETXexpress-TT"),
+		},
+		(void *)NTC1_UARTCLK,
+	},
+	{
+		.ident = "MinnowBoard",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "MinnowBoard"),
+		},
+		(void *)MINNOW_UARTCLK,
+	},
+};
+
 /* Return UART clock, checking for board specific clocks. */
 static int pch_uart_get_uartclk(void)
 {
-	const char *cmp;
+	const struct dmi_system_id *d;
 
 	if (user_uartclk)
 		return user_uartclk;
 
-	cmp = dmi_get_system_info(DMI_BOARD_NAME);
-	if (cmp && strstr(cmp, "CM-iTC"))
-		return CMITC_UARTCLK;
-
-	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
-	if (cmp && strnstr(cmp, "FRI2", 4))
-		return FRI2_64_UARTCLK;
-
-	cmp = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (cmp && strstr(cmp, "Fish River Island II"))
-		return FRI2_48_UARTCLK;
-
-	/* Kontron COMe-mTT10 (nanoETXexpress-TT) */
-	cmp = dmi_get_system_info(DMI_BOARD_NAME);
-	if (cmp && (strstr(cmp, "COMe-mTT") ||
-		    strstr(cmp, "nanoETXexpress-TT")))
-		return NTC1_UARTCLK;
-
-	cmp = dmi_get_system_info(DMI_BOARD_NAME);
-	if (cmp && strstr(cmp, "MinnowBoard"))
-		return MINNOW_UARTCLK;
+	d = dmi_first_match(pch_uart_dmi_table);
+	if (d)
+		return (int)d->driver_data;
 
 	return DEFAULT_UARTCLK;
 }
-- 
1.8.1.2



-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

