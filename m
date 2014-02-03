Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaBCUnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:43:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39535 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaBCUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:43:53 -0500
Date: Mon, 3 Feb 2014 15:43:46 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, roger.pau@citrix.com,
        Xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pvh: set cr4 flags for APs
Message-ID: <20140203204346.GA12728@phenom.dumpdata.com>
References: <1391040918-11722-1-git-send-email-mukesh.rathor@oracle.com>
 <1391040918-11722-2-git-send-email-mukesh.rathor@oracle.com>
 <20140203114914.GA3350@phenom.dumpdata.com>
 <20140203113001.2433a77c@mantra.us.oracle.com>
 <20140203195240.GA10738@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203195240.GA10738@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:52:40PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 03, 2014 at 11:30:01AM -0800, Mukesh Rathor wrote:
> > On Mon, 3 Feb 2014 06:49:14 -0500
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > On Wed, Jan 29, 2014 at 04:15:18PM -0800, Mukesh Rathor wrote:
> > > > We need to set cr4 flags for APs that are already set for BSP.
> > > 
> > > The title is missing the 'xen' part.
> > 
> > The patch is for linux, not xen.
> 
> Right. And hence you need to prefix the title with 'xen' in it
> otherwise it won't be obvious from the Linux log line for what
> component of the Linux tree it is.
> 
> > 
> > > I rewrote it a bit and I think this should go in 3.14.
> > > 
> > > David, Boris: It is not the full fix as there are other parts to
> > > make an PVH guest use 2MB or 1GB pages- but this fixes an obvious
> > > bug.
> > > 
> > > 
> > > 
> > > From 797ea6812ff0a90cce966a4ff6bad57cbadc43b5 Mon Sep 17 00:00:00 2001
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > Date: Wed, 29 Jan 2014 16:15:18 -0800
> > > Subject: [PATCH] xen/pvh: set CR4 flags for APs
> > > 
> > > The Xen ABI sets said flags for the BSP, but it does
> > 
> > NO it does not. I said it few times, it's set by probe_page_size_mask
> > (which is in linux) for the BSP. The comment below also says it.
> 
> Where does it set it for APs? Can we piggyback on that?

And since I am in a hurry to fix an build regression I did the research
myself - but this kind of information needs to be in the commit message.

Here is what I have, please comment as I want to send a git pull to Linux
within the hour.

>From 125ef07fd58e963cc286554f6536e46c9712033c Mon Sep 17 00:00:00 2001
From: Mukesh Rathor <mukesh.rathor@oracle.com>
Date: Wed, 29 Jan 2014 16:15:18 -0800
Subject: [PATCH] xen/pvh: set CR4 flags for APs

During bootup in the 'probe_page_size_mask' these CR4
flags are set in there. But for AP processors they
are not set as we do not use 'secondary_startup_64' which
the baremetal kernels uses. Instead do it in
this function which we use in Xen PVH during our
startup for AP and BSP processors.

As such fix it up to make sure we have that flag set.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a4d7b64..201d09a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1473,6 +1473,18 @@ static void xen_pvh_set_cr_flags(int cpu)
 	 * X86_CR0_TS, X86_CR0_PE, X86_CR0_ET are set by Xen for HVM guests
 	 * (which PVH shared codepaths), while X86_CR0_PG is for PVH. */
 	write_cr0(read_cr0() | X86_CR0_MP | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM);
+
+	if (!cpu)
+		return;
+	/*
+	 * For BSP, PSE PGE are set in probe_page_size_mask(), for APs
+	 * set them here. For all, OSFXSR OSXMMEXCPT are set in fpu_init.
+	*/
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	if (cpu_has_pge)
+		set_in_cr4(X86_CR4_PGE);
 }
 
 /*
-- 
1.8.3.1

