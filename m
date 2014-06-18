Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbaFRCLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:11:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32496 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932987AbaFRCL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:11:29 -0400
Message-ID: <53A0F54F.2060205@fb.com>
Date: Tue, 17 Jun 2014 19:11:27 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: commit 762380a "block: add notion of a chunk size for request
 merging" stops io on btrfs
References: <53A0B491.1040901@gmail.com>
In-Reply-To: <53A0B491.1040901@gmail.com>
Content-Type: multipart/mixed;
	boundary="------------040505080906020503090908"
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-18_01:2014-06-17,2014-06-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.54951656745106e-15 kscore.compositescore=0
 circleOfTrustscore=1590.80820394217 compositescore=0.533125042697551
 urlsuspect_oldscore=0.533125042697551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406180023
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------040505080906020503090908
Content-Type: text/plain; charset="windows-1253"; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-06-17 14:35, Konstantinos Skarlatos wrote:
> Hi all,
> with 3.16-rc1  rsync stops writing to my btrfs filesystem and stays at a
> D+ state.
> git bisect showed that the problematic commit is:
>
> 762380ad9322951cea4ce9d24864265f9c66a916 is the first bad commit
> commit 762380ad9322951cea4ce9d24864265f9c66a916
> Author: Jens Axboe <axboe@fb.com>
> Date:   Thu Jun 5 13:38:39 2014 -0600
>
>      block: add notion of a chunk size for request merging
>
>      Some drivers have different limits on what size a request should
>      optimally be, depending on the offset of the request. Similar to
>      dividing a device into chunks. Add a setting that allows the driver
>      to inform the block layer of such a chunk size. The block layer will
>      then prevent merging across the chunks.
>
>      This is needed to optimally support NVMe with a non-zero stripe size.
>
>      Signed-off-by: Jens Axboe <axboe@fb.com>

That's odd, should not have any effect since nobody enables stripe sizes 
in the kernel. I'll double check, perhaps it's not always being cleared.

Ah wait, does the attached help?


-- 
Jens Axboe


--------------040505080906020503090908
Content-Type: text/x-patch; name="max-sectors.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="max-sectors.patch"

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 31e11051f1ba..713f8b62b435 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -920,7 +920,7 @@ static inline unsigned int blk_max_size_offset(struct request_queue *q,
 					       sector_t offset)
 {
 	if (!q->limits.chunk_sectors)
-		return q->limits.max_hw_sectors;
+		return q->limits.max_sectors;
 
 	return q->limits.chunk_sectors -
 			(offset & (q->limits.chunk_sectors - 1));

--------------040505080906020503090908--
