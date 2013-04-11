Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935534Ab3DKVRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:17:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934464Ab3DKVRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:17:36 -0400
Date: Thu, 11 Apr 2013 14:17:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] clear_refs: Sanitize accepted commands declaration
Message-Id: <20130411141735.107e583ca55e619f2e215851@linux-foundation.org>
In-Reply-To: <51669E73.2000301@parallels.com>
References: <51669E5F.4000801@parallels.com>
	<51669E73.2000301@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013 15:28:51 +0400 Pavel Emelyanov <xemul@parallels.com> wrote:

> A new clear-refs type will be added in the next patch, so prepare
> code for that.
> 
> @@ -730,7 +733,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  	char buffer[PROC_NUMBUF];
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -	int type;
> +	enum clear_refs_types type;
>  	int rv;
>  
>  	memset(buffer, 0, sizeof(buffer));
> @@ -738,10 +741,10 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  		count = sizeof(buffer) - 1;
>  	if (copy_from_user(buffer, buf, count))
>  		return -EFAULT;
> -	rv = kstrtoint(strstrip(buffer), 10, &type);
> +	rv = kstrtoint(strstrip(buffer), 10, (int *)&type);

This is naughty.  The compiler is allowed to put the enum into storage
which is smaller (or, I guess, larger) than sizeof(int).  I've seen one
compiler which puts such an enum into a 16-bit word.

--- a/fs/proc/task_mmu.c~clear_refs-sanitize-accepted-commands-declaration-fix
+++ a/fs/proc/task_mmu.c
@@ -734,6 +734,7 @@ static ssize_t clear_refs_write(struct f
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	enum clear_refs_types type;
+	int itype;
 	int rv;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -741,9 +742,10 @@ static ssize_t clear_refs_write(struct f
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	rv = kstrtoint(strstrip(buffer), 10, (int *)&type);
+	rv = kstrtoint(strstrip(buffer), 10, &itype);
 	if (rv < 0)
 		return rv;
+	type = (enum clear_refs_types)itype;
 	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
 	task = get_proc_task(file_inode(file));
_

