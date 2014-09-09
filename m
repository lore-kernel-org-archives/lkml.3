Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaIIFdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:33:18 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:53372 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaIIFdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponb199_zt11M2J39yHn45MjFMSrT+hPBp7rbqiHu4vKpQ@mail.gmail.com>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org> <CAKohponb199_zt11M2J39yHn45MjFMSrT+hPBp7rbqiHu4vKpQ@mail.gmail.com>
From: Anup Chenthamarakshan <anupc@chromium.org>
Date: Mon, 8 Sep 2014 22:32:34 -0700
Message-ID: <CAN1Daczk+YT3ETviCL5d7xLGKzRL+AAo1z6rLs=r+j5+r45-xw@mail.gmail.com>
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 10:03 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 9 September 2014 05:40, Anup Chenthamarakshan <anupc@chromium.org> wrote:
>> Exported stats appear in
>> <sysfs>/devices/system/cpu/intel_pstate/time_in_state as follows:
>>
>> ## CPU 0
>> 400000 3647
>> 500000 24342
>> 600000 144150
>> 700000 202469
>> ## CPU 1
>> 400000 4813
>> 500000 22628
>> 600000 149564
>> 700000 211885
>> 800000 173890
>>
>> Signed-off-by: Anup Chenthamarakshan <anupc@chromium.org>
>> ---
>>  drivers/cpufreq/intel_pstate.c | 77 ++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 74 insertions(+), 3 deletions(-)
>
> Why don't we reuse cpufreq_stats.c for all this?

Thanks for taking a look into this.

I had initially tried reusing cpufreq_stats.c to export stats.
Calling cpufreq_stats_update() via the cpufreq notifier added
some amount of overhead while switching frequencies. Specifically,
looking up the index of the new frequency in freq_table_get_index()
is a linear search through all available frequencies (vs a single
subtraction with custom stats export). Also, the notifier mechanism
itself added a level of indirection before calling stats_update.

There is a 5X increase in time taken to complete intel_pstate_set_pstate
while using cpufreq_stats compared to having custom stats exported.
