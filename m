Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbaFSB5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:57:46 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:52568 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754277AbaFSB5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:57:45 -0400
X-IronPort-AV: E=Sophos;i="5.00,735,1396972800"; 
   d="scan'208";a="32122520"
Message-ID: <53A243B8.4010501@cn.fujitsu.com>
Date: Thu, 19 Jun 2014 09:58:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cl@linux-foundation.org>, <kmo@daterainc.com>,
        <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
References: <1403053685-28240-1-git-send-email-tj@kernel.org> <1403053685-28240-7-git-send-email-tj@kernel.org> <53A1097F.3060400@cn.fujitsu.com> <20140618153222.GA11042@htj.dyndns.org>
In-Reply-To: <20140618153222.GA11042@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 11:32 PM, Tejun Heo wrote:
> On Wed, Jun 18, 2014 at 11:37:35AM +0800, Lai Jiangshan wrote:
>>> @@ -97,7 +98,10 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
>>>  static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
>>>  				    unsigned __percpu **pcpu_countp)
>>>  {
>>> -	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
>>> +	unsigned long pcpu_ptr;
>>> +
>>> +	/* paired with smp_store_release() in percpu_ref_reinit() */
>>> +	pcpu_ptr = smp_load_acquire(&ref->pcpu_count_ptr);
>>
>>
>> Does "smp_load_acquire()" hurts the performance of percpu_ref_get/put()
>> in non-x86 system?
> 
> It's equivalent to data dependency barrier.  The only arch which needs
> something more than barrier() is alpha.  It isn't an issue.
> 

But I searched from the source, smp_load_acquire() is just barrier() in
x86, arm64, ia64, s390, sparc, but it includes memory barrier 
instruction in other archs.

CC Paul. If smp_load_acquire() is sufficient lightweight, I would update
the SRCU.

Thanks,
Lai
