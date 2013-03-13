Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab3CMQy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:54:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29853 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3CMQyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:54:25 -0400
MIME-Version: 1.0
Message-ID: <9a45f4be-a80c-434d-ae7f-f8faaea5e4d4@default>
Date: Wed, 13 Mar 2013 09:53:48 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH 2/4] zcache: zero-filled pages awareness
References: <<1363158321-20790-1-git-send-email-liwanp@linux.vnet.ibm.com>>
 <<1363158321-20790-3-git-send-email-liwanp@linux.vnet.ibm.com>>
In-Reply-To: <<1363158321-20790-3-git-send-email-liwanp@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> Subject: [PATCH 2/4] zcache: zero-filled pages awareness
> 
> Compression of zero-filled pages can unneccessarily cause internal
> fragmentation, and thus waste memory. This special case can be
> optimized.
> 
> This patch captures zero-filled pages, and marks their corresponding
> zcache backing page entry as zero-filled. Whenever such zero-filled
> page is retrieved, we fill the page frame with zero.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/tmem.c        |    4 +-
>  drivers/staging/zcache/tmem.h        |    5 ++
>  drivers/staging/zcache/zcache-main.c |   87 ++++++++++++++++++++++++++++++----
>  3 files changed, 85 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/zcache/tmem.c b/drivers/staging/zcache/tmem.c
> index a2b7e03..62468ea 100644
> --- a/drivers/staging/zcache/tmem.c
> +++ b/drivers/staging/zcache/tmem.c
> @@ -597,7 +597,9 @@ int tmem_put(struct tmem_pool *pool, struct tmem_oid *oidp, uint32_t index,
>  	if (unlikely(ret == -ENOMEM))
>  		/* may have partially built objnode tree ("stump") */
>  		goto delete_and_free;
> -	(*tmem_pamops.create_finish)(pampd, is_ephemeral(pool));
> +	if (pampd != (void *)ZERO_FILLED)
> +		(*tmem_pamops.create_finish)(pampd, is_ephemeral(pool));
> +
>  	goto out;
> 
>  delete_and_free:
> diff --git a/drivers/staging/zcache/tmem.h b/drivers/staging/zcache/tmem.h
> index adbe5a8..6719dbd 100644
> --- a/drivers/staging/zcache/tmem.h
> +++ b/drivers/staging/zcache/tmem.h
> @@ -204,6 +204,11 @@ struct tmem_handle {
>  	uint16_t client_id;
>  };
> 
> +/*
> + * mark pampd to special vaule in order that later
> + * retrieve will identify zero-filled pages
> + */
> +#define ZERO_FILLED 0x2

You can avoid changing tmem.[ch] entirely by moving this
definition into zcache-main.c and by moving the check
comparing pampd against ZERO_FILLED into zcache_pampd_create_finish()
I think that would be cleaner...

If you change this and make the pageframe counter fix for PATCH 4/4,
please add my ack for the next version:

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

