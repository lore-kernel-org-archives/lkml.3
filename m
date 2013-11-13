Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab3KMJIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:08:17 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54571 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab3KMJIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:08:02 -0500
Message-ID: <5283416B.5000404@gmail.com>
Date: Wed, 13 Nov 2013 10:07:55 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface.
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>	<1383831828-15501-3-git-send-email-juri.lelli@gmail.com> <20131112123210.63d338d1@gandalf.local.home>
In-Reply-To: <20131112123210.63d338d1@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 06:32 PM, Steven Rostedt wrote:
> On Thu,  7 Nov 2013 14:43:36 +0100
> Juri Lelli <juri.lelli@gmail.com> wrote:
> 
>   
>> +static int
>> +do_sched_setscheduler2(pid_t pid, int policy,
>> +			 struct sched_param2 __user *param2)
>> +{
>> +	struct sched_param2 lparam2;
>> +	struct task_struct *p;
>> +	int retval;
>> +
>> +	if (!param2 || pid < 0)
>> +		return -EINVAL;
>> +
>> +	memset(&lparam2, 0, sizeof(struct sched_param2));
>> +	if (copy_from_user(&lparam2, param2, sizeof(struct sched_param2)))
>> +		return -EFAULT;
> 
> Why the memset() before the copy_from_user()? We are copying
> sizeof(sched_param2) anyway, and should overwrite anything that was on
> the stack. I'm not aware of any possible leak from copying from
> userspace. I could understand it if we were copying to userspace.
> 
> do_sched_setscheduler() doesn't do that either.
> 
>> +
>> +	rcu_read_lock();
>> +	retval = -ESRCH;
>> +	p = find_process_by_pid(pid);
>> +	if (p != NULL)
>> +		retval = sched_setscheduler2(p, policy, &lparam2);
>> +	rcu_read_unlock();
>> +
>> +	return retval;
>> +}
>> +
>>  /**
>>   * sys_sched_setscheduler - set/change the scheduler policy and RT priority
>>   * @pid: the pid in question.
>> @@ -3514,6 +3553,21 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
>>  }
>>  
>>  /**
>> + * sys_sched_setscheduler2 - same as above, but with extended sched_param
>> + * @pid: the pid in question.
>> + * @policy: new policy (could use extended sched_param).
>> + * @param: structure containg the extended parameters.
>> + */
>> +SYSCALL_DEFINE3(sched_setscheduler2, pid_t, pid, int, policy,
>> +		struct sched_param2 __user *, param2)
>> +{
>> +	if (policy < 0)
>> +		return -EINVAL;
>> +
>> +	return do_sched_setscheduler2(pid, policy, param2);
>> +}
>> +
>> +/**
>>   * sys_sched_setparam - set/change the RT priority of a thread
>>   * @pid: the pid in question.
>>   * @param: structure containing the new RT priority.
>> @@ -3526,6 +3580,17 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
>>  }
>>  
>>  /**
>> + * sys_sched_setparam2 - same as above, but with extended sched_param
>> + * @pid: the pid in question.
>> + * @param2: structure containing the extended parameters.
>> + */
>> +SYSCALL_DEFINE2(sched_setparam2, pid_t, pid,
>> +		struct sched_param2 __user *, param2)
>> +{
>> +	return do_sched_setscheduler2(pid, -1, param2);
>> +}
>> +
>> +/**
>>   * sys_sched_getscheduler - get the policy (scheduling class) of a thread
>>   * @pid: the pid in question.
>>   *
>> @@ -3595,6 +3660,45 @@ out_unlock:
>>  	return retval;
>>  }
>>  
>> +/**
>> + * sys_sched_getparam2 - same as above, but with extended sched_param
>> + * @pid: the pid in question.
>> + * @param2: structure containing the extended parameters.
>> + */
>> +SYSCALL_DEFINE2(sched_getparam2, pid_t, pid,
>> +		struct sched_param2 __user *, param2)
>> +{
>> +	struct sched_param2 lp;
>> +	struct task_struct *p;
>> +	int retval;
>> +
>> +	if (!param2 || pid < 0)
>> +		return -EINVAL;
>> +
>> +	rcu_read_lock();
>> +	p = find_process_by_pid(pid);
>> +	retval = -ESRCH;
>> +	if (!p)
>> +		goto out_unlock;
>> +
>> +	retval = security_task_getscheduler(p);
>> +	if (retval)
>> +		goto out_unlock;
>> +
>> +	lp.sched_priority = p->rt_priority;
>> +	rcu_read_unlock();
>> +
> 
> OK, now we are missing the memset(). This does leak info, as lp never
> was set to zero, it just contains anything on the stack, and the only
> value you updated was sched_priority. We just copied to user memory
> from the kernel stack.

Right! memset() moved:

@@ -3779,7 +3779,6 @@ do_sched_setscheduler2(pid_t pid, int policy,
        if (!param2 || pid < 0)
                return -EINVAL;

-       memset(&lparam2, 0, sizeof(struct sched_param2));
        if (copy_from_user(&lparam2, param2, sizeof(struct sched_param2)))
                return -EFAULT;

@@ -3937,6 +3936,8 @@ SYSCALL_DEFINE2(sched_getparam2, pid_t, pid,
        if (!param2 || pid < 0)
                return -EINVAL;

+       memset(&lp, 0, sizeof(struct sched_param2));
+
        rcu_read_lock();
        p = find_process_by_pid(pid);
        retval = -ESRCH;

Thanks,

- Juri

> 
>> +	retval = copy_to_user(param2, &lp,
>> +			sizeof(struct sched_param2)) ? -EFAULT : 0;
>> +
>> +	return retval;
>> +
>> +out_unlock:
>> +	rcu_read_unlock();
>> +	return retval;
>> +
>> +}
>> +
>>  long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>>  {
>>  	cpumask_var_t cpus_allowed, new_mask;
> 
