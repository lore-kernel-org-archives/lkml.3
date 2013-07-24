Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3GXIvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:51:13 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40759 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3GXIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <51EF945E.3080802@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
	<1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
	<CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
	<51EF2D06.7000704@samsung.com>
	<CAKohpok7B6DaqFPWZcODEgK5GRSoAQYZ27-h2=AQ1HBBP4gH8Q@mail.gmail.com>
	<51EF8590.7030405@samsung.com>
	<CAKohpom19C7JHSX6w31pSDrwcAR_PZn1HzP0Jui5iZL=bALDPQ@mail.gmail.com>
	<51EF945E.3080802@samsung.com>
Date: Wed, 24 Jul 2013 14:21:09 +0530
Message-ID: <CAKohpo=_3iR44XfxuRAmw-9DDk9APniWH=efd72v845wH3C-DQ@mail.gmail.com>
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

On 24 July 2013 14:16, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> In case that all CPUs share same cpufreq policy. Each debugfs dentry of CPU[1-3]
> except for CPU0 has symbolic link to CPU0's debugfs directory as following.
>
> -sh-4.1# ls -al /sys/kernel/debug/cpufreq/
> total 0
> drwxr-xr-x  3 root root 0 Jan  1 09:00 .
> drwx------ 28 root root 0 Jan  1 09:00 ..
> drwxr-xr-x  2 root root 0 Jan  1 09:00 cpu0             (policy->cpu is 0)
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu1 -> ./cpu0
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu2 -> ./cpu0
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu3 -> ./cpu0
>
> If turn off CPU0 state, I have to move debugfs directory data from cpu0 to cpu1
> and again create link to cpu1's debugfs directory for CPU[2-3] debugfs directory.
> So, I removed dentry link of CPU[1-3] before creating link again.
>
> cpu1
> cpu2 -> ./cpu1
> cpu3 -> ./cpu1
>
> But I can rewrite new link of CPU[2-3] to previous dentry link(policy->cpu_debugfs[2] or policy->cpu_debugfs[3])
> for reducing unnecessary code without revmoval sequence.

Because we aren't freeing the debugfs node at all (just renaming
it), the links might still be good after renaming.. But please check
if it is true.

So, according to me you need to do this:
- Remove symlink for new policy->cpu, i..e cpu1 in your example
- rename debugfs entry to give it to cpu1 instead of cpu0.
- Set cpu0 pointer to NULL.

Probably that's it.
