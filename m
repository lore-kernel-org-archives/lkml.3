Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaLABfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:35:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35977 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbaLABfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:35:16 -0500
Message-ID: <547BC5CF.7080904@fb.com>
Date: Sun, 30 Nov 2014 18:35:11 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: don't use rw_is_sync() to determine sync request
References: <4f327fd4f830a3fceab3694cdd7621c37f780809.1417391999.git.shli@kernel.org>
In-Reply-To: <4f327fd4f830a3fceab3694cdd7621c37f780809.1417391999.git.shli@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-11-30_03:2014-11-28,2014-11-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.84130488634082e-13 kscore.compositescore=0
 circleOfTrustscore=514.84 compositescore=0.98609165920913
 urlsuspect_oldscore=0.98609165920913 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412010015
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 05:01 PM, Shaohua Li wrote:
> Buffer read is counted as sync in rw_is_sync(). If we use it,
> blk_sq_make_request() will not do per-process plug any more.
>
> I haven't changed blk_mq_make_request() yet. It makes sense to dispatch
> REQ_SYNC request immediately. But for buffer read, it's weird not to do
> per-process plug, as buffer read doesn't need low latency.
> blk_mq_merge_queue_io() isn't very helpful, as we don't have delay mechanism
> there, the queue is immediately flushed, which makes the merge very
> superficial.

A read is sync, buffered or not. A buffered read is every bit as latency 
sensitive as an O_DIRECT read. I think it'd be fine to modify 
rw_is_sync() to disregard REQ_AHEAD as sync (and ensure it's carried 
forward in the request flags, too). At least to the extent that we 
process plug and get the merging, since for streamed reads we'd soon be 
waiting on them anyway.

-- 
Jens Axboe

