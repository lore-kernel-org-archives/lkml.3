Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3ETKYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:24:38 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63547 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3ETKYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:24:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomjuv6G6Qj2YLv=j=pjASx=6vAaUOzd6gJ-NA2PBhOZAg@mail.gmail.com>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
	<20130509125040.GF27333@pd.tnic>
	<20130509125859.GG27333@pd.tnic>
	<20130515184528.GO4442@linux.vnet.ibm.com>
	<20130515224358.GF11783@pd.tnic>
	<20130515235512.GT4442@linux.vnet.ibm.com>
	<20130517135641.GF23035@pd.tnic>
	<51999591.8030401@linux.vnet.ibm.com>
	<20130520045023.GA12690@pd.tnic>
	<CAFTL4hwm4Cox=ynVcO-oLG=Jt_1Lro+hbcpEE5hiAYEJGipaLA@mail.gmail.com>
	<5199ED83.5040804@linux.vnet.ibm.com>
	<CAKohpomjuv6G6Qj2YLv=j=pjASx=6vAaUOzd6gJ-NA2PBhOZAg@mail.gmail.com>
Date: Mon, 20 May 2013 15:54:35 +0530
Message-ID: <CAKohponAkh4ZHSp_NwCSK8B0bS_sh3ttUugDQwboo98p6unWnw@mail.gmail.com>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2013 15:10, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 May 2013 15:01, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> And Viresh, in the regular hotplug paths, the call to gov_cancel_work() is
>> supposed to kill any pending workqueue functions pertaining to offline CPUs
>> right?
>
> Yes.. It will cancel work for all cpus first and will start again for
> online cpus again.
>
>> Could there be a synchronization bug somewhere due to which this
>> might not be happening properly?
>
> Not sure.. I have seen mutex's are used well in cpufreq_governor.. don't know
> if I missed something.

Borislav,

Can you try below change to see if the issue is still present? (Untested)

diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index 7532570..b9ae5f6 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -359,7 +359,9 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
                if (dbs_data->cdata->governor == GOV_CONSERVATIVE)
                        cs_dbs_info->enable = 0;

+               mutex_lock(&cpu_cdbs->timer_mutex);
                gov_cancel_work(dbs_data, policy);
+               mutex_unlock(&cpu_cdbs->timer_mutex);

                mutex_lock(&dbs_data->mutex);
                mutex_destroy(&cpu_cdbs->timer_mutex);
