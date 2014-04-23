Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaDWUoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaDWUof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:44:35 -0400
Message-ID: <53582610.7000109@redhat.com>
Date: Wed, 23 Apr 2014 16:44:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, joern@logfs.org, peterz@infradead.org,
        cxie@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
References: <20140423125352.704f9fb2@annuminas.surriel.com> <20140423130453.32361ca9ceef591b9b184926@linux-foundation.org>
In-Reply-To: <20140423130453.32361ca9ceef591b9b184926@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:04 PM, Andrew Morton wrote:
> On Wed, 23 Apr 2014 12:53:52 -0400 Rik van Riel <riel@redhat.com> wrote:
> 
>> Echoing values into /proc/sysrq-trigger seems to be a popular way to
>> get information out of the kernel. However, dumping information about
>> thousands of processes, or hundreds of CPUs to serial console can
>> result in IRQs being blocked for minutes, resulting in various kinds
>> of cascade failures.
>>
>> The most common failure is due to interrupts being blocked for a very
>> long time. This can lead to things like failed IO requests, and other
>> things the system cannot easily recover from.
> 
> I bet nobody wants that console output anyway.  You do the sysrq then
> run dmesg or look in /var/log/messages to see what happened.  People
> who are experiencing problems such as this should run `dmesg -n 1'
> before writing to sysrq-trigger.

I'm not sure about that. I know of a few hundred QA people who
gather the bulk of their logs through serial console, and they
do appear interested in sysrq output :)

>> It also leaves sysrq-from-irq-context when the sysrq keys are pressed,
>> but that is probably desired since people want that to work in situations
>> where the system is already hosed.
>>
>> The callers of register_sysrq_key and unregister_sysrq_key appear to be
>> capable of sleeping.
> 
> unregister_sysrq_key() is basically never used - a couple of scruffy
> drivers during rmmod.  We hardly need any locking in there at all.  I
> guess using simple RCU is better than just removing it though.

Yeah, I went with the "solve the easy 90%" aspect with this
patch.  I am not convinced that we want to complicate the
sysrq code to better support a fringe use case, but if we
can fix the big without increasing the code maintenance
burden in the future, why not?

>> --- a/drivers/tty/sysrq.c
>> +++ b/drivers/tty/sysrq.c
>> @@ -510,9 +510,8 @@ void __handle_sysrq(int key, bool check_mask)
>>  	struct sysrq_key_op *op_p;
>>  	int orig_log_level;
>>  	int i;
>> -	unsigned long flags;
>>  
>> -	spin_lock_irqsave(&sysrq_key_table_lock, flags);
>> +	rcu_read_lock();
>>  	/*
>>  	 * Raise the apparent loglevel to maximum so that the sysrq header
>>  	 * is shown to provide the user with positive feedback.  We do not
>> @@ -554,7 +553,7 @@ void __handle_sysrq(int key, bool check_mask)
>>  		printk("\n");
>>  		console_loglevel = orig_log_level;
>>  	}
>> -	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
>> +	rcu_read_unlock();
>>  }
>>  
>>  void handle_sysrq(int key)
>> @@ -1043,16 +1042,23 @@ static int __sysrq_swap_key_ops(int key, struct sysrq_key_op *insert_op_p,
>>                                  struct sysrq_key_op *remove_op_p)
>>  {
>>  	int retval;
>> -	unsigned long flags;
>>  
>> -	spin_lock_irqsave(&sysrq_key_table_lock, flags);
>> +	spin_lock(&sysrq_key_table_lock);
>>  	if (__sysrq_get_key_op(key) == remove_op_p) {
>>  		__sysrq_put_key_op(key, insert_op_p);
>>  		retval = 0;
>>  	} else {
>>  		retval = -1;
>>  	}
>> -	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
>> +	spin_unlock(&sysrq_key_table_lock);
>> +
>> +	/*
>> +	 * A concurrent __handle_sysrq eitehr got the old op or the new op.
> 
> yuo cnat spel

I can fix that for version 2, assuming people are interested it a v2 :)

>> +	 * Wait for it to go away before returning, so the code for an old
>> +	 * op is not freed (eg. on module unload) while it is in use.
>> +	 */
>> +	synchronize_rcu();
>> +
>>  	return retval;
>>  }
> 


-- 
All rights reversed
