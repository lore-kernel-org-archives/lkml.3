Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3CEPjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:39:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13830 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab3CEPjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:39:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355068800"; 
   d="scan'208";a="6818458"
Message-ID: <5136123C.3040508@cn.fujitsu.com>
Date: Tue, 05 Mar 2013 23:41:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <eag0628@gmail.com>, linux-doc@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, xiaoguangrong@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@sisk.pl,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2] lglock: add read-preference local-global rwlock
References: <512BBAD8.8010006@linux.vnet.ibm.com> <CACvQF51jCxk5jUqmhD=QBBtUsBkQWZzakacrKO4Gsk=w61rNwQ@mail.gmail.com> <512C7A38.8060906@linux.vnet.ibm.com> <CACvQF51RvhM8XNqu3-1OTQ=cZUZ=pAX+_zx0a29+W67N1X+BgQ@mail.gmail.com> <512CC509.1050000@linux.vnet.ibm.com> <CACvQF50UgiqPpDk3HCmV86zKSf6tPjqr0bZowfPEOJs0g0r0MQ@mail.gmail.com> <512D0D67.9010609@linux.vnet.ibm.com> <CACvQF53ph2ixdM-otzetjM5cR+2kcZj6sckOp3TnzzA_x-EZ8w@mail.gmail.com> <512E7879.20109@linux.vnet.ibm.com>	<5130E8E2.50206@cn.fujitsu.com> <20130301182854.GA3631@redhat.com> <CANN689HEW=b5S93J27p+rBX-5m7jkW4FER=eHDCp7OgMaTWLPw@mail.gmail.com> <5131FB4C.7070408@cn.fujitsu.com> <513232B6.9060905@linux.vnet.ibm.com>
In-Reply-To: <513232B6.9060905@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:38:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:38:41,
	Serialize complete at 2013/03/05 23:38:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/13 01:11, Srivatsa S. Bhat wrote:
> On 03/02/2013 06:44 PM, Lai Jiangshan wrote:
>> From 345a7a75c314ff567be48983e0892bc69c4452e7 Mon Sep 17 00:00:00 2001
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Date: Sat, 2 Mar 2013 20:33:14 +0800
>> Subject: [PATCH] lglock: add read-preference local-global rwlock
>>
>> Current lglock is not read-preference, so it can't be used on some cases
>> which read-preference rwlock can do. Example, get_cpu_online_atomic().
>>
> [...]
>> diff --git a/kernel/lglock.c b/kernel/lglock.c
>> index 6535a66..52e9b2c 100644
>> --- a/kernel/lglock.c
>> +++ b/kernel/lglock.c
>> @@ -87,3 +87,71 @@ void lg_global_unlock(struct lglock *lg)
>>  	preempt_enable();
>>  }
>>  EXPORT_SYMBOL(lg_global_unlock);
>> +
>> +#define FALLBACK_BASE	(1UL << 30)
>> +
>> +void lg_rwlock_local_read_lock(struct lgrwlock *lgrw)
>> +{
>> +	struct lglock *lg = &lgrw->lglock;
>> +
>> +	preempt_disable();
>> +	if (likely(!__this_cpu_read(*lgrw->reader_refcnt))) {
>> +		rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
>> +		if (unlikely(!arch_spin_trylock(this_cpu_ptr(lg->lock)))) {
>> +			read_lock(&lgrw->fallback_rwlock);
>> +			__this_cpu_write(*lgrw->reader_refcnt, FALLBACK_BASE);
>> +			return;
>> +		}
>> +	}
>> +
>> +	__this_cpu_inc(*lgrw->reader_refcnt);
>> +}
>> +EXPORT_SYMBOL(lg_rwlock_local_read_lock);
>> +
>> +void lg_rwlock_local_read_unlock(struct lgrwlock *lgrw)
>> +{
>> +	switch (__this_cpu_read(*lgrw->reader_refcnt)) {
>> +	case 1:
>> +		__this_cpu_write(*lgrw->reader_refcnt, 0);
>> +		lg_local_unlock(&lgrw->lglock);
>> +		return;
> 
> This should be a break, instead of a return, right?
> Otherwise, there will be a preempt imbalance...


"lockdep" and "preempt" are handled in lg_local_unlock(&lgrw->lglock);

Thanks,
Lai

> 
>> +	case FALLBACK_BASE:
>> +		__this_cpu_write(*lgrw->reader_refcnt, 0);
>> +		read_unlock(&lgrw->fallback_rwlock);
>> +		rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
>> +		break;
>> +	default:
>> +		__this_cpu_dec(*lgrw->reader_refcnt);
>> +		break;
>> +	}
>> +
>> +	preempt_enable();
>> +}
> 
> 
> Regards,
> Srivatsa S. Bhat
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

