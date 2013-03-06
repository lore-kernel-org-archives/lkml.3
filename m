Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3CFN5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:57:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39828 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab3CFN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:57:05 -0500
Date: Wed, 6 Mar 2013 08:56:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20130306135654.GA10760@phenom.dumpdata.com>
References: <20130306113508.9c868be103b6b140295c548f@canb.auug.org.au>
 <20130306004341.GA28426@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306004341.GA28426@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 08:43:41AM +0800, Greg KH wrote:
> On Wed, Mar 06, 2013 at 11:35:08AM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > In file included from drivers/staging/zcache/debug.c:2:0:
> > drivers/staging/zcache/debug.h: In function 'dec_zcache_obj_count':
> > drivers/staging/zcache/debug.h:16:2: error: implicit declaration of function 'BUG_ON' [-Werror=implicit-function-declaration]
> > 
> > Caused by commit 95bdaee2140e ("zcache: Move debugfs code out of
> > zcache-main.c file").
> > 
> > I applied this patch for today:
> > 
> > From 24b03cf426007c4e94c6bed81560e436afcc136c Mon Sep 17 00:00:00 2001
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Wed, 6 Mar 2013 11:31:06 +1100
> > Subject: [PATCH] disable ZCACHE_DEBUG due to build error
> > 
> > In file included from drivers/staging/zcache/debug.c:2:0:
> > drivers/staging/zcache/debug.h: In function 'dec_zcache_obj_count':
> > drivers/staging/zcache/debug.h:16:2: error: implicit declaration of function 'BUG_ON' [-Werror=implicit-function-declaration]
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/staging/zcache/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Ick, sorry about that, I've applied your patch to my tree.

Wait, there is no BUG_ON on PPC? Or is the definition for it hidden in layers
of #include files? Would this also solve it:


diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/debug.h
index eef67db..494cea02 100644
--- a/drivers/staging/zcache/debug.h
+++ b/drivers/staging/zcache/debug.h
@@ -1,5 +1,7 @@
 #ifdef CONFIG_ZCACHE_DEBUG
 
+#include <asm/bug.h>
+
 /* we try to keep these statistics SMP-consistent */
 static ssize_t zcache_obj_count;
 static atomic_t zcache_obj_atomic = ATOMIC_INIT(0);


? (going to get my PPC compiler ready shortly to check this out).

> 
> thanks,
> 
> greg k-h
