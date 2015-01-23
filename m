Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbbAWLPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:15:21 -0500
Received: from smtp.citrix.com ([66.165.176.89]:52685 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbAWLPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:15:17 -0500
X-IronPort-AV: E=Sophos;i="5.09,453,1418083200"; 
   d="scan'208";a="219960106"
Message-ID: <54C22D41.9040301@citrix.com>
Date: Fri, 23 Jan 2015 12:15:13 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Ouyang Zhaowei (Charles)" <ouyangzhaowei@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <suoben@huawei.com>,
        <liuyingdong@huawei.com>, <weiping.ding@huawei.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: xen-blkfront: weird behavior of "iostat" after VM live-migrate
 which xen-blkfront module has indirect descriptors
References: <54C1FF44.1090902@huawei.com>
In-Reply-To: <54C1FF44.1090902@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

El 23/01/15 a les 8.59, Ouyang Zhaowei (Charles) ha escrit:
> Hi Roger,
> 
> We are testing the indirect feature of xen-blkfront module these days.
> And we found that, after VM live-migrate a couple of times, the "%util" of iostat keeps being 100%, and there are several requests stock in "avgqu-sz".
> We have checked some later version of Linux, and it happens on Ubuntu 14.04, Ubuntu 14.10 and RHEL 7.0.
> 
> The iostat shows like below:
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.00    0.00    0.00    0.00    0.00  100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> xvda              0.00     0.00    0.00    0.00     0.00     0.00     0.00     4.00    0.00    0.00    0.00   0.00 100.00
> dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
> dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
> 
> Could you tell us that why is this happening, is this a bug?

It is a bug indeed, thanks for reporting it. The problem seems to be 
that blk_put_request (which is used to discard the old requests before 
requeuing them) doesn't update the queue statistics. The following 
patch solves the problem for me, could you try it and report back?

---
commit bb4317c051ca81a2906edb7ccc505cbd6d1d80c7
Author: Roger Pau Monne <roger.pau@citrix.com>
Date:   Fri Jan 23 12:10:51 2015 +0100

    xen-blkfront: fix accounting of reqs when migrating
    
    Current migration code uses blk_put_request in order to finish a request
    before requeuing it. This function doesn't update the statistics of the
    queue, which completely screws accounting. Use blk_end_request_all instead
    which properly updates the statistics of the queue.
    
    Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 5ac312f..aac41c1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1493,7 +1493,7 @@ static int blkif_recover(struct blkfront_info *info)
 		merge_bio.tail = copy[i].request->biotail;
 		bio_list_merge(&bio_list, &merge_bio);
 		copy[i].request->bio = NULL;
-		blk_put_request(copy[i].request);
+		blk_end_request_all(copy[i].request, 0);
 	}
 
 	kfree(copy);
@@ -1516,7 +1516,7 @@ static int blkif_recover(struct blkfront_info *info)
 		req->bio = NULL;
 		if (req->cmd_flags & (REQ_FLUSH | REQ_FUA))
 			pr_alert("diskcache flush request found!\n");
-		__blk_put_request(info->rq, req);
+		__blk_end_request_all(req, 0);
 	}
 	spin_unlock_irq(&info->io_lock);
 

