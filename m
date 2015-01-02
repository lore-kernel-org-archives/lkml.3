Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbbABVKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:10:21 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:37142 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbbABVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:10:19 -0500
Date: Fri, 2 Jan 2015 21:10:17 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, t-kristo@ti.com, nm@ti.com, nsekhar@ti.com,
        bcousson@baylibre.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        s-anna@ti.com
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
In-Reply-To: <5492F84E.7020706@ti.com>
Message-ID: <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com>
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Suman, lakml

Hi Roger

On Thu, 18 Dec 2014, Roger Quadros wrote:

> Fixing up Paul's email id.
> 
> cheers,
> -roger
> 
> On 18/12/14 17:49, Roger Quadros wrote:
> > There are quite a few hwmods that don't have sysconfig register and so
> > _find_mpu_rt_port(oh) will return NULL thus preventing ready state check
> > on those modules after the module is enabled.

Hmm.  Any IP block that exposes registers that are accessible by the MPU 
should have an MPU register target port, even if there's no SYSCONFIG 
register.  And if an IP block doesn't have registers that are accessible 
from the MPU, then there shouldn't be much point to waiting for the module 
to become ready.

Looks like the real problem is the test for oh->class->sysc before the 
call to _init_mpu_rt_base().  That was introduced by commit 6423d6df1440 
("ARM: OMAP2+: hwmod: check for module address space during init"). It's 
not clear to me why that test was added, since _init_mpu_rt_base() doesn't 
do anything with oh->class->sysc or SYSCONFIG registers.

Could you please test the following patch?
I don't have an AM437x-gp-evm.  


- Paul

---
 arch/arm/mach-omap2/omap_hwmod.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index cbb908dc5cf0..ce6d11f3eda7 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2451,14 +2451,10 @@ static int __init _init(struct omap_hwmod *oh, void *data)
 				oh->name, np->name);
 	}
 
-	if (oh->class->sysc) {
-		r = _init_mpu_rt_base(oh, NULL, index, np);
-		if (r < 0) {
-			WARN(1, "omap_hwmod: %s: doesn't have mpu register target base\n",
-			     oh->name);
-			return 0;
-		}
-	}
+	r = _init_mpu_rt_base(oh, NULL, index, np);
+	if (r < 0)
+		pr_debug("omap_hwmod: %s: doesn't have mpu register target base\n",
+			 oh->name);
 
 	r = _init_clocks(oh, NULL);
 	if (r < 0) {
-- 
2.1.4

