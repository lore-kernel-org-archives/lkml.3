Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3BHAGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:06:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3BHAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:06:23 -0500
Date: Thu, 7 Feb 2013 16:06:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, benh@kernel.crashing.org,
        mahesh@linux.vnet.ibm.com, zhangyanfei@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/proc/vmcore.c: Put if tests in the top of the while
 loop to reduce duplication
Message-Id: <20130207160620.6c8f93d4.akpm@linux-foundation.org>
In-Reply-To: <510E6280.3070203@gmail.com>
References: <510E6280.3070203@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Feb 2013 21:13:36 +0800
Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> In function read_vmcore, two if tests are duplicate. Change the position
> of them could reduce the duplication. This change does not affect
> the behaviour of the function.
> 

hm, yes.

> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -175,15 +175,16 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  	start = map_offset_to_paddr(*fpos, &vmcore_list, &curr_m);
>  	if (!curr_m)
>          	return -EINVAL;
> -	if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
> -		tsz = buflen;
> -
> -	/* Calculate left bytes in current memory segment. */
> -	nr_bytes = (curr_m->size - (start - curr_m->paddr));
> -	if (tsz > nr_bytes)
> -		tsz = nr_bytes;
>  
>  	while (buflen) {
> +		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
> +			tsz = buflen;
> +
> +		/* Calculate left bytes in current memory segment. */
> +		nr_bytes = (curr_m->size - (start - curr_m->paddr));
> +		if (tsz > nr_bytes)
> +			tsz = nr_bytes;
> +
>  		tmp = read_from_oldmem(buffer, tsz, &start, 1);
>  		if (tmp < 0)
>  			return tmp;
> @@ -198,12 +199,6 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  						struct vmcore, list);
>  			start = curr_m->paddr;

`start' gets changed here

>  		}
> -		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
> -			tsz = buflen;
> -		/* Calculate left bytes in current memory segment. */
> -		nr_bytes = (curr_m->size - (start - curr_m->paddr));
> -		if (tsz > nr_bytes)
> -			tsz = nr_bytes;

So this code can calcualte a different value of `tsz'.  But that won't
get used.  Looks right to me.

>  	}
>  	return acc;
>  }

While we're there, let's squish that assignment-in-a-if pestilence and
use max_t().

--- a/fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix
+++ a/fs/proc/vmcore.c
@@ -178,8 +178,7 @@ static ssize_t read_vmcore(struct file *
         	return -EINVAL;
 
 	while (buflen) {
-		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
-			tsz = buflen;
+		tsz = max_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
 
 		/* Calculate left bytes in current memory segment. */
 		nr_bytes = (curr_m->size - (start - curr_m->paddr));
_

