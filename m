Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbaLCQ4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:56:03 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45415 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:56:01 -0500
Message-ID: <547F40FC.7030403@oracle.com>
Date: Wed, 03 Dec 2014 11:57:32 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, Laszlo Ersek <lersek@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH RESEND] xen/blkfront: improve protection against issuing
 unsupported REQ_FUA
References: <1414417478-20268-1-git-send-email-vkuznets@redhat.com> <1417438873-2082-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1417438873-2082-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 08:01 AM, Vitaly Kuznetsov wrote:
> Guard against issuing unsupported REQ_FUA and REQ_FLUSH was introduced
> in d11e61583 and was factored out into blkif_request_flush_valid() in
> 0f1ca65ee. However:
> 1) This check in incomplete. In case we negotiated to feature_flush = REQ_FLUSH
>     and flush_op = BLKIF_OP_FLUSH_DISKCACHE (so FUA is unsupported) FUA request
>     will still pass the check.
> 2) blkif_request_flush_valid() is misnamed. It is bool but returns true when
>     the request is invalid.
> 3) When blkif_request_flush_valid() fails -EIO is being returned. It seems that
>     -EOPNOTSUPP is more appropriate here.
> Fix all of the above issues.
>
> This patch is based on the original patch by Laszlo Ersek and a comment by
> Jeff Moyer.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Laszlo Ersek <lersek@redhat.com>

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

(although, as I mentioned last time, a companion patch to remove 
flush_op would be a good thing to have)


-boris

> ---
>   drivers/block/xen-blkfront.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 5ac312f..2e6c103 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -582,12 +582,14 @@ static inline void flush_requests(struct blkfront_info *info)
>   		notify_remote_via_irq(info->irq);
>   }
>   
> -static inline bool blkif_request_flush_valid(struct request *req,
> -					     struct blkfront_info *info)
> +static inline bool blkif_request_flush_invalid(struct request *req,
> +					       struct blkfront_info *info)
>   {
>   	return ((req->cmd_type != REQ_TYPE_FS) ||
> -		((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
> -		!info->flush_op));
> +		((req->cmd_flags & REQ_FLUSH) &&
> +		 !(info->feature_flush & REQ_FLUSH)) ||
> +		((req->cmd_flags & REQ_FUA) &&
> +		 !(info->feature_flush & REQ_FUA)));
>   }
>   
>   /*
> @@ -612,8 +614,8 @@ static void do_blkif_request(struct request_queue *rq)
>   
>   		blk_start_request(req);
>   
> -		if (blkif_request_flush_valid(req, info)) {
> -			__blk_end_request_all(req, -EIO);
> +		if (blkif_request_flush_invalid(req, info)) {
> +			__blk_end_request_all(req, -EOPNOTSUPP);
>   			continue;
>   		}
>   

