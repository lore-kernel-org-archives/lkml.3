Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaJBNtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:49:12 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47893 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751815AbaJBNtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:49:09 -0400
Message-ID: <542D57D0.4030904@hurleysoftware.com>
Date: Thu, 02 Oct 2014 09:49:04 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        oleg@redhat.com
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net>
In-Reply-To: <20141002124247.GD6324@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 08:42 AM, Peter Zijlstra wrote:
> On Thu, Oct 02, 2014 at 02:31:50PM +0200, Peter Zijlstra wrote:
>> @@ -2086,24 +2086,22 @@ static void rfcomm_kill_listener(void)
>>  
>>  static int rfcomm_run(void *unused)
>>  {
>> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>  	BT_DBG("");
>>  
>>  	set_user_nice(current, -10);
>>  
>>  	rfcomm_add_listener(BDADDR_ANY);
>>  
>> -	while (1) {
>> -		set_current_state(TASK_INTERRUPTIBLE);
>> -
>> -		if (kthread_should_stop())
>> -			break;
>> +	add_wait_queue(&rfcomm_wq, &wait);
>> +	while (!kthread_should_stop()) {
>>  
>>  		/* Process stuff */
>>  		rfcomm_process_sessions();
>>  
>> -		schedule();
>> +		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
>>  	}
>> -	__set_current_state(TASK_RUNNING);
>> +	remove_wait_queue(&rfcomm_wq, &wait);
>>  
>>  	rfcomm_kill_listener();
>>  
> 
> Hmm, I think there's a problem there. If someone were to do
> kthread_stop() before wait_woken() we'd not actually stop, because
> wait_woken() doesn't test KTHREAD_SHOULD_STOP before calling schedule().

Do you mean this situation?

CPU 0                                    | CPU 1
                                         |
rfcomm_run()                             | kthread_stop()
  ...                                    |
  if (!test_bit(KTHREAD_SHOULD_STOP))    |
                                         |   set_bit(KTHREAD_SHOULD_STOP)
                                         |   wake_up_process()
    wait_woken()                         |   wait_for_completion()
      set_current_state(INTERRUPTIBLE)   |
      if (!WQ_FLAG_WOKEN)                |
        schedule_timeout()               |
                                         |

Now both tasks are sleeping forever.

If yes, then wakeups from signals don't work either, right?

Regards,
Peter Hurley
