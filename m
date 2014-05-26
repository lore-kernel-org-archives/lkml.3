Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaEZFX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:23:58 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21100 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404AbaEZFX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:23:57 -0400
X-IronPort-AV: E=Sophos;i="4.98,910,1392134400"; 
   d="scan'208";a="30996293"
Message-ID: <5382D0DB.1000907@cn.fujitsu.com>
Date: Mon, 26 May 2014 13:27:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: remove the unneeded cpu_relax() in __queue_work()
References: <1400748257-14165-1-git-send-email-laijs@cn.fujitsu.com> <20140522134758.GA5065@htj.dyndns.org> <CACvQF53Xs91KMdsYCsqM-NNJYtb+byajjc668aiM2vMFBv3JaA@mail.gmail.com> <20140526042311.GA14432@htj.dyndns.org>
In-Reply-To: <20140526042311.GA14432@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 12:23 PM, Tejun Heo wrote:
> On Thu, May 22, 2014 at 10:21:25PM +0800, Lai Jiangshan wrote:
>> On Thu, May 22, 2014 at 9:47 PM, Tejun Heo <tj@kernel.org> wrote:
>> This is not busy wait, the retry and numa_pwq_tbl() guarantee that
>> the retry will get a new pwq (even without cpu_relax()) as the comments says,
> 
> Yes, *eventually*.  It's not guaranteed to succeed on the immediate
> next try.  This is a busy wait.



changing pwq:
	install pwq
	lock(pool->lock)
	put_pwq();
	unlock(pool->lock)

__queue_work():
	lock(pool->lock)
	test ref and find it zero;
	see the installation here;
	it is guaranteed to get the installed pwq on the immediate next try.
	unlock()
	retry.




> 
>> and the refcnt of this new pwq is very very likely non-zero and
>> cpu_relax() can't
>> increase the probability of non-zero-refcnt. cpu_relax() is useless here.
>>
>> It is different from spin_lock() or some other spin code.
>>
>> it is similar to the loop of __task_rq_lock() which also guarantees progress.
> 
> No, it's not.  __task_rq_lock() *already* sees the updated value to
> use for the next time.  Here, we see the old one dead and the new one
> is guaranteed to show up pretty soon but we're still busy waiting for
> it.
> 

