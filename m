Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaEBNV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:21:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:40848 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaEBNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:21:56 -0400
Message-ID: <53639BEF.60008@linutronix.de>
Date: Fri, 02 May 2014 15:21:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RT 2/2] rtmutex: Remove duplicate rt_mutex_init()
References: <20140409024700.702797305@goodmis.org>	<20140409025232.161960044@goodmis.org>	<20140502090831.GB9178@linutronix.de> <20140502091213.3ed4ba7b@gandalf.local.home>
In-Reply-To: <20140502091213.3ed4ba7b@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 03:12 PM, Steven Rostedt wrote:
>> This does not apply cleanly on v3.14-rt
> 
> That's because I sent this out before 3.14-rt was released :-)

Ach right. Sorry, my memory…

>>> --- a/include/linux/rtmutex.h
>>> +++ b/include/linux/rtmutex.h
>>> @@ -62,25 +62,19 @@ struct hrtimer_sleeper;
>>> # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
>>> 	, .name = #mutexname, .file = __FILE__, .line = __LINE__
>>>
>>> -# define rt_mutex_init(mutex)					\
>>> -	do {							\
>>> -		raw_spin_lock_init(&(mutex)->wait_lock);	\
>>> -		__rt_mutex_init(mutex, #mutex);			\
>>> -	} while (0)
>>> -
>>
>> The macro is the same in CONFIG_DEBUG_RT_MUTEXES and the else path.
>> Shouldn't you remove both and define it before the ifdef?
> 
> That's exactly what the patch did! Except that it defined it *after* the ifdef.
> 
> Here's the patch again (as it was cut in the reply):
> 
> --- a/include/linux/rtmutex.h
> +++ b/include/linux/rtmutex.h
> @@ -62,25 +62,19 @@ struct hrtimer_sleeper;
>  # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
>  	, .name = #mutexname, .file = __FILE__, .line = __LINE__
>  
> -# define rt_mutex_init(mutex)					\
> -	do {							\
> -		raw_spin_lock_init(&(mutex)->wait_lock);	\
> -		__rt_mutex_init(mutex, #mutex);			\
> -	} while (0)
> -
>   extern void rt_mutex_debug_task_free(struct task_struct *tsk);
>  #else
>  # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname)
>  
> +# define rt_mutex_debug_task_free(t)			do { } while (0)
> +#endif
> +
>  # define rt_mutex_init(mutex)					\
>  	do {							\
>  		raw_spin_lock_init(&(mutex)->wait_lock);	\
>  		__rt_mutex_init(mutex, #mutex);			\
>  	} while (0)
>  
> -# define rt_mutex_debug_task_free(t)			do { } while (0)
> -#endif
> -
>  #define __RT_MUTEX_INITIALIZER_PLAIN(mutexname) \
>  	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
>  	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \
> 
> Take special note of the movement of the "#endif".

Ah. That is the trick. So lets try it again…

> -- Steve

Sebastian
