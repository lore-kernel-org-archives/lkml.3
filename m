Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaJ1U3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:29:25 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:56104 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaJ1U3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:29:22 -0400
Message-ID: <544FFC9C.60908@de.ibm.com>
Date: Tue, 28 Oct 2014 21:29:16 +0100
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
References: <544FF00B.8050403@de.ibm.com> <20141028200055.GA8205@htj.dyndns.org> <544FFAA7.1060705@de.ibm.com> <20141028202255.GB8205@htj.dyndns.org>
In-Reply-To: <20141028202255.GB8205@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102820-0041-0000-0000-000001D9C2BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.10.2014 21:22, schrieb Tejun Heo:
> On Tue, Oct 28, 2014 at 09:20:55PM +0100, Christian Borntraeger wrote:
>> I have not verified this, but I guess what happens is:
>> hotplug
>> -> notify
>> -> blk_mq_queue_reinit_notify
>> -> blk_mq_queue_reinit
>> -> blk_mq_freeze_queue
>> -> percpu_ref_kill
>> -> percpu_ref_kill_and_confirm
>> -> __percpu_ref_switch_to_atomic
>> -> call_rcu_sched  
> 
> But call_rcu_sched() wouldn't show up as latency.  It's an async call
> unlike synchronize_*().

Right, but

blk_mq_freeze_queue

also contains

wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));

Isnt that wait_event woken up at the end of the call_rcu_sched?

