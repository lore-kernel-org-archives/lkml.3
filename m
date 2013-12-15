Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3LOOqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 09:46:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:55695 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3LOOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 09:46:42 -0500
Date: Sun, 15 Dec 2013 15:46:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] make migrate disable/enable conditioned on
 softirq_nestcnt transition
Message-ID: <20131215144639.GG31090@linutronix.de>
References: <20131205234222.GE15603@opentech.at>
 <20131205194530.1c086844@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131205194530.1c086844@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-12-05 19:45:30 [-0500]:

>On Fri, 6 Dec 2013 00:42:22 +0100
>Nicholas Mc Guire <der.herr@hofr.at> wrote:
>> --- a/kernel/softirq.c
>> +++ b/kernel/softirq.c
>> @@ -569,8 +569,8 @@ static void do_current_softirqs(int need_rcu_bh_qs)
>>  
>>  void local_bh_disable(void)
>>  {
>> -	migrate_disable();
>> -	current->softirq_nestcnt++;
>> +	if (++current->softirq_nestcnt == 1)
>> +		migrate_disable();
>>  }
>>  EXPORT_SYMBOL(local_bh_disable);
>>  
>> @@ -584,8 +584,8 @@ void local_bh_enable(void)
>>  		do_current_softirqs(1);
>>  	local_irq_enable();
>>  
>> -	current->softirq_nestcnt--;
>> -	migrate_enable();
>> +	if (--current->softirq_nestcnt == 0)
>> +		migrate_enable();
>
>I wonder if we should add a:
>
>	BUG_ON(current->softirq_nestcnt < 0);

We have a WARN_ON() in each enable path. That one in local_bh_enable()
isn't part of the context here. If you want to s/WARN_/BUG_/ then I
would prefer not to since there are a few people with no UART and this
could break the system while the current sollution keeps the system
running.

>As for the patch, I haven't found anything wrong with it.
>
>Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Thanks.

Sebastian
