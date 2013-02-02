Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3BBAYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:24:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3BBAYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:24:01 -0500
Date: Fri, 1 Feb 2013 16:23:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>
Subject: Re: [PATCH 5/9] mmzone: add pgdat_{end_pfn,is_empty}() helpers &
 consolidate.
Message-Id: <20130201162359.ddb66f62.akpm@linux-foundation.org>
In-Reply-To: <1358463181-17956-6-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
	<1358463181-17956-6-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013 14:52:57 -0800
Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> From: Cody P Schafer <jmesmon@gmail.com>
> 
> Add pgdat_end_pfn() and pgdat_is_empty() helpers which match the similar
> zone_*() functions.
> 
> Change node_end_pfn() to be a wrapper of pgdat_end_pfn().
> 
> ...
>
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -772,11 +772,17 @@ typedef struct pglist_data {
>  #define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
>  
>  #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
> +#define node_end_pfn(nid) pgdat_end_pfn(NODE_DATA(nid))

I wonder if these could be implemented in nice C code rather than nasty
cpp code.

> -#define node_end_pfn(nid) ({\
> -	pg_data_t *__pgdat = NODE_DATA(nid);\
> -	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;\
> -})
> +static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
> +{
> +	return pgdat->node_start_pfn + pgdat->node_spanned_pages;
> +}

It wouldn't hurt to add a little comment pointing out that this returns
"end pfn plus one", or similar.  ie, it is exclusive, not inclusive. 
Ditto the "zone_*() functions", if needed.

> +static inline bool pgdat_is_empty(pg_data_t *pgdat)
> +{
> +	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
> +}

