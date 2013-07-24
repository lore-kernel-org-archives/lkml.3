Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3GXHvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:51:51 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:56720 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab3GXHvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <51EF8590.7030405@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
	<1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
	<CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
	<51EF2D06.7000704@samsung.com>
	<CAKohpok7B6DaqFPWZcODEgK5GRSoAQYZ27-h2=AQ1HBBP4gH8Q@mail.gmail.com>
	<51EF8590.7030405@samsung.com>
Date: Wed, 24 Jul 2013 13:21:48 +0530
Message-ID: <CAKohpomFf_mx7rfxEqW_EJWMx_+UHUYDDZ8Wc1fdeaTgZVwxKQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2013 13:13, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 07/24/2013 02:05 PM, Viresh Kumar wrote:
>> On 24 July 2013 06:55, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> On 07/22/2013 07:11 PM, Viresh Kumar wrote:
>>>> On 18 July 2013 16:47, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>
>>>>> +static void cpufreq_remove_debugfs_dir(struct cpufreq_policy *policy,
>>>>> +                                      unsigned int cpu)
>>>>> +{
>>>>> +       unsigned int idx = cpumask_weight(policy->cpus) > 1 ? cpu : 0;
>>>>> +
>>>>> +       if (!policy->cpu_debugfs[idx])
>>>>> +               return;
>>>>> +
>>>>> +       debugfs_remove_recursive(policy->cpu_debugfs[idx]);
>>>>
>>>> Whey do we need recursive here? And what exactly does recursive will
>>>> do?
>>>>
>>>
>>> If cpu is last user of policy, __cpufreq_remove_dev() have to remove debugfs directory
>>> and child file/directory of root debugfs directory. So, I used debugfs_remove_recursive() function.
>>
>> You are calling this routine even when we aren't at the last cpu of a policy.
>> And so, eventually you are calling this routine for a link you have created.
>
> I'll call proper debugfs_remove*() function according to type of debugfs pointer.
> - if cpu is last user of policy, call debugfs_remove_recursive()
> - else, call debugfs_remove().
>
>>
>> Have you actually tested your code? What kind of platform? What is cpu
>> topology ?? And what exactly you tested..
>
> I tested quad-core EXYNOS4412 SoC based on Cortex-A9 with Tizen platform.
> It is opereated on this environment but as you commnet, this test and environment
> isn't enough to verify this patchset.
> - Testcase1 : Change cpufreq governor on runtime
> - Testcase2 : Turn on/off CPU state on runtme
>
>>
>> We are already on v6 and this patch still looks like the v1.. It still has lots
>> of basic mistakes, which I don't expect so later in the series..
>>
>> Its very difficult for me to review the same patchset again and again.. So,
>> normally people might not review it well after v3-v4 and just trust the sender..
>> But I am nowhere close to getting that.. And so discouraged to review it..
>>
>
> I'm so sorry about this and thanks for previous your review sincerely.
>
>> Please review/test it well on multiple kind of systems if possible. Test on
>> your intel laptop and see if it has multiple policy structures with
>> multiple cpus
>> in it.. cpuX/cpufreq/related_cpus gives you all cpus that share policy
>> structure.
>
> As you comment, I'll modify/test this patchset on various system with enough testcase
> and resend this patchset after a thorough review.
>
>
>>
>>>>> +}
>>>>> +
>>>>
>>>> same problem here too.
>>>>> +static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
>>>>> +                                    unsigned int new_cpu)
>>>>> +{
>>>>> +       struct dentry *old_entry, *new_entry;
>>>>> +       char new_dir_name[CPUFREQ_NAME_LEN];
>>>>> +       unsigned int j, old_cpu = policy->cpu;
>>>>> +
>>>>> +       if (!policy->cpu_debugfs[new_cpu])
>>>>> +               return;
>>>>> +
>>>>> +       /*
>>>>> +        * Remove symbolic link of debugfs directory except for debugfs
>>>>> +        * directory of old_cpu.
>>>>> +        */
>>>>> +       for_each_present_cpu(j) {
>>>>> +               if (old_cpu == j)
>>>>> +                       continue;
>>>>> +
>>>>> +               debugfs_remove(policy->cpu_debugfs[j]);
>>>>
>>>> Why you need this? We aren't removing the earlier dentry at all here.
>>
>> haven't answered this.
>
> The debugfs entry of 'old_cpu' include child debugfs file(e.g., load_table)
> If cpu is last user of policy and core call __cpufre_remove_dev() to remove last cpu,
> core call cpufreq_move_debugfs_dir(). I have to move the data of debugfs directory/file and
> child data for 'old_cpu' to debugfs directory for 'new_cpu'.
>
> If I remove earlier dentry of 'old_cpu', I can't get the child debugfs dir/file.
> So I didn't remove the earlier dentry of 'old_cpu'.
>
>>
>>>>> +       if (!new_entry) {
>>>>> +               pr_err("changing debugfs directory name failed\n");
>>>>> +               goto err_rename;
>>>>> +       }
>>>>> +
>>>>> +       policy->cpu_debugfs[new_cpu] = new_entry;
>>>>> +       policy->cpu_debugfs[old_cpu] = NULL;
>>>>> +
>>>>> +       /* Create again symbolic link of debugfs directory */
>>>>> +       for_each_present_cpu(j) {
>>>>
>>>> present_cpu?? We discussed this before.. You will break multi cluster
>>>> systems.
>>>
>>> My mistake. I'll use for_each_cpu() macro instead of for_each_present_cpu().
>>
>> Go through earlier comments about this.. you are still wrong.. You need to
>> run over cpus that are in this policy.. i.e. policy->cpus.
>>
>
> OK.
>
>>>>> +               if (new_cpu == j)
>>>>> +                       continue;
>>>>> +
>>
>>>>> @@ -1894,6 +2065,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>>>>>         cpufreq_driver = driver_data;
>>>>>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>>>>>
>>>>> +       cpufreq_create_debugfs();
>>>>
>>>> Why you moved this to register_driver? It was fine at cpufreq_core_init()
>>>
>>> If we moved this to cpufreq_core_int(), I have to create cpufreq_core_exit().
>>> Do you agree about creating cpufreq_core_exit()(?
>>
>> No you don't need that routine. Or in other words there isn't any exit
>> for cpufreq core and so this directory must not be removed.
>>
>
> I understood on your previous comment as You said that I had to remove 'cpufreq' debugfs directory
> when cpufreq isn't used.
>
> If the core execute cpufreq_create_debugfs() in cpufreq_core_init(),
> don't I need to remove 'cpufreq' debugfs directory without cpufreq_core_exit()?

I copied following from your patch sent on 5th july.. It didn't had any version
number and so is difficult to distinguish..

> @@ -1976,6 +2029,10 @@ static int __init cpufreq_core_init(void)
>         BUG_ON(!cpufreq_global_kobject);
>         register_syscore_ops(&cpufreq_syscore_ops);
>
> +       cpufreq_debugfs = debugfs_create_dir("cpufreq", NULL);
> +       if (!cpufreq_debugfs)
> +               pr_debug("creating debugfs root failed\n");

So, you just added this directory once.. So you must not
remove it.


Where did I say you remove this directory..
To be clear, don't remove cpufreq debugfs directory at all. Play
only with cpu directories inside this debugfs directory.
