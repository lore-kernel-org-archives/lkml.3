Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaJ1UVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:21:03 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:46830 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaJ1UVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:21:00 -0400
Message-ID: <544FFAA7.1060705@de.ibm.com>
Date: Tue, 28 Oct 2014 21:20:55 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: blk-mq vs cpu hotplug performance (due to percpu_ref_put performance)
References: <544FF00B.8050403@de.ibm.com> <20141028200055.GA8205@htj.dyndns.org>
In-Reply-To: <20141028200055.GA8205@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102820-0029-0000-0000-0000016667CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.10.2014 21:00, schrieb Tejun Heo:
> Hello,
> 
> On Tue, Oct 28, 2014 at 08:35:39PM +0100, Christian Borntraeger wrote:
>> when going from 3.17 to 3.18-rc2 cpu hotplug become horrible slow on some KVM guests on s390
>>
>> I was able to bisect this to
>>
>> commit 9eca80461a45177e456219a9cd944c27675d6512
>> ("Revert "blk-mq, percpu_ref: implement a kludge for SCSI blk-mq stall during probe")
> 
> That removes the earlier kludge to avoid the RCU delay so RCU
> latencies are expected to show up right after; however, the following
> patches implement proper fix for the problem and the latencies
> shouldn't be visible afterwards.
> 
> So, 17497acbdce9 ("blk-mq, percpu_ref: start q->mq_usage_counter in
> atomic mode") should remove the latencies again.  It doesn't?

I have not verified this, but I guess what happens is:
hotplug
-> notify
-> blk_mq_queue_reinit_notify
-> blk_mq_queue_reinit
-> blk_mq_freeze_queue
-> percpu_ref_kill
-> percpu_ref_kill_and_confirm
-> __percpu_ref_switch_to_atomic
-> call_rcu_sched  

for every request queue.
Christian

