Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3F0KXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:23:51 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52255 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3F0KXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <51CC1099.5060201@samsung.com>
References: <1372064549-5872-1-git-send-email-cw00.choi@samsung.com>
	<CAKohpokvK0fBbfH_L8DETpMPr9UKzTtRRnzOzHOrHmX=NC-jDg@mail.gmail.com>
	<51CC1099.5060201@samsung.com>
Date: Thu, 27 Jun 2013 15:53:49 +0530
Message-ID: <CAKohpo=oZS8U1ZZ4Kbiz2yf_LLEMTr5HsrWFt_LiBkmRqKfdvQ@mail.gmail.com>
Subject: Re: [PATCH v3] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 June 2013 15:44, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 06/26/2013 05:04 PM, Viresh Kumar wrote:
>> On 24 June 2013 14:32, Chanwoo Choi <cw00.choi@samsung.com> wrote:

>> Maybe 10 to 1000.. Lets give others a chance to see long logs :)
>>
>
> OK, I'll extend the maximum value from 100 to 1000.

10-1000 please.

>>> +       freq.old = freq.new = policy->cur;
>>
>> No need to set freq.new here.
>
> If cpufreq governor don't change cpu frequency on specific situation,
> cpufreq SoC driver won't send CPUFREQ_POSTCHANGE. In case of this situation,
> I store current cpu frequency to freq.new field.

You are doing this at the time of LOADCHECK notification :)

               stat->load_table[last_idx].new = freq->old;

>>> +static ssize_t load_table_read(struct file *file, char __user *user_buf,
>>> +                                       size_t count, loff_t *ppos)
>>> +{
>>> +       struct cpufreq_policy *policy = file->private_data;
>>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
>>> +       struct cpufreq_freqs *load_table = stat->load_table;
>>> +       ssize_t len = 0;
>>> +       char *buf;
>>> +       int i, cpu, ret;
>>> +
>>> +       buf = kzalloc(MAX_LINE_SIZE * stat->load_max_index, GFP_KERNEL);
>>> +       if (!buf)
>>> +               return 0;
>>
>> Above use of stat->load_max_index must be inside locks I guess. Otherwise
>> you may allocate memory for 10 lines and by the time lock is taken, we
>> already have 12 entries. And so, below loop will go beyond array limits.
>>
>
> I store CONFIG_NR_CPU_LOAD_STORAGE to stat->load_max_index in cpufreq_stats_create_debugfs()
> So, stat->load_max_index value isn't always 10.
>
> If I misunderstood for your comment, I'd like you to explain more detailed about this comment.

No you didn't but looking second time at the code, i couldn't find a
problem with it.

You allocate memory for max entries and so shouldn't be a problem.
