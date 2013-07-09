Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3GIQT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:19:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59087 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752474Ab3GIQTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:19:55 -0400
Message-ID: <1373386794.14604.14.camel@joe-AO722>
Subject: Re: [PATCH 2/3] firmware/dmi_scan: Fix most checkpatch errors and
 warnings
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 09 Jul 2013 09:19:54 -0700
In-Reply-To: <1373384574.4391.9.camel@chaos.site>
References: <1373384438.4391.6.camel@chaos.site>
	 <1373384574.4391.9.camel@chaos.site>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 17:42 +0200, Jean Delvare wrote:
> Fix all errors and trivial warnings reported by checkpatch for file
> drivers/firmware/dmi_scan.c.

trivia:

> +++ linux-3.11-rc0/drivers/firmware/dmi_scan.c	2013-07-09 16:08:13.979592957 +0200
> @@ -63,7 +63,7 @@ static char * __init dmi_string(const st
>  	if (str != NULL)
>  		strcpy(str, bp);
>  	else
> -		printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
> +		pr_err("dmi_string: cannot allocate %Zu bytes.\n", len);

If the function name is used in every printk, it might
be better to add

#define pr_fmt(fmt) "%s: " fmt, __func__

before any #include

If not, then I suggest removing the embedded function names
and writing these as
		pr_err("%s: etc...", __func__, etc...);

This eliminates any possible function name mismatch.

> @@ -217,7 +220,7 @@ static void __init dmi_save_one_device(i
>  
>  	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
>  	if (!dev) {
> -		printk(KERN_ERR "dmi_save_one_device: out of memory.\n");
> +		pr_err("dmi_save_one_device: out of memory.\n");

OOM messages generally aren't useful.

dmi_alloc is either a trivial front-end to kmalloc,
and kmalloc already does a dump_stack() when OOM, or
for x86, dmi_alloc uses extend_brk which BUGs when
unsuccessful.

x86/ia64 do have a slight mismatch in dmi_alloc as
x86 does a memset(0), and ia64 just does kmalloc.


