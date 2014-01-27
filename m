Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaA0VuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:50:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaA0VuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:50:01 -0500
Date: Mon, 27 Jan 2014 13:49:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: xypron.glpk@gmx.de
Cc: gxt@mprc.pku.edu.cn, paul.gortmaker@windriver.com, vapier@gentoo.org,
        totglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] __init setup_early_printk: missing initialization
Message-Id: <20140127134959.72c65d0091554e36d1755ab0@linux-foundation.org>
In-Reply-To: <1390846224-6995-1-git-send-email-xypron.glpk@gmx.de>
References: <1390846224-6995-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 19:10:24 +0100 xypron.glpk@gmx.de wrote:

> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> If is based on uninitialized value keep_early.
> This leads to unpredictable result.
> 
> ...
>
> --- a/arch/unicore32/kernel/early_printk.c
> +++ b/arch/unicore32/kernel/early_printk.c
> @@ -35,7 +35,7 @@ static struct console early_ocd_console = {
>  
>  static int __init setup_early_printk(char *buf)
>  {
> -	int keep_early;
> +	int keep_early = 0;
>  
>  	if (!buf || early_console)
>  		return 0;

yup.

But that code is quite overcooked.  How about this?

--- a/arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix
+++ a/arch/unicore32/kernel/early_printk.c
@@ -35,17 +35,11 @@ static struct console early_ocd_console
 
 static int __init setup_early_printk(char *buf)
 {
-	int keep_early = 0;
-
 	if (!buf || early_console)
 		return 0;
 
-	if (strstr(buf, "keep"))
-		keep_early = 1;
-
 	early_console = &early_ocd_console;
-
-	if (keep_early)
+	if (strstr(buf, "keep"))
 		early_console->flags &= ~CON_BOOT;
 	else
 		early_console->flags |= CON_BOOT;
_

