Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3EGXeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:34:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3EGXeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:34:24 -0400
Date: Tue, 7 May 2013 16:34:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] idr: Print a stack dump after ida_remove warning
Message-Id: <20130507163422.7f88f07fc571b49362eb283a@linux-foundation.org>
In-Reply-To: <1367746323.4682.750.camel@chaos.site>
References: <1367746323.4682.750.camel@chaos.site>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 May 2013 11:32:03 +0200 Jean Delvare <jdelvare@suse.de> wrote:

> We print a dump stack after idr_remove warning. This is useful to find
> the faulty piece of code. Let's do the same for ida_remove, as it
> would be equally useful there.
> 
> ...
>
> --- linux-3.10-rc0.orig/lib/idr.c	2013-05-05 10:17:03.086198024 +0200
> +++ linux-3.10-rc0/lib/idr.c	2013-05-05 10:41:11.939134735 +0200
> @@ -1066,6 +1066,7 @@ void ida_remove(struct ida *ida, int id)
>   err:
>  	printk(KERN_WARNING
>  	       "ida_remove called for id=%d which is not allocated.\n", id);
> +	dump_stack();
>  }
>  EXPORT_SYMBOL(ida_remove);

If we're going to do this, we should make that printk a KERN_EMERG or
something, otherwise users might see a stack dump with no explanation
why it occurred.

We can do all that with plain old WARN().  How does this look?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: idr-print-a-stack-dump-after-ida_remove-warning-fix

convert the open-coded printk+dump_stack into WARN()

Cc: Jean Delvare <jdelvare@suse.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning-fix lib/idr.c
--- a/lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning-fix
+++ a/lib/idr.c
@@ -524,9 +524,7 @@ EXPORT_SYMBOL(idr_alloc_cyclic);
 
 static void idr_remove_warning(int id)
 {
-	printk(KERN_WARNING
-		"idr_remove called for id=%d which is not allocated.\n", id);
-	dump_stack();
+	WARN(1, "idr_remove called for id=%d which is not allocated.\n", id);
 }
 
 static void sub_remove(struct idr *idp, int shift, int id)
@@ -1064,9 +1062,7 @@ void ida_remove(struct ida *ida, int id)
 	return;
 
  err:
-	printk(KERN_WARNING
-	       "ida_remove called for id=%d which is not allocated.\n", id);
-	dump_stack();
+	WARN(1, "ida_remove called for id=%d which is not allocated.\n", id);
 }
 EXPORT_SYMBOL(ida_remove);
 
_

