Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3IRFZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 01:25:48 -0400
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:43207 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751738Ab3IRFZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 01:25:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3868:3871:4321:4605:5007:7652:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12555:12740:13019,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coat60_8760d23e34c13
X-Filterd-Recvd-Size: 3697
Message-ID: <1379481928.1787.5.camel@joe-AO722>
Subject: Re: [PATCH 2/2] x86: Useless inode var and Coding style fixes
From: Joe Perches <joe@perches.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Sep 2013 22:25:28 -0700
In-Reply-To: <1379472857-6473-2-git-send-email-geyslan@gmail.com>
References: <1379472857-6473-1-git-send-email-geyslan@gmail.com>
	 <1379472857-6473-2-git-send-email-geyslan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 23:54 -0300, Geyslan G. Bem wrote:
> Coding style and printk strings fixes.
[]
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
[]
> @@ -299,12 +301,12 @@ static int load_aout_binary(struct linux_binprm * bprm)
>  
>  		if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
>  		{
> -			printk(KERN_WARNING 
> +			printk(KERN_WARNING
>  			       "fd_offset is not page aligned. Please convert program: %s\n",
>  			       bprm->file->f_path.dentry->d_name.name);
[]
> @@ -388,12 +388,12 @@ static int load_aout_library(struct file *file)
>  	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
>  		if (printk_ratelimit())
>  		{
> -			printk(KERN_WARNING 
> +			printk(KERN_WARNING
>  			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
>  			       file->f_path.dentry->d_name.name);

I'd rather see these printks were fixed like this:
---
 fs/binfmt_aout.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 89dec7f..3c9ec06 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/coredump.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -292,17 +293,12 @@ static int load_aout_binary(struct linux_binprm * bprm)
 		}
 	} else {
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) && printk_ratelimit())
-		{
-			printk(KERN_NOTICE "executable not page aligned\n");
-		}
+		    (N_MAGIC(ex) != NMAGIC))
+			pr_notice_ratelimited("executable not page aligned\n");
 
-		if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
-		{
-			printk(KERN_WARNING 
-			       "fd_offset is not page aligned. Please convert program: %s\n",
-			       bprm->file->f_path.dentry->d_name.name);
-		}
+		if ((fd_offset & ~PAGE_MASK) != 0)
+			pr_warn_ratelimited("fd_offset is not page aligned. Please convert program: %s\n",
+					    bprm->file->f_path.dentry->d_name.name);
 
 		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
 			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
@@ -386,12 +382,8 @@ static int load_aout_library(struct file *file)
 	start_addr =  ex.a_entry & 0xfffff000;
 
 	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
-		if (printk_ratelimit())
-		{
-			printk(KERN_WARNING 
-			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
-			       file->f_path.dentry->d_name.name);
-		}
+		pr_warn_ratelimited("N_TXTOFF is not page aligned. Please convert library: %s\n",
+				    file->f_path.dentry->d_name.name);
 		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
 		
 		read_code(file, start_addr, N_TXTOFF(ex),



