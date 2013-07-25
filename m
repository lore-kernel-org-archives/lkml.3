Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3GYRa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:30:29 -0400
Received: from www.sr71.net ([198.145.64.142]:35798 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab3GYRaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:30:25 -0400
Message-ID: <51F160A5.2040004@sr71.net>
Date: Thu, 25 Jul 2013 10:30:13 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Robert Jennings <rcj@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/2] vmsplice unmap gifted pages for recipient
References: <1374772906-21511-1-git-send-email-rcj@linux.vnet.ibm.com> <1374772906-21511-2-git-send-email-rcj@linux.vnet.ibm.com>
In-Reply-To: <1374772906-21511-2-git-send-email-rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 10:21 AM, Robert Jennings wrote:
> +static void zap_buf_page(unsigned long useraddr)
> +{
> +	struct vm_area_struct *vma;
> +
> +	down_read(&current->mm->mmap_sem);
> +	vma = find_vma_intersection(current->mm, useraddr,
> +			useraddr + PAGE_SIZE);
> +	if (!IS_ERR_OR_NULL(vma))
> +		zap_page_range(vma, useraddr, PAGE_SIZE, NULL);
> +	up_read(&current->mm->mmap_sem);
> +}
> +
>  /**
>   * splice_to_pipe - fill passed data into a pipe
>   * @pipe:	pipe to fill
> @@ -212,8 +224,16 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
>  			buf->len = spd->partial[page_nr].len;
>  			buf->private = spd->partial[page_nr].private;
>  			buf->ops = spd->ops;
> -			if (spd->flags & SPLICE_F_GIFT)
> +			if (spd->flags & SPLICE_F_GIFT) {
> +				unsigned long useraddr =
> +						spd->partial[page_nr].useraddr;
> +
> +				if ((spd->flags & SPLICE_F_MOVE) &&
> +				    !buf->offset && (buf->len == PAGE_SIZE))
> +					/* Can move page aligned buf */
> +					zap_buf_page(useraddr);
>  				buf->flags |= PIPE_BUF_FLAG_GIFT;
> +			}

There isn't quite enough context here, but is it going to do this
zap_buf_page() very often?  Seems a bit wasteful to do the up/down and
find_vma() every trip through the loop.
