Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3F2Wyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 18:54:32 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63512 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3F2Wy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 18:54:29 -0400
Date: Sat, 29 Jun 2013 15:54:26 -0700
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130629225426.GA12221@quad.lixom.net>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
 <20130628200333.GA2756@lukather>
 <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
 <20130629193819.GD3353@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629193819.GD3353@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 08:38:19PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jun 28, 2013 at 01:05:42PM -0700, Olof Johansson wrote:
> > On Fri, Jun 28, 2013 at 1:03 PM, Maxime Ripard
> > <maxime.ripard@free-electrons.com> wrote:
> > > On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> > >> The patch above should already be queued in next/dt right ?
> > >
> > > Indeed.
> > >
> > > Then why the latest patch of your patchset got in 3.10, while the
> > > patches actually fixing the DT it would have impacted were delayed to
> > > 3.11?
> > >
> > > (And why was it merged so late in the development cycle?)
> > 
> > This. So now we have to scramble because some device trees will
> > produce warnings at boot.
> > 
> > Russell, the alternative is to revert Lorenzo's patch for 3.10 (and
> > re-introduce it for 3.11). Do you have a preference?
> 
> Sorry but I really don't understand what all the fuss in this thread
> is about.
> 
> This thread seems to be saying that two development patches were
> merged, which were 7762/1 and 7763/1, and that 7764/1 is a fix?
> Are you sure about that, because that's not how they're described,
> and not how they look either.

Most of this ruffle seems to be about the fact that booting a kernel
with a device tree that doesn't conform to the brand spanking new,
and never previously enforced, binding for the cpu nodes will produce
a WARN_ON(). Lots of our in-tree device trees fall into this category.

And while I think it was a bad idea for Lorenzo to ask for this to be
merged as a fix this late (and most in particular for stable), as far
as I can tell nothing (new) is broken by it -- just the alarming warning
is being printed.

I think it probably makes sense to downgrade the WARN to just a printk, and
people will be a lot less worried. How about the below?

If you're OK with it, Russell, can we get your ack so Linus can apply
directly given the imminence of final 3.10? Or, if you prefer, you can of
course apply and send it on instead.


Thanks,

-Olof


-----

ARM: dt: Only print warning, not WARN() on bad cpu map in device tree

Due to recent changes and expecations of proper cpu bindings, there are now
cases for many of the in-tree devicetrees where a WARN() will hit on boot due
to badly formatted /cpus nodes.

Downgrade this to a pr_warn() to be less alarmist, since it's not a new
problem.

Tested on Arndale, Cubox, Seaboard and Panda ES. Panda hits the WARN
without this, the others do not.

Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 0905502..707f99e 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -152,9 +152,11 @@ void __init arm_dt_init_cpu_maps(void)
 		tmp_map[i] = hwid;
 	}
 
-	if (WARN(!bootcpu_valid, "DT missing boot CPU MPIDR[23:0], "
-				 "fall back to default cpu_logical_map\n"))
+	if (!bootcpu_valid) {
+		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to "
+			"default cpu_logical_map\n");
 		return;
+	}
 
 	/*
 	 * Since the boot CPU node contains proper data, and all nodes have
