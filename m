Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3CEPZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:25:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64742 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab3CEPZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:25:10 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355068800"; 
   d="scan'208";a="6818416"
Message-ID: <51360ED1.3030104@cn.fujitsu.com>
Date: Tue, 05 Mar 2013 23:27:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Michel Lespinasse <walken@google.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
References: <CACvQF51RvhM8XNqu3-1OTQ=cZUZ=pAX+_zx0a29+W67N1X+BgQ@mail.gmail.com> <512CC509.1050000@linux.vnet.ibm.com> <CACvQF50UgiqPpDk3HCmV86zKSf6tPjqr0bZowfPEOJs0g0r0MQ@mail.gmail.com> <512D0D67.9010609@linux.vnet.ibm.com> <CACvQF53ph2ixdM-otzetjM5cR+2kcZj6sckOp3TnzzA_x-EZ8w@mail.gmail.com> <512E7879.20109@linux.vnet.ibm.com> <5130E8E2.50206@cn.fujitsu.com> <20130301182854.GA3631@redhat.com> <CANN689HEW=b5S93J27p+rBX-5m7jkW4FER=eHDCp7OgMaTWLPw@mail.gmail.com> <5131FB4C.7070408@cn.fujitsu.com> <20130302172003.GC29769@redhat.com>
In-Reply-To: <20130302172003.GC29769@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:24:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:24:06,
	Serialize complete at 2013/03/05 23:24:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/13 01:20, Oleg Nesterov wrote:
> On 03/02, Lai Jiangshan wrote:
>>
>> +void lg_rwlock_local_read_unlock(struct lgrwlock *lgrw)
>> +{
>> +	switch (__this_cpu_read(*lgrw->reader_refcnt)) {
>> +	case 1:
>> +		__this_cpu_write(*lgrw->reader_refcnt, 0);
>> +		lg_local_unlock(&lgrw->lglock);
>> +		return;
>> +	case FALLBACK_BASE:
>> +		__this_cpu_write(*lgrw->reader_refcnt, 0);
>> +		read_unlock(&lgrw->fallback_rwlock);
>> +		rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
> 
> I guess "case 1:" should do rwlock_release() too.

Already do it in "lg_local_unlock(&lgrw->lglock);" before it returns.
(I like reuse old code)

> 
> Otherwise, at first glance looks correct...
> 
> However, I still think that FALLBACK_BASE only adds the unnecessary
> complications. But even if I am right this is subjective of course, please
> feel free to ignore.

OK, I kill FALLBACK_BASE in later patch.

> 
> And btw, I am not sure about lg->lock_dep_map, perhaps we should use
> fallback_rwlock->dep_map ?

Use either one is OK.

> 
> We need rwlock_acquire_read() even in the fast-path, and this acquire_read
> should be paired with rwlock_acquire() in _write_lock(), but it does
> spin_acquire(lg->lock_dep_map). Yes, currently this is the same (afaics)
> but perhaps fallback_rwlock->dep_map would be more clean.
> 

I can't tell which one is better. I try to use fallback_rwlock->dep_map later.

> Oleg.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

