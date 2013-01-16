Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab3APKnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:43:50 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40235 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045Ab3APKmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:42:35 -0500
Message-ID: <50F683D9.1080908@linux.vnet.ibm.com>
Date: Wed, 16 Jan 2013 16:11:29 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ivo Sieben <meltedpianoman@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
 queue is active
References: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com> <50E3FDFA.4070203@suse.cz>	<20130102114311.66215bf5@pyramind.ukuu.org.uk> <CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com> <50E4854E.8060801@suse.cz> <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com> <50F66120.50704@linux.vnet.ibm.com> <CAMSQXEE=Qp8kVcEp8nBhNDmOaDMUQUUou+5Z2f8-1znykqy6mQ@mail.gmail.com>
In-Reply-To: <CAMSQXEE=Qp8kVcEp8nBhNDmOaDMUQUUou+5Z2f8-1znykqy6mQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011610-1396-0000-0000-0000026C4397
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivo,

On 01/16/2013 02:46 PM, Ivo Sieben wrote:
> Hi Preeti,
> 
> 2013/1/16 Preeti U Murthy <preeti@linux.vnet.ibm.com>:
>> Hi Ivo,
>> Can you explain how this problem could create a scheduler overhead?
>> I am a little confused, because as far as i know,scheduler does not come
>> in the picture of the wake up path right? select_task_rq() in
>> try_to_wake_up() is where the scheduler comes in,and this is after the
>> task wakes up.
>>
> 
> Everytime the line discipline is dereferenced, the wakeup function is
> called. The wakeup() function contains a critical section protected by
> spinlocks. On a PREEMPT_RT system, a "normal" spinlock behaves just
> like a mutex: scheduling is not disabled and it is still possible that
> a new process on a higher RT priority is scheduled in. When a new -
> higher priority - process is scheduled in just when the put_ldisc() is
> in the critical section of the wakeup function, the higher priority
> process (that uses the same TTY instance) will finally also
> dereference the line discipline and try to wakeup the same waitqueue.
> This causes the high priority process to  block on the same spinlock.
> Priority inheritance will solve this blocked situation by a context
> switch to the lower priority process, run until that process leaves
> the critical section, and a context switch back to the higher priority
> process. This is unnecessary since the waitqueue was empty after all
> (during normal operation the waitqueue is empty most of the time).
> This unnecessary context switch from/to the high priority process is
> what a mean with "scheduler overhead" (maybe not a good name for it,
> sorry for the confusion).
> 
> Does this makes sense to you?

Yes.Thank you very much for the explanation :) But I dont see how the
context switching goes away with your patch.With your patch, when the
higher priority thread comes in when the lower priority thread is
running in the critical section,it will see the wait queue empty and
"continue its execution" without now wanting to enter the critical
section.So this means it will preempt the lower priority thread because
it is not waiting on a lock anyway.There is a context switch here right?
I dont see any problem in scheduling due to this,but I do think your
patch is essential.

The entire logic of
wakelist_active()
  wake_up()

could be integrated into wake_up(). I dont understand why we need a
separate function to check the emptiness of the wake list. But as Oleg
pointed out we must identify the places for this optimization.

Regards
Preeti U Murthy

