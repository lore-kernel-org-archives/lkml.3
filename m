Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaIXDBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 23:01:17 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:5952 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIXDBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 23:01:15 -0400
Message-ID: <542233F0.1080402@huawei.com>
Date: Wed, 24 Sep 2014 11:01:04 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: <tj@kernel.org>, <peterz@infradead.org>, <mingo@kernel.org>,
        <miaox@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <keescook@chromium.org>
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 beatomic flags
References: <54210D3F.2090409@huawei.com> <54210DA5.4040606@huawei.com> <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
In-Reply-To: <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/23 18:55, Tetsuo Handa wrote:
> Zefan Li wrote:
>> Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend
> 
> s/happend/happened/
> 
>> @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
>>  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
>>  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
>>  
>> +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
>> +TASK_PFA_SET(SPREAD_PAGE, spread_page)
>> +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
>> +
>> +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
>> +
> 
> I wonder how adding 3 macro lines differs from 3 inlined functions.
> Personally, from LXR (source code browser) point of view, inlined functions
> are more friendly than macros. Also, I wonder about the cost of extracting
> macros in a file which is likely included by every file but referenced
> by few files. Speak of SPREAD_PAGE and SPREAD_SLAB, they should be defined
> as inlined functions in include/linux/cpuset.h rather than as macros in
> include/linux/sched.h ?
> .

Though tsk->atomic_flags were newly introduced in 3.17 merge window, we
already have 3 flags, and we may see more flags added.

Those macros make the code easier to read, and emacs and cscope can also
understand them.

I'd vote for this:

TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)

TASK_PFA_TEST(SPREAD_PAGE, spread_page)
TASK_PFA_SET(SPREAD_PAGE, spread_page)
TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)

TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
TASK_PFA_SET(SPREAD_SLAB, spread_slab)
TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)

over this:

static inline bool task_no_new_privs(struct task_struct *p)
{
	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
}
static inline void task_set_new_privs(struct task_struct *p)
{
	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
}

static inline bool task_spread_page(struct task_struct *p)
{
	return test_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
}
static inline void task_set_spread_page(struct task_struct *p)
{
	set_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
}
static inline void task_clear_spread_page(struct task_struct *p)
{
	clear_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
}

static inline bool task_spread_slab(struct task_struct *p)
{
	return test_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
}
static inline void task_set_spread_slab(struct task_struct *p)
{
	set_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
}
static inline void task_clear_spread_slab(struct task_struct *p)
{
	clear_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
}


