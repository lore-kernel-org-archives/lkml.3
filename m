Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3GWBTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:19:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3GWBTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:19:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,722,1367942400"; 
   d="scan'208";a="7984713"
Message-ID: <51EDDB02.20502@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 09:23:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com,
        Yinghai Lu <yinghai@kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
References: <51E55B7D.2040209@linux.vnet.ibm.com> <51E66CCC.9010600@cn.fujitsu.com> <51E84EDC.5090502@linux.vnet.ibm.com> <51E89ABB.20808@cn.fujitsu.com> <51E8FF76.5030706@linux.vnet.ibm.com> <51ED1D02.80205@cn.fujitsu.com> <20130722213231.GC16776@mtj.dyndns.org>
In-Reply-To: <20130722213231.GC16776@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:17:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:17:32,
	Serialize complete at 2013/07/23 09:17:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 05:32 AM, Tejun Heo wrote:
> On Mon, Jul 22, 2013 at 07:52:34PM +0800, Lai Jiangshan wrote:
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index f02c4a4..b021a45 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -4731,6 +4731,7 @@ struct work_for_cpu {
>>  	long (*fn)(void *);
>>  	void *arg;
>>  	long ret;
>> +	struct completion done;
>>  };
>>  
>>  static void work_for_cpu_fn(struct work_struct *work)
>> @@ -4738,6 +4739,7 @@ static void work_for_cpu_fn(struct work_struct *work)
>>  	struct work_for_cpu *wfc = container_of(work, struct work_for_cpu, work);
>>  
>>  	wfc->ret = wfc->fn(wfc->arg);
>> +	complete(&wfc->done);
>>  }
>>  
>>  /**
>> @@ -4755,8 +4757,9 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>>  	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>>  
>>  	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
>> +	init_completion(&wfc.done);
>>  	schedule_work_on(cpu, &wfc.work);
>> -	flush_work(&wfc.work);
>> +	wait_for_completion(&wfc.done);
> 
> Hmmm... it's kinda nasty.  Given how infrequently work_on_cpu() users
> nest, I think it'd be cleaner to have work_on_cpu_nested() which takes
> @subclass.  It requires extra work on the caller's part but I think
> that actually is useful as nested work_on_cpu()s are pretty weird
> things.
> 

The problem is that the userS may not know their work_on_cpu() nested,
especially when work_on_cpu()s are on different subsystems and the call depth
is deep enough but the nested work_on_cpu() depends on some conditions.

I prefer to change the user instead of introducing work_on_cpu_nested(), and
I accept to change the user only instead of change work_on_cpu() since there is only
one nested-calls case found.

But I'm thinking, since nested work_on_cpu() don't have any problem,
Why workqueue.c don't offer a more friendly API/behavior?

Thanks,
Lai
