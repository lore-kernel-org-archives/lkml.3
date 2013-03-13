Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3CMQm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:42:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22736 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3CMQm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:42:56 -0400
MIME-Version: 1.0
Message-ID: <634487ea-fbbd-4eb9-9a18-9206edc4e0d2@default>
Date: Wed, 13 Mar 2013 09:42:16 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH 4/4] zcache: add pageframes count once compress
 zero-filled pages twice
References: <<1363158321-20790-1-git-send-email-liwanp@linux.vnet.ibm.com>>
 <<1363158321-20790-5-git-send-email-liwanp@linux.vnet.ibm.com>>
In-Reply-To: <<1363158321-20790-5-git-send-email-liwanp@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> Sent: Wednesday, March 13, 2013 1:05 AM
> To: Andrew Morton
> Cc: Greg Kroah-Hartman; Dan Magenheimer; Seth Jennings; Konrad Rzeszutek Wilk; Minchan Kim; linux-
> mm@kvack.org; linux-kernel@vger.kernel.org; Wanpeng Li
> Subject: [PATCH 4/4] zcache: add pageframes count once compress zero-filled pages twice

Hi Wanpeng --

Thanks for taking on this task from the drivers/staging/zcache TODO list!

> Since zbudpage consist of two zpages, two zero-filled pages compression
> contribute to one [eph|pers]pageframe count accumulated.

I'm not sure why this is necessary.  The [eph|pers]pageframe count
is supposed to be counting actual pageframes used by zcache.  Since
your patch eliminates the need to store zero pages, no pageframes
are needed at all to store zero pages, so it's not necessary
to increment zcache_[eph|pers]_pageframes when storing zero
pages.

Or am I misunderstanding your intent?

Thanks,
Dan
 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c |   25 +++++++++++++++++++++++--
>  1 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index dd52975..7860ff0 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -544,6 +544,8 @@ static struct page *zcache_evict_eph_pageframe(void);
>  static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
>  					struct tmem_handle *th)
>  {
> +	static ssize_t second_eph_zero_page;
> +	static atomic_t second_eph_zero_page_atomic = ATOMIC_INIT(0);
>  	void *pampd = NULL, *cdata = data;
>  	unsigned clen = size;
>  	bool zero_filled = false;
> @@ -561,7 +563,14 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
>  		clen = 0;
>  		zero_filled = true;
>  		zcache_pages_zero++;
> -		goto got_pampd;
> +		second_eph_zero_page = atomic_inc_return(
> +				&second_eph_zero_page_atomic);
> +		if (second_eph_zero_page % 2 == 1)
> +			goto got_pampd;
> +		else {
> +			atomic_sub(2, &second_eph_zero_page_atomic);
> +			goto count_zero_page;
> +		}
>  	}
>  	kunmap_atomic(user_mem);
> 
> @@ -597,6 +606,7 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
>  create_in_new_page:
>  	pampd = (void *)zbud_create_prep(th, true, cdata, clen, newpage);
>  	BUG_ON(pampd == NULL);
> +count_zero_page:
>  	zcache_eph_pageframes =
>  		atomic_inc_return(&zcache_eph_pageframes_atomic);
>  	if (zcache_eph_pageframes > zcache_eph_pageframes_max)
> @@ -621,6 +631,8 @@ out:
>  static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
>  					struct tmem_handle *th)
>  {
> +	static ssize_t second_pers_zero_page;
> +	static atomic_t second_pers_zero_page_atomic = ATOMIC_INIT(0);
>  	void *pampd = NULL, *cdata = data;
>  	unsigned clen = size, zero_filled = 0;
>  	struct page *page = (struct page *)(data), *newpage;
> @@ -644,7 +656,15 @@ static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
>  		clen = 0;
>  		zero_filled = 1;
>  		zcache_pages_zero++;
> -		goto got_pampd;
> +		second_pers_zero_page = atomic_inc_return(
> +				&second_pers_zero_page_atomic);
> +		if (second_pers_zero_page % 2 == 1)
> +			goto got_pampd;
> +		else {
> +			atomic_sub(2, &second_pers_zero_page_atomic);
> +			goto count_zero_page;
> +		}
> +
>  	}
>  	kunmap_atomic(user_mem);
> 
> @@ -698,6 +718,7 @@ create_pampd:
>  create_in_new_page:
>  	pampd = (void *)zbud_create_prep(th, false, cdata, clen, newpage);
>  	BUG_ON(pampd == NULL);
> +count_zero_page:
>  	zcache_pers_pageframes =
>  		atomic_inc_return(&zcache_pers_pageframes_atomic);
>  	if (zcache_pers_pageframes > zcache_pers_pageframes_max)
> --
> 1.7.7.6
