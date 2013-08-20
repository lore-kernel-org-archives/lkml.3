Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3HTTfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:35:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40690 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3HTTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:35:13 -0400
Date: Tue, 20 Aug 2013 15:35:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it
 also work on HVM guests.
Message-ID: <20130820193507.GI12037@phenom.dumpdata.com>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
 <1376425904.9273.25.camel@hastur.hellion.org.uk>
 <20130813205332.GA10243@phenom.dumpdata.com>
 <1376427570.9273.39.camel@hastur.hellion.org.uk>
 <1376432405.9273.54.camel@hastur.hellion.org.uk>
 <20130814001050.GA10492@phenom.dumpdata.com>
 <1376464556.9273.75.camel@hastur.hellion.org.uk>
 <20130814124647.GD10764@phenom.dumpdata.com>
 <1376577638.9273.188.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376577638.9273.188.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 03:40:38PM +0100, Ian Campbell wrote:
> On Wed, 2013-08-14 at 08:46 -0400, Konrad Rzeszutek Wilk wrote:
> > On Wed, Aug 14, 2013 at 08:15:56AM +0100, Ian Campbell wrote:
> > > On Tue, 2013-08-13 at 20:10 -0400, Konrad Rzeszutek Wilk wrote:
> > > > On Tue, Aug 13, 2013 at 11:20:05PM +0100, Ian Campbell wrote:
> > > > > On Tue, 2013-08-13 at 21:59 +0100, Ian Campbell wrote:
> > > > > 
> > > > > > > What it should be is:
> > > > > > > > >  
> > > > > > > > >  void xen_raw_console_write(const char *str)
> > > > > > > > >  {
> > > > > > > > > -	dom0_write_console(0, str, strlen(str));
> > > > > > > > > +	if (!xen_domain())
> > > > > > > > > +		return;
> > > > > > > > > +
> > > > > > > > > +	if (xen_pv_domain())
> > > > > > >             xen_domain()
> > > > > > > 
> > > > > > > > > +		dom0_write_console(0, str, strlen(str));
> > > > > > > > > +	else if (xen_hvm_domain() || xen_cpuid_base()) {
> > > > > > >      
> > > > > > > 	else if (xen_cpuid_base()) {
> > > > > > > 
> > > > > > > > > +		/* The hyperpage has not been setup yet. */
> > > > > > > > > +		int i, len = strlen(str);
> > > > > > > > > +		for (i = 0; i < len; i++)
> > > > > > > > > +			 outb(str[i], 0xe9);
> > > > > > > > > +	}
> > > > > > > > >  }
> > > > > > > 
> > > > > > > And then that should adhere to what I wrote up.
> > > > > > 
> > > > > > I think it does too.
> > > > > 
> > > > > Except as Daniel notes in <520A7145.5010306@tycho.nsa.gov> for unrelated
> > > > > reasons:
> > > > > 
> > > > > >         HVM guests can still use the PV output - they just need to use the console
> > > > > >         write hypercall instead of the HVM I/O port. I would think that PVH guests
> > > > > >         would default to using the hypercall as it is more efficient (it takes a
> > > > > >         string rather than one character per write).
> > > > > >         
> > > > > >         Actually, checking... the console_io hypercall would need to be added to
> > > > > >         the hvm_hypercall{32,64}_table for an HVM guest to be able to use it; they
> > > > > >         currently must use the I/O port. I didn't check the PVH patches.
> > > > > 
> > > > > Or did you actually try this code and it worked?
> > > > 
> > > > The one I typed up above - no. The one I had sent - yes.
> > > > 
> > > > But with that above mentioned comment from Daniel I think it is still
> > > > worth trying to do dom0_write_console and if the hypercall returns -ENOSYS 
> > > > then fall back on 0xe9.
> > > > 
> > > > And lastly send an patch to make hypercall_io work under HVM.
> > > 
> > > So you didn't try under PVHVM? That's what I was asking when I asked if
> > > you tried it, since that is the point of this patch.
> > 
> > Not the one I typed up above. Just the one I sent.
> 
> And did it work? ecause if the console_io hypercall isn't wired up in
> the hypervisor I can't see how it can have done...
> 
> Oh the original patch would buggily never have tried to use console_io,
> and you probably didn't notice the lack of output after the hypercall
> page was setup.
<nods>

This is a patch below that works for me and also it work with hypervisors
that don't have console_io wired in. 

Pls treat it as RFC

>From 5b5faae0038d48aa0169bab8c78d1b47c4f1ac64 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 16 Aug 2013 15:32:07 -0400
Subject: [PATCH] xen/hvc: Print out to the serial console and pv console
 irregardless if it is dom0, PV or HVM.

*TODO*: BLA BLA BLA

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 682210d..e47c6ae 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -40,6 +40,7 @@
 #include <xen/hvc-console.h>
 #include <xen/xenbus.h>
 
+#include <asm/xen/hypervisor.h>
 #include "hvc_console.h"
 
 #define HVC_COOKIE   0x58656e /* "Xen" in hex */
@@ -641,7 +642,19 @@ struct console xenboot_console = {
 
 void xen_raw_console_write(const char *str)
 {
-	dom0_write_console(0, str, strlen(str));
+	ssize_t len = strlen(str);
+	int rc = 0;
+
+	if (xen_domain()) {
+		rc = dom0_write_console(0, str, len);
+		if (rc != len && xen_hvm_domain()) /* -ENOSYS */
+			goto outb_print;
+	} else if (xen_cpuid_base()) {
+		int i;
+outb_print:
+		for (i = 0; i < len; i++)
+			outb(str[i], 0xe9);
+	}
 }
 
 void xen_raw_printk(const char *fmt, ...)
-- 
1.7.7.6

> Ian.
> 
