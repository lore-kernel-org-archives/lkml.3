Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3EUHwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:52:23 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60409 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3EUHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:52:22 -0400
Message-ID: <519B26FD.9080404@linux.vnet.ibm.com>
Date: Tue, 21 May 2013 13:19:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: anish singh <anish198519851985@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>
Subject: Re: [RFC PATCH 6/8] kthread: Enable parking requests from setup()
 and unpark() callbacks
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com> <1369065716-22801-7-git-send-email-fweisbec@gmail.com> <CAK7N6voNjWrDJNzAaVAndt8cGWR+AAERs_C-oCWe0rRO=XuutQ@mail.gmail.com>
In-Reply-To: <CAK7N6voNjWrDJNzAaVAndt8cGWR+AAERs_C-oCWe0rRO=XuutQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052107-2674-0000-0000-0000090C8C94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 11:04 AM, anish singh wrote:
> On Mon, May 20, 2013 at 9:31 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> When the watchdog code is boot-disabled by the user, for example
>> through the 'nmi_watchdog=0' boot option, the setup() callback of
>> the watchdog kthread requests to park the task, and that until the
>> user later re-enables the watchdog through sysctl or procfs.
>>
>> However the parking request is not well handled when done from
>> the setup() callback. After ->setup() is called, the generic smpboot
>> kthread loop directly tries to call the thread function or wait
>> for some event if ->thread_should_run() is false.
>>
>> In the case of the watchdog kthread, ->thread_should_run() returns
>> false and the kthread goes to sleep and wait for the watchdog timer
>> to wake it up. But the timer is not enabled since the user requested
>> to disable the watchdog. We want the kthread to park instead of waiting
>> for events that can't happen.
>>
>> As a result, later unpark requests after sysctl write through
>> 'sysctl -w kernel.watchdog=1' won't wake up/unpark the task as
>> expected, since it's not parked anyway, leaving the value modified
>> without triggering any action.
> Out of curiosity, this can happen only for short period of time right?After
> some time this will work right as the thread get back in action
> after the schedule call.Then sysctl and procfs will work I think.

kthread_unpark() can wake up a task only if the task is in TASK_PARKED
state. But since the above task would be in TASK_INTERRUPTIBLE state 
(since it is not parked), kthread_unpark() will be powerless to do anything.

Regards,
Srivatsa S. Bhat

