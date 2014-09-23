Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaIWGw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:52:59 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32490 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaIWGw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:52:57 -0400
Message-ID: <542118C2.6030302@huawei.com>
Date: Tue, 23 Sep 2014 14:52:50 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Miao Xie <miaox@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] sched: add a macro to define bitops for task atomic
 flags
References: <54210D3F.2090409@huawei.com> <54210D7B.8030103@huawei.com> <CAGXu5jJKNJ=PsTtkPaoMyCNf2fK07szP-hv4NdaiDVx4tHacQw@mail.gmail.com>
In-Reply-To: <CAGXu5jJKNJ=PsTtkPaoMyCNf2fK07szP-hv4NdaiDVx4tHacQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.542118C7.013E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 031cd62a07534d2b9da7b36be43eaab1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -static inline bool task_no_new_privs(struct task_struct *p)
>> -{
>> -       return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
>> -}
>> -
>> -static inline void task_set_no_new_privs(struct task_struct *p)
>> -{
>> -       set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
>> -}
>> +#define TASK_PFA_BITOPS(name, func)                            \
>> +static inline bool task_##func(struct task_struct *p)          \
>> +{ return test_bit(PFA_##name, &p->atomic_flags); }             \
>> +                                                               \
>> +static inline void task_set_##func(struct task_struct *p)      \
>> +{ set_bit(PFA_##name, &p->atomic_flags); }                     \
>> +                                                               \
>> +static inline void task_clear_##func(struct task_struct *p)    \
>> +{ clear_bit(PFA_##name, &p->atomic_flags); }
>> +
>> +TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)
> 
> One thing I don't like about this is that task_clear_no_new_privs()
> ends up getting defined, and it should absolutely never be used. NNP
> should never be cleared or there could be security issues. I realize
> this isn't a very useful nit-pick, but I'd rather the function wasn't
> even available for someone to accidentally use. Maybe break up the
> macro with some kind of "write only" version like:
> 
> #define TASK_PFA_BITOPS_WO(name, func)                            \
> static inline bool task_##func(struct task_struct *p)          \
> { return test_bit(PFA_##name, &p->atomic_flags); }             \
> static inline void task_set_##func(struct task_struct *p)      \
> { set_bit(PFA_##name, &p->atomic_flags); }
> 
> #define TASK_PFA_BITOPS(name, func)                            \
> TASK_PFA_BITOPS_WO(name, func);          \
> static inline void task_clear_##func(struct task_struct *p)    \
> { clear_bit(PFA_##name, &p->atomic_flags); }
> 
> TASK_PFA_BITOPS_WO(NO_NEW_PRIVS, no_new_privs)
> 
> And then all the new users can use TASK_PFA_BITOPS() normally since
> they expect to use "clear"?
> 

Now I'm inclined to do this:

+#define TASK_PFA_TEST(name, func)					\
+	static inline bool task_##func(struct task_struct *p)		\
+	{ return test_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_SET(name, func)					\
+	static inline void task_set_##func(struct task_struct *p)	\
+	{ set_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_CLEAR(name, func)					\
+	static inline void task_clear_##func(struct task_struct *p)	\
+	{ clear_bit(PFA_##name, &p->atomic_flags); }
+
+TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
+TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)

