Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3IJQcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:32:39 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46068 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3IJQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:32:38 -0400
Message-ID: <522F49A3.5000700@linaro.org>
Date: Tue, 10 Sep 2013 09:32:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] seqcount: Add lockdep functionality to seqcount/seqlock
 structures
References: <1378788166-18474-1-git-send-email-john.stultz@linaro.org> <20130910085545.GM26785@twins.programming.kicks-ass.net>
In-Reply-To: <20130910085545.GM26785@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 01:55 AM, Peter Zijlstra wrote:
> On Mon, Sep 09, 2013 at 09:42:46PM -0700, John Stultz wrote:
>> @@ -38,10 +39,58 @@
>>   */
>>  typedef struct seqcount {
>>  	unsigned sequence;
>> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
>> +	struct lockdep_map dep_map;
>> +#endif
>>  } seqcount_t;
>>  
>> -#define SEQCNT_ZERO { 0 }
>> -#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
>> +
>> +
>> +
>> +static inline void __seqcount_init(seqcount_t *s, const char *name,
>> +					  struct lock_class_key *key)
>> +{
>> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
>> +	/*
>> +	 * Make sure we are not reinitializing a held lock:
>> +	 */
>> +	lockdep_init_map(&s->dep_map, name, key, 0);
>> +#endif
>> +	s->sequence = 0;
>> +}
>> +
>> +
>> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
>> +# define SEQCOUNT_DEP_MAP_INIT(lockname) \
>> +		.dep_map = { .name = #lockname } \
>> +
>> +# define seqcount_init(s)				\
>> +	do {						\
>> +		static struct lock_class_key __key;	\
>> +		__seqcount_init((s), #s, &__key);	\
>> +	} while (0)
>> +
>> +static inline void seqcount_reader_access(const seqcount_t *s)
>> +{
>> +	seqcount_t *l = (seqcount_t *)s;
>> +	unsigned long flags;
>> +
>> +	preempt_disable();
>> +	local_irq_save(flags);
>> +	seqcount_acquire_read(&l->dep_map, 0, 0, _RET_IP_);
>> +	seqcount_release(&l->dep_map, 1, _RET_IP_);
>> +	local_irq_restore(flags);
>> +	preempt_enable();
>> +}
> Why the preempt and local_irq thing? Also preempt_disable is quite
> superfluous if you do local_irq_disable().

So since reader->writer recurision is ok, as is reader->reader
recurision, I wanted to avoid lockdep false positives if an irq lands in
between the aquire/release calls. So by doing the acquire/release w/
irqs off on the read side, we only trap the writer->reader recursion issues.

And agreed, the preempt_disable is overdoing it :)

Thanks for the review!
-john

