Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaCKTxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:53:09 -0400
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:50365 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755166AbaCKTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:53:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:599:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1981:2194:2196:2198:2199:2200:2201:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3873:4250:4321:4385:5007:6119:7652:9592:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12296:12438:12517:12519:12555:12683:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rings65_54a0b7fe1d417
X-Filterd-Recvd-Size: 4604
Message-ID: <1394567580.20021.11.camel@joe-AO722>
Subject: Re: [PATCH 1/1] BEFS: Global conversion to pr_foo()
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 11 Mar 2014 12:53:00 -0700
In-Reply-To: <20140311204325.59e6a3a26fc38b2184a06315@skynet.be>
References: <20140311204325.59e6a3a26fc38b2184a06315@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 20:43 +0100, Fabian Frederick wrote:
> -All printk(KERN_foo converted to pr_foo().
> -Add pr_fmt and remove redundant prefixes.
[]
> diff --git a/fs/befs/debug.c b/fs/befs/debug.c

> @@ -31,7 +32,7 @@ befs_error(const struct super_block *sb, const char *fmt, ...)
>  	va_list args;
>  	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
>  	if (err_buf == NULL) {
> -		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
> +		pr_err("could not allocate %d bytes\n", ERRBUFSIZE);

You could also get rid of these OOM messages as
there's a generic one for all .alloc failures.

> @@ -39,7 +40,7 @@ befs_error(const struct super_block *sb, const char *fmt, ...)
>  	vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
>  	va_end(args);
>  
> -	printk(KERN_ERR "BeFS(%s): %s\n", sb->s_id, err_buf);
> +	pr_err("(%s): %s\n", sb->s_id, err_buf);

Maybe use %pV too and get rid of the alloc/free
altogether like this uncompiled/untested patch below:

---

 fs/befs/befs.h  |  3 +++
 fs/befs/debug.c | 54 +++++++++++++++++++-----------------------------------
 2 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/fs/befs/befs.h b/fs/befs/befs.h
index b266428..3a7813a 100644
--- a/fs/befs/befs.h
+++ b/fs/befs/befs.h
@@ -88,8 +88,11 @@ enum befs_err {
 
 /****************************/
 /* debug.c */
+__printf(2, 3)
 void befs_error(const struct super_block *sb, const char *fmt, ...);
+__printf(2, 3)
 void befs_warning(const struct super_block *sb, const char *fmt, ...);
+__printf(2, 3)
 void befs_debug(const struct super_block *sb, const char *fmt, ...);
 
 void befs_dump_super_block(const struct super_block *sb, befs_super_block *);
diff --git a/fs/befs/debug.c b/fs/befs/debug.c
index 622e737..a8f8d7f 100644
--- a/fs/befs/debug.c
+++ b/fs/befs/debug.c
@@ -23,43 +23,36 @@
 
 #include "befs.h"
 
-#define ERRBUFSIZE 1024
-
 void
 befs_error(const struct super_block *sb, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
-	if (err_buf == NULL) {
-		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
-		return;
-	}
 
 	va_start(args, fmt);
-	vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
-	va_end(args);
 
-	printk(KERN_ERR "BeFS(%s): %s\n", sb->s_id, err_buf);
-	kfree(err_buf);
+	vaf.fmt = fmt;
+	vaf.args = &args;
+
+	pr_err("(%s): %pV\n", sb->s_id, &vaf);
+
+	va_end(args);
 }
 
 void
 befs_warning(const struct super_block *sb, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
-	if (err_buf == NULL) {
-		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
-		return;
-	}
 
 	va_start(args, fmt);
-	vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
-	va_end(args);
 
-	printk(KERN_WARNING "BeFS(%s): %s\n", sb->s_id, err_buf);
+	vaf.fmt = fmt;
+	vaf.args = &args;
+
+	pr_warn("(%s): %pV\n", sb->s_id, &vaf);
 
-	kfree(err_buf);
+	va_end(args);
 }
 
 void
@@ -67,26 +60,17 @@ befs_debug(const struct super_block *sb, const char *fmt, ...)
 {
 #ifdef CONFIG_BEFS_DEBUG
 
+	struct va_format vaf;
 	va_list args;
-	char *err_buf = NULL;
-
-	if (BEFS_SB(sb)->mount_opts.debug) {
-		err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
-		if (err_buf == NULL) {
-			printk(KERN_ERR "could not allocate %d bytes\n",
-				ERRBUFSIZE);
-			return;
-		}
 
-		va_start(args, fmt);
-		vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
-		va_end(args);
+	va_start(args, fmt);
 
-		printk(KERN_DEBUG "BeFS(%s): %s\n", sb->s_id, err_buf);
+	vaf.fmt = fmt;
+	vaf.args = &args;
 
-		kfree(err_buf);
-	}
+	pr_debug("(%s): %pV\n", sb->s_id, &vaf);
 
+	va_end(args);
 #endif				//CONFIG_BEFS_DEBUG
 }
 


