Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaABECr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 23:02:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:20759 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaABECp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 23:02:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,588,1384329600"; 
   d="scan'208";a="432823635"
Message-ID: <1388635350.3739.79.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/1] thermal: fix cpu_cooling max_level behavior
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Jan 2014 12:02:30 +0800
In-Reply-To: <52A1D697.5030601@ti.com>
References: <1384366269-1655-1-git-send-email-eduardo.valentin@ti.com>
	 <52A1D697.5030601@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 09:52 -0400, Eduardo Valentin wrote:
> On 13-11-2013 14:11, Eduardo Valentin wrote:
> > As per Documentation/thermal/sysfs-api.txt, max_level
> > is an index, not a counter. Thus, in case a CPU has
> > 3 valid frequencies, max_level is expected to be 2, for instance.
> > 
> > The current code makes max_level == number of valid frequencies,
> > which is bogus. This patch fix the cpu_cooling device by
> > ranging max_level properly.
> > 
good catch.
> > Reported-by: Carlos Hernandez <ceh@ti.com>
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> 
> Rui,
> 
> Can you please consider pushing this fix?
> 
applied.

> > ---
> >  drivers/thermal/cpu_cooling.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> > index d179028..d0f8f8b5 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -173,6 +173,8 @@ static int get_property(unsigned int cpu, unsigned long input,
> >  		freq = table[i].frequency;
> >  		max_level++;
> >  	}
> > +	/* max_level is an index, not a counter */
> > +	max_level--;
> >
I think we should check the max_level first, like the patch I attached
below.

thanks,
rui

>From a116776f7b6052599df0c67db29c30ea9d69d7ee Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 2 Jan 2014 11:57:48 +0800
Subject: [PATCH] Thermal cpu cooling: return error if no valid cpu frequency
 entry

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/cpu_cooling.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index cc556a8..bb486b4 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -173,6 +173,11 @@ static int get_property(unsigned int cpu, unsigned long input,
 		freq = table[i].frequency;
 		max_level++;
 	}
+
+	/* No valid cpu frequency entry */
+	if (max_level == 0)
+		return -EINVAL;
+
 	/* max_level is an index, not a counter */
 	max_level--;
 
-- 
1.7.9.5



