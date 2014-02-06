Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaBFLNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:13:24 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39277 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbaBFLNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:13:23 -0500
Message-ID: <52F36D11.5030200@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 16:38:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/51] CPU hotplug: Fix issues with callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140206093833.GA8105@in.ibm.com> <52F36C41.2070700@linux.vnet.ibm.com>
In-Reply-To: <52F36C41.2070700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020611-9574-0000-0000-00000BD131B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 04:34 PM, Srivatsa S. Bhat wrote:
> On 02/06/2014 03:08 PM, Gautham R Shenoy wrote:
>> Hi,
>>
>> On Thu, Feb 06, 2014 at 03:34:36AM +0530, Srivatsa S. Bhat wrote:
>>> Hi,
>>>
[...]
>> Couple of comments:
>>
>> Right now, cpu_add_remove_lock is being used to 
>> 1) Serialize the cpu-hotplug writers.
>>
>> 2) Serialize accesses to cpu_present/possible_map.
>>
>> 3) Serialize updates to the cpu_chain (the cpu hotplug notifier chain).  
>>
>>    - This is necessary to ensure that registration of notifiers and
>>      invocation of CPU_POST_DEAD notifications don't race with each
>>      other.  Else we could have used get/put_online_cpus() in
>>      register_cpu_notifier() and this patch series wouldn't have been
>>      necessary.
>>
>> 4) Bulk cpu-hotplug (disable/enable_non_boot_cpus), but this is a
>> special case of 1).
>>
>> CPU_POST_DEAD notification, is invoked with the cpu_hotplug.lock
>> dropped. This was necessary for subsystems which would be waiting for
>> some other thread to finish some work, and that other thread could
>> invoke get_online_cpus(). If CPU_POST_DEAD notification were issued
>> without dropping the cpu_hotplug.lock, this would lead to a deadlock
>> as the notifier would be left stuck waiting for the thread which is
>> blocked in get_online_cpus().
>>
>> It was introduced to ensure that multithreaded workqueues can safely
>> use get_online_cpus() [https://lkml.org/lkml/2008/6/29/121].
>>
>> As of now, only two subsystems use this notification and workqueues is
>> _not_ one of them!
>>   * arch/x86/kernel/cpu/mcheck/mce.c:mce_cpu_callback()
>>   * drivers/cpufreq/cpufreq.c:cpufreq_cpu_callback()
>> I haven't yet audited these two cases to see if they really need this
>> to be handled in CPU_POST_DEAD or if they can be handled in CPU_DEAD.
>>
> 
> Well, cpufreq had a legitimate need to use POST_DEAD to avoid the
> deadlock described in commit 1aee40ac9c. However, there had been some
> discussion some time ago about reorganizing the cpufreq's hotplug callback
> so as to move most (but not all) of its work outside of POST_DEAD [1].

Forgot to give the link.. Here it is:
http://article.gmane.org/gmane.linux.kernel/1571276

Regards,
Srivatsa S. Bhat

