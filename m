Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaDPBV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:21:29 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50653 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750997AbaDPBV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:21:28 -0400
X-IronPort-AV: E=Sophos;i="4.97,868,1389715200"; 
   d="scan'208";a="29314853"
Message-ID: <534DDBFC.9060803@cn.fujitsu.com>
Date: Wed, 16 Apr 2014 09:25:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com> <5335661E.7030408@cn.fujitsu.com> <20140415164752.GC30990@htj.dyndns.org>
In-Reply-To: <20140415164752.GC30990@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 12:47 AM, Tejun Heo wrote:
> On Fri, Mar 28, 2014 at 08:07:58PM +0800, Lai Jiangshan wrote:
>> +static inline void get_unbound_pwq(struct pool_workqueue *pwq)
>> +{
>> +	if (pwq->wq->flags & WQ_UNBOUND)
>> +		get_pwq(pwq);
>> +}
>> +
>>  /**
>>   * put_pwq - put a pool_workqueue reference
>>   * @pwq: pool_workqueue to put
>> @@ -1075,6 +1081,12 @@ static void put_pwq(struct pool_workqueue *pwq)
>>  	schedule_work(&pwq->unbound_release_work);
>>  }
>>  
>> +static inline void put_unbound_pwq(struct pool_workqueue *pwq)
>> +{
>> +	if (pwq->wq->flags & WQ_UNBOUND)
>> +		put_pwq(pwq);
>> +}
> 
> Ugh... please drop these helpers.
> 
>> +		get_unbound_pwq(pwq);
> 
> Why not just do get_pwq() here?

V1 patch just do get_pwq().

> 
> Thanks.
> 

1) Our aim is to protect unbound pwq, not percpu pwq which can't be be protected by get_pwq().
2) get_pwq() will make reviewers confused/surprised, destroy_workqueue() may destroy percpu pwqs
   with ref > 1. At least we need to add more comments explain this behavior. Origin comments:
		/*
		 * The base ref is never dropped on per-cpu pwqs.  Directly
		 * free the pwqs and wq.
		 */
3) get_unbound_pwq() self document.

Thanks,
Lai
