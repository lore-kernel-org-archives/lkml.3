Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3EaQd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:33:26 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:33961 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753627Ab3EaQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:33:09 -0400
Message-ID: <51A8D0C2.1080801@semaphore.gr>
Date: Fri, 31 May 2013 19:33:06 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
References: <51A7BFA6.3070800@semaphore.gr> <CAKohpo=oD9Wgr0Y9zA3aVCdMq5MUC5GESWyL45h=izRyp9-CLA@mail.gmail.com>
In-Reply-To: <CAKohpo=oD9Wgr0Y9zA3aVCdMq5MUC5GESWyL45h=izRyp9-CLA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050906090203090406020800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050906090203090406020800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/31/2013 11:51 AM, Viresh Kumar wrote:
>> ---
>>   arch/x86/include/asm/processor.h   | 29 ----------------------
>>   drivers/cpufreq/Makefile           |  2 +-
>>   drivers/cpufreq/acpi-cpufreq.c     |  5 ----
>>   drivers/cpufreq/cpufreq.c          | 21 ----------------
>>   drivers/cpufreq/cpufreq_governor.c | 10 +-------
>>   drivers/cpufreq/cpufreq_governor.h |  1 -
>>   drivers/cpufreq/cpufreq_ondemand.c | 39 ++++++-----------------------
>>   drivers/cpufreq/mperf.c            | 51 --------------------------------------
>>   drivers/cpufreq/mperf.h            |  9 -------
>>   include/linux/cpufreq.h            |  6 -----
>>   10 files changed, 9 insertions(+), 164 deletions(-)
>>   delete mode 100644 drivers/cpufreq/mperf.c
>>   delete mode 100644 drivers/cpufreq/mperf.h
> 
> I believe you should have removed other users of getavg() in a separate
> patch and also cc'd relevant people so that you can some review comments
> from  them.

I will split the patch in two. If it's OK, I will keep the removal of 
__cpufreq_driver_getavg in the original patch and move the clean up of
APERF/MPERF support in a second patch. I will also cc relevant people.


>>          /* Check for frequency increase */
>> -       if (load_freq > od_tuners->up_threshold * policy->cur) {
>> +       if (load > od_tuners->up_threshold) {
> 
> Chances of this getting hit are minimal now.. I don't know if keeping
> this will change anything now :)

Actually, no. This getting hit pretty often.
Please find attached the cpufreq statistics - trans_table during build
of 3.4 kernel. With default up_threshold (95), the transition to max
happened many times because of load was greater than up_threshold.
I also thought to keep this code to leave up_threshold functionality unaffected.
 
On 05/31/2013 03:42 PM, Rafael J. Wysocki wrote:
> On Friday, May 31, 2013 02:24:59 PM Viresh Kumar wrote:
>>> +       } else {
>>> +               /* Calculate the next frequency proportional to load */
>>>                  unsigned int freq_next;
>>> -               freq_next = load_freq / od_tuners->adj_up_threshold;
>>> +               freq_next = load * policy->max / 100;
>>
>> Rafael asked why you believe this is the right formula and I really couldn't
>> find an appropriate answer to that, sorry :(
> 
> Right, it would be good to explain that.
> 
> "Proportional to load" means C * load, so why is "policy->max / 100" *the* right C?
> 

I think, finally(?) I see your point. The right C should be "policy->cpuinfo.max_freq / 100".
This way the target frequency will be proportional to load and the calculation will
"map" the load to CPU freq table.

I will update the patch according to your observations and suggestions.

Thanks,
Stratos

--------------050906090203090406020800
Content-Type: text/plain; charset=UTF-8;
 name="trans_table.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="trans_table.txt"

   From  :    To
         :   3401000   3400000   3300000   3100000   3000000   2900000   2800000   2600000   2500000   2400000   2200000   2100000   2000000   1900000   1700000   1600000 
  3401000:         0         0         4         2         4         2         3         0         2         1         1         1         1         4         0        29 
  3400000:         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0 
  3300000:         4         0         0         0         1         0         0         0         0         0         0         1         0         0         0         7 
  3100000:         2         0         0         0         1         0         0         0         0         0         0         0         0         0         0         0 
  3000000:         4         0         0         0         0         0         0         0         0         1         0         0         0         0         0         4 
  2900000:         1         0         0         0         1         0         0         0         0         0         0         0         0         0         0         7 
  2800000:         3         0         0         0         0         1         0         0         0         1         0         0         0         0         0         3 
  2600000:         0         0         0         0         0         1         0         0         0         1         0         0         0         0         0         4 
  2500000:         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         4 
  2400000:         3         0         0         0         0         0         1         0         0         0         0         0         0         0         0         7 
  2200000:         1         0         0         0         0         0         0         0         0         1         0         0         0         0         0         3 
  2100000:         1         0         0         0         0         0         0         1         0         0         0         0         0         1         0         4 
  2000000:         1         0         0         0         0         0         0         0         0         0         0         0         0         0         0         1 
  1900000:         0         0         2         0         0         0         0         0         0         1         0         0         0         0         0         8 
  1700000:         0         0         0         0         0         0         0         0         0         0         0         0         0         0         0         2 
  1600000:        33         0         7         1         2         5         4         5         2         5         4         5         1         6         2         0 

--------------050906090203090406020800--
