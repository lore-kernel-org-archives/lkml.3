Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3CEQ0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:26:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab3CEQ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:26:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355068800"; 
   d="scan'208";a="6818570"
Message-ID: <51361540.3060603@cn.fujitsu.com>
Date: Tue, 05 Mar 2013 23:54:40 +0800
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
Subject: Re: [PATCH] lglock: add read-preference local-global rwlock
References: <512C7A38.8060906@linux.vnet.ibm.com> <CACvQF51RvhM8XNqu3-1OTQ=cZUZ=pAX+_zx0a29+W67N1X+BgQ@mail.gmail.com> <512CC509.1050000@linux.vnet.ibm.com> <CACvQF50UgiqPpDk3HCmV86zKSf6tPjqr0bZowfPEOJs0g0r0MQ@mail.gmail.com> <512D0D67.9010609@linux.vnet.ibm.com> <CACvQF53ph2ixdM-otzetjM5cR+2kcZj6sckOp3TnzzA_x-EZ8w@mail.gmail.com> <512E7879.20109@linux.vnet.ibm.com> <5130E8E2.50206@cn.fujitsu.com> <20130301182854.GA3631@redhat.com> <CANN689HEW=b5S93J27p+rBX-5m7jkW4FER=eHDCp7OgMaTWLPw@mail.gmail.com> <20130302170656.GB29769@redhat.com>
In-Reply-To: <20130302170656.GB29769@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:51:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:51:39,
	Serialize complete at 2013/03/05 23:51:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/13 01:06, Oleg Nesterov wrote:
> On 03/02, Michel Lespinasse wrote:
>>
>> My version would be slower if it needs to take the
>> slow path in a reentrant way, but I'm not sure it matters either :)
> 
> I'd say, this doesn't matter at all, simply because this can only happen
> if we race with the active writer.
> 

It can also happen when interrupted. (still very rarely)

arch_spin_trylock()
	------->interrupted,
		__this_cpu_read() returns 0.
		arch_spin_trylock() fails
		slowpath, any nested will be slowpath too.
		...
		..._read_unlock()
	<-------interrupt
__this_cpu_inc()
....


I saw get_online_cpu_atomic() is called very frequent.
And the above thing happens in one CPU rarely, but how often it
happens in the whole system if we have 4096 CPUs?
(I worries to much. I tend to remove FALLBACK_BASE now, we should
add it only after we proved we needed it, this part is not proved)

Thanks,
Lai


