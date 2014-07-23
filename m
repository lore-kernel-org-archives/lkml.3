Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbaGWTId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:08:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10320 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514AbaGWTIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:08:32 -0400
Message-ID: <53D007F3.4040006@fb.com>
Date: Wed, 23 Jul 2014 21:07:31 +0200
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matias Bjorling <m@bjorling.me>, Christoph Hellwig <hch@infradead.org>
CC: <willy@linux.intel.com>, <keith.busch@intel.com>, <sbradshaw@micron.com>,
        <tom.leiming@gmail.com>, <rlnelson@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v10] NVMe: Convert to blk-mq
References: <1404226382-7179-1-git-send-email-m@bjorling.me> <1404226382-7179-2-git-send-email-m@bjorling.me> <20140714124131.GA311@infradead.org> <53D005D6.8050302@bjorling.me>
In-Reply-To: <53D005D6.8050302@bjorling.me>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-23_07:2014-07-23,2014-07-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.1234346786182e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407230226
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-23 20:58, Matias Bjorling wrote:
>>> +    iod = nvme_alloc_iod(psegs, blk_rq_bytes(req), GFP_ATOMIC);
>>>       if (!iod)
>>> +        return result;
>>
>> So there's still a memory allocation for each request here.  Any reason
>> this can't be preallocated at least for reasonable sized I/O?
>
> Not at all. I've kept from adding optimizations in the first pass. The
> patches following can implement the optimizations. Jens already has a
> patch for this in his tree. It also removes GFP_ATOMIC.

That is correct, and that is the way the series should be done. I've got 
patches getting rid of this allocation for smaller IO:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=04497c3394f3220111d4274704a1ff6bdd3ceae3

which is a noticable win for high IOPS smaller IO.

>> Seems like blk-mq would make your life easier by exporting an iterator
>> that goes over each in-use request instead of the current
>> blk_mq_tag_busy_iter prototype.  blk_mq_timeout_check would also be able
>> to make use of that, so maybe that would be a good preparatory patch?
>
> Yes. I'll prepare a patch and send it off to Jens.

Thanks, that will clean it up nicely. It's a bit backwards these days, 
since the mechanism got changed.


-- 
Jens Axboe

