Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaHZHhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:37:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:37773 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbaHZHhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:37:16 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 26 Aug 2014 16:37:30 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, ds2horner@gmail.com
Subject: Re: [PATCH v5 3/4] zram: zram memory size limitation
Message-ID: <20140826073730.GA1975@js1304-P5Q-DELUXE>
References: <1408925156-11733-1-git-send-email-minchan@kernel.org>
 <1408925156-11733-4-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408925156-11733-4-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 09:05:55AM +0900, Minchan Kim wrote:
> @@ -513,6 +540,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> +
> +	if (zram->limit_pages &&
> +		zs_get_total_pages(meta->mem_pool) > zram->limit_pages) {
> +		zs_free(meta->mem_pool, handle);
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
>  	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);

Hello,

I don't follow up previous discussion, so I could be wrong.
Why this enforcement should be here?

I think that this has two problems.
1) alloc/free happens unnecessarilly if we have used memory over the
limitation.
2) Even if this request doesn't do new allocation, it could be failed
due to other's allocation. There is time gap between allocation and
free, so legimate user who want to use preallocated zsmalloc memory
could also see this condition true and then he will be failed.

Thanks.
