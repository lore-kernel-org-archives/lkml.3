Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3JHQYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:24:11 -0400
Received: from www.sr71.net ([198.145.64.142]:49130 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab3JHQYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:24:07 -0400
Message-ID: <52543185.3060705@sr71.net>
Date: Tue, 08 Oct 2013 09:23:33 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Robert C Jennings <rcj@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/2] vmsplice: unmap gifted pages for recipient
References: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com> <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com>
In-Reply-To: <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 01:21 PM, Robert C Jennings wrote:
>  		spd.partial[page_nr].offset = loff;
>  		spd.partial[page_nr].len = this_len;
> +		spd.partial[page_nr].useraddr = index << PAGE_CACHE_SHIFT;
>  		len -= this_len;
>  		loff = 0;
>  		spd.nr_pages++;
> @@ -656,6 +702,7 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
>  		this_len = min_t(size_t, vec[i].iov_len, res);
>  		spd.partial[i].offset = 0;
>  		spd.partial[i].len = this_len;
> +		spd.partial[i].useraddr = (unsigned long)vec[i].iov_base;
>  		if (!this_len) {
>  			__free_page(spd.pages[i]);
>  			spd.pages[i] = NULL;
> @@ -1475,6 +1522,8 @@ static int get_iovec_page_array(const struct iovec __user *iov,
>  
>  			partial[buffers].offset = off;
>  			partial[buffers].len = plen;
> +			partial[buffers].useraddr = (unsigned long)base;
> +			base = (void*)((unsigned long)base + PAGE_SIZE);
>  
>  			off = 0;
>  			len -= plen;
> diff --git a/include/linux/splice.h b/include/linux/splice.h
> index 74575cb..56661e3 100644
> --- a/include/linux/splice.h
> +++ b/include/linux/splice.h
> @@ -44,6 +44,7 @@ struct partial_page {
>  	unsigned int offset;
>  	unsigned int len;
>  	unsigned long private;
> +	unsigned long useraddr;
>  };

"useraddr" confuses me.  You make it an 'unsigned long', yet two of the
three assignments are from "void __user *".  The other assignment:

	spd.partial[page_nr].useraddr = index << PAGE_CACHE_SHIFT;

'index' looks to be the offset inside the file, not a user address, so
I'm confused what that is doing.

Could you elaborate a little more on why 'useraddr' is suddenly needed
in these patches?  How is "index << PAGE_CACHE_SHIFT" a virtual address?
 Also, are we losing any of the advantages of sparse checking since
'useraddr' is without the __user annotation?
