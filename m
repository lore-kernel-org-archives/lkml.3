Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3HAUe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:34:28 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:47269 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab3HAUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:34:26 -0400
Message-ID: <51FAC4DD.70400@hds.com>
Date: Thu, 01 Aug 2013 16:28:13 -0400
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        seiji.aguchi@hds.com
Subject: Re: [RFC PATCH] cfq-iosched: limit slice_idle when many busy queues
 are in idle window
References: <20130730193033.27856.58005.stgit@hds.com> <20130731020928.GA27570@kernel.org>
In-Reply-To: <20130731020928.GA27570@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-01_08:2013-08-01,2013-08-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0
 kscore.is_bulkscore=3.55239671012697e-10 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.099904392073018
 urlsuspect_oldscore=0.997215366458519 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=3958
 rbsscore=0.099904392073018 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1308010195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/13 10:09 PM, Shaohua Li wrote:
> On Tue, Jul 30, 2013 at 03:30:33PM -0400, Tomoki Sekiyama wrote:
>> Hi,
>>
>> When some application launches several hundreds of processes that issue
>> only a few small sync I/O requests, CFQ may cause heavy latencies
>> (10+ seconds at the worst case), although the request rate is low enough for
>> the disk to handle it without waiting. This is because CFQ waits for
>> slice_idle (default:8ms) every time before processing each request, until
>> their thinktimes are evaluated.
>>
>> This scenario can be reproduced using fio with parameters below:
>>   fio -filename=/tmp/test -rw=randread -size=5G -runtime=15 -name=file1 \
>>       -bs=4k -numjobs=500 -thinktime=1000000
>> In this case, 500 processes issue a random read request every second.
> 
> For this workload CFQ should perfectly detect it's a seek queue and disable
> idle. I suppose the reason is CFQ hasn't enough data/time to disable idle yet,
> since your thinktime is long and runtime is short.

Right, CFQ will learn the patten, but it takes too long time to reach stable
performance when a lot of I/O processes are launched.

> I thought the real problem here is cfq_init_cfqq() shouldn't set idle_window
> when initializing a queue. We should enable idle window after we detect the
> queue is worthy idle.

Do you think the patch below is appropriate? Or should we check whether
busy_idle_queues in my original patch is high enough and only then
disable default idle_window in cfq_init_cfqq()?

> Thanks,
> Shaohua

Thanks,
Tomoki Sekiyama

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d5cd313..abbe28f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3514,11 +3514,8 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	cfq_mark_cfqq_prio_changed(cfqq);
 
-	if (is_sync) {
-		if (!cfq_class_idle(cfqq))
-			cfq_mark_cfqq_idle_window(cfqq);
+	if (is_sync)
 		cfq_mark_cfqq_sync(cfqq);
-	}
 	cfqq->pid = pid;
 }

