Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3COBeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:34:15 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41701 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3COBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:34:14 -0400
Message-ID: <514278C2.3020900@gmail.com>
Date: Fri, 15 Mar 2013 09:26:26 +0800
From: Shuge <shugelinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Kevin <kevin@allwinnertech.com>,
        linux-serial@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [BUG]: when printk too more through serial, cpu up is failed.
References: <5141D5E6.4060001@gmail.com> <20130314140553.GA4895@kroah.com>
In-Reply-To: <20130314140553.GA4895@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月14日 22:05, Greg KH 写道:
> On Thu, Mar 14, 2013 at 09:51:34PM +0800, Shuge wrote:
>> Hi all,
>>      When the kernel printk too many log, the cpu is failed to come online.
>> The problem is this:
>> For example, cpu0 bring up cpu1:
>>
>>        a. cpu0 call cpu_up:
>>           cpu_up()
>>           ->_cpu_up()
>>              ->__cpu_notify(CPU_UP_PREPARE)
>>              ->__cpu_up()
>>                 ->boot_secondary()
>> #       ->wait_for_completion_timeout(&cpu_running, msecs_to_jiffires(1000))
>>           -> if (!cpu_online(cpu)) {
>>                    pr_crit("CPU%u: failed to come online\n", cpu);
>>                    ret = -EIO;
>>                }
>>           ->cpu_notify(CPU_ONLINE)
>>
>>        b. cpu1 enter kernel:
>>        secondary_start_kernel()
>> @   ->printk("CPU%u: Booted secondary processor\n", cpu)
>> *   ->calibrate_delay()
>>        ->set_cpu_online()
>>        ->complete(cpu_running)
>>          ->cpumask_set_cpu()
>>
>>     While cpu0 run to mark #,  which wait that cpu1 complete
>> cpu_running, and set online.
>> Generally, cpu0 can get it. But if the __log_buf is too large or
>> other threads write
>> it unceasing, then cpu1 come to mark @ or * in this moment. Cpu1 is
>> busy outputing
>> buffer, which cost time more than 1s, and cpu1 have not join in
>> sched, so cpu0 wait it timeout.
>>     By reading printk.c, I found that can_use_console() always return
>> true, which be called by
>> console_trylock_for_printk(). Because, have_callable_console()
>> return ture always, if the console
>> driver set CON_ANYTIME flag. I think that cpu should not output the
>> __log_buf in coming online,
>> even though have_callable_console() is true.
>>
>> /*
>>   * Can we actually use the console at this time on this cpu?
>>   *
>>   * Console drivers may assume that per-cpu resources have
>>   * been allocated. So unless they're explicitly marked as
>>   * being able to cope (CON_ANYTIME) don't call them until
>>   * this CPU is officially up.
>>   */
>> static inline int can_use_console(unsigned int cpu)
>> {
>>      return cpu_online(cpu) || have_callable_console();
>> }
>>
>> In can_use_console, why not is &&, but ||?
>>
>> Kernel Version: 3.3.0
> Why such an old and obsolete kernel version?  Please try this on 3.8,
> lots of work have gone into the printk area that should have solved this
> issue.
>
> greg k-h

I saw the printk.c in version 3.9, it still check 
console_trylock_for_printk() to decide to call console_unlock. In 
vprintk_emit(), cpu1 also have the opportunity to execute 
console_unlock() at coming online time.
Once cpu which is coming online can output buffer, nothing can interrupt 
it until buffer is empty.But we can't ensure that none always write the 
__log_buf. It is danger! I think, the solution is that we should prevent 
to use console at coming online.
