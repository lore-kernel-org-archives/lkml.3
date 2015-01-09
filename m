Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbbAIPvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:51:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:60493 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbbAIPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:51:41 -0500
X-IronPort-AV: E=Sophos;i="5.07,731,1413244800"; 
   d="scan'208";a="214080532"
Message-ID: <54AFF909.3090909@citrix.com>
Date: Fri, 9 Jan 2015 16:51:37 +0100
From: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bob Liu <bob.liu@oracle.com>, <xen-devel@lists.xen.org>
CC: <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <david.vrabel@citrix.com>, <junxiao.bi@oracle.com>
Subject: Re: [PATCH] xen/blkfront: restart request queue when there is enough
 persistent_gnts_c
References: <1420550343-14013-1-git-send-email-bob.liu@oracle.com>
In-Reply-To: <1420550343-14013-1-git-send-email-bob.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 06/01/15 a les 14.19, Bob Liu ha escrit:
> When there is no enough free grants, gnttab_alloc_grant_references()
> will fail and block request queue will stop.
> If the system is always lack of grants, blkif_restart_queue_callback() can't be
> scheduled and block request queue can't be restart(block I/O hang).
> 
> But when there are former requests complete, some grants may free to
> persistent_gnts_c, we can give the request queue another chance to restart and
> avoid block hang.
> 
> Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/block/xen-blkfront.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 2236c6f..dd30f99 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1125,6 +1125,17 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>  			}
>  		}
>  	}
> +
> +	/*
> +	 * Request queue would be stopped if failed to alloc enough grants and
> +	 * won't be restarted until gnttab_free_count >= info->callback->count.
> +	 *
> +	 * But there is another case, once we have enough persistent grants we
> +	 * can try to restart the request queue instead of continue to wait for
> +	 * 'gnttab_free_count'.
> +	 */
> +	if (info->persistent_gnts_c >= info->callback.count)
> +		schedule_work(&info->work);

I guess I'm missing something here, but blkif_completion is called by
blkif_interrupt, which in turn calls kick_pending_request_queues when
finished, which IMHO should be enough to restart the processing of requests.

Roger.
