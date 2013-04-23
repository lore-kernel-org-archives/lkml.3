Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3DWNmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:42:47 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38090 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3DWNmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:42:46 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Namjae Jeon <linkinjeon@gmail.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Vivek Trivedi" <t.vivek@samsung.com>, Shaohua Li <shli@kernel.org>,
        Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] block: fix max discard sectors limit
Thread-Topic: [PATCH] block: fix max discard sectors limit
Thread-Index: AQHOQCNxeTQNil/JwUSLmnJe4Mx5ApjkReuA
Date: Tue, 23 Apr 2013 13:42:41 +0000
Message-ID: <1366724561.1930.3.camel@dabdike>
References: <1366722406-2899-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1366722406-2899-1-git-send-email-linkinjeon@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.18.112.117]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <FAD20AB0DEF1AC4E8A7C8E321D7596CE@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 22:06 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>

Hey, it's very impolite to send a patch I just gave you as a suggestion
to fix the issue under your own authorship.

What we need to know is has this been tested ... there's no tested-by
tags (and there also should really be a reported by).

James

> linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
> commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
> (block: add plug for blkdev_issue_discard )
> 
> For example,
> 1) DISCARD rq-1 with size size 4GB
> 2) DISCARD rq-2 with size size 1GB
> 
> If these 2 discard requests get merged, final request size will be 5GB.
> 
> In this case, request's __data_len field may overflow as it can store
> max 4GB(unsigned int).
> 
> This issue was observed while doing mkfs.f2fs on 5GB SD card:
> https://lkml.org/lkml/2013/4/1/292
> 
> Info: sector size = 512
> Info: total sectors = 11370496 (in 512bytes)
> Info: zone aligned segment0 blkaddr: 512
> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> 
> mkfs process gets stuck in D state and I see the following in the dmesg:
> 
> [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
> [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
> [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len
> 1526726656
> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
> [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
> [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len
> 1526726656
> 
> This patch fixes this issue.
> 
> Reported-by: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Kent Overstreet <koverstreet@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: <stable@vger.kernel.org>
> ---
>  include/linux/blkdev.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 07aa5f6..ff636bd 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -844,7 +844,7 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>  						     unsigned int cmd_flags)
>  {
>  	if (unlikely(cmd_flags & REQ_DISCARD))
> -		return q->limits.max_discard_sectors;
> +		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
>  
>  	if (unlikely(cmd_flags & REQ_WRITE_SAME))
>  		return q->limits.max_write_same_sectors;

