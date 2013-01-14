Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3ANSr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:47:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:59982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab3ANSr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:47:58 -0500
Message-ID: <50F45321.50808@infradead.org>
Date: Mon, 14 Jan 2013 10:49:05 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
References: <20130107142649.c843e0b711532dc3a631e4cf@canb.auug.org.au> <50EB252C.4010005@infradead.org> <20130107221627.GZ2525@linux.vnet.ibm.com> <20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au> <1357600327.5190.13.camel@gandalf.local.home> <1357605379.5190.15.camel@gandalf.local.home> <20130108035348.GF2525@linux.vnet.ibm.com> <50F43612.8080600@infradead.org> <20130114173208.GY3384@linux.vnet.ibm.com>
In-Reply-To: <20130114173208.GY3384@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/13 09:32, Paul E. McKenney wrote:
> On Mon, Jan 14, 2013 at 08:45:06AM -0800, Randy Dunlap wrote:
>> On 01/07/13 19:53, Paul E. McKenney wrote:
>>> On Mon, Jan 07, 2013 at 07:36:19PM -0500, Steven Rostedt wrote:
>>>> On Mon, 2013-01-07 at 18:12 -0500, Steven Rostedt wrote:
>>>>> On Tue, 2013-01-08 at 09:59 +1100, Stephen Rothwell wrote:
>>>>>> Hi Paul,
>>>>>>
>>>>>> On Mon, 7 Jan 2013 14:16:27 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>>>>>>
>>>>>>> On Mon, Jan 07, 2013 at 11:42:36AM -0800, Randy Dunlap wrote:
>>>>>>>>
>>>>>>>> on i386 or x86_64:
>>>>>>>>
>>>>>>>> ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
>>>>>>>
>>>>>>> Hello, Randy,
>>>>>>>
>>>>>>> Did your build include the following, also pushed to -next in that same
>>>>>>> batch from -rcu?  Including Steven Rostedt on CC for his take.
>>>>>>
>>>>>> That commit was certainly in next-20130107.
>>>>>
>>>>> Could be bad config dependencies.
>>>>
>>>> Paul,
>>>>
>>>> You need to also select TRACE_CLOCK if you are going to use it.
>>>
>>> Thank you, Steve!
>>>
>>> Randy, does the following patch help?
>>>
>>> 							Thanx, Paul
>>
>> Hi Paul,
>>
>> This patch fixed the Jan. 7 linux-next build errors, but there is
>> still some similar problem with current linux-next (0114 and late
>> last week as well).
>>
>> ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> 
> Ah, my bad...
> 
> Does the following (rough and untested) patch help?

Yes, it helps, but there is still the same problem in
rcu_torture_reader() -- after that it builds OK.

Thanks.

> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index cd4c35d..36f0106 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1047,11 +1047,13 @@ static void rcu_torture_timer(unsigned long unused)
>  	static DEFINE_SPINLOCK(rand_lock);
>  	struct rcu_torture *p;
>  	int pipe_count;
> -	unsigned long long ts;
> +	unsigned long long ts = 0;
>  
>  	idx = cur_ops->readlock();
>  	completed = cur_ops->completed();
> +#ifdef CONFIG_RCU_TRACE
>  	ts = trace_clock_local();
> +#endif /* #ifdef CONFIG_RCU_TRACE */
>  	p = rcu_dereference_check(rcu_torture_current,
>  				  rcu_read_lock_bh_held() ||
>  				  rcu_read_lock_sched_held() ||
> 
> --


-- 
~Randy
