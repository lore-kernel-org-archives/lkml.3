Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaLZGpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 01:45:32 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:35488 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaLZGpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 01:45:31 -0500
Message-ID: <549D03F6.9090607@huawei.com>
Date: Fri, 26 Dec 2014 14:45:10 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Dave Jones" <davej@redhat.com>, <rui.xiang@huawei.com>,
        <wengmeiling.weng@huawei.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com> <20140707083016.GA19379@twins.programming.kicks-ass.net> <53BAA6DF.5060409@oracle.com> <20140707200550.GA6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140707200550.GA6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.549D0412.00CC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 54712ec9e065671cceeb6ad884f48a18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/8 4:05, Peter Zijlstra wrote:
> On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
>> I've also had this one, which looks similar:
>>
>> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965
>> [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15
>> [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
> 
> Something's fucked; so we have:
> 
> debug_spin_lock_before()
> 	SPIN_BUG_ON(lock->owner == current, "recursion");
> 

Hello，
Does ACCESS_ONCE() can help this issue? I have no evidence that its lack is
responsible for the issue, but I think here need it indeed. Is that right?

SPIN_BUG_ON(ACCESS_ONCE(lock->owner) == current, "recursion");

Thanks,
		Li Bin

> Causing that, _HOWEVER_ look at .owner_cpu and the reporting cpu!! How
> can the lock owner, own the lock on cpu 15 and again contend with it on
> CPU 0. That's impossible.
> 
> About when-ish did you start seeing things like this? Lemme go stare
> hard at recent changes.
> 


