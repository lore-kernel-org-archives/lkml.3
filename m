Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3F0OzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:55:22 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:22699
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab3F0OzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:55:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I1447Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP243U-02-FUY-02
X-M-MSG: 
Date: Thu, 27 Jun 2013 09:55:05 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
Message-ID: <20130627145505.GA3076@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
 <CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
 <20130625161935.GA10208@jshin-Toonie>
 <CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
 <20130626142852.GA2326@jshin-Toonie>
 <CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
 <20130626175722.GA20226@jshin-Toonie>
 <CAKohpo=UTmpLmyQs5+xLNnCLMCeZHNQT3USjmK1NTaFJLNQg-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpo=UTmpLmyQs5+xLNnCLMCeZHNQT3USjmK1NTaFJLNQg-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:32:36PM +0530, Viresh Kumar wrote:
> On 26 June 2013 23:27, Jacob Shin <jacob.shin@amd.com> wrote:
> > On Wed, Jun 26, 2013 at 08:02:29PM +0530, Viresh Kumar wrote:
> >> On 26 June 2013 19:58, Jacob Shin <jacob.shin@amd.com> wrote:
> >> > On Wed, Jun 26, 2013 at 12:18:27PM +0530, Viresh Kumar wrote:
> >>
> >> >> I am not sure if this is enough. What if we had ondemand as the
> >> >> governor initially, then we changed it to something else. Now also
> >> >> cur_policy contains a address and isn't zero.
> >
> > I just tested this case with this patch applied, and did not have any
> > problems.
> 
> Try this:
> - you need a system with multiple policy groups to test it
> - Suppose we have two groups of CPUs: 0 and 1
> - Set ondemand as governor for both
> - change governor of group 1 to something else (we still have valid policy
> struct in Ondemand)
> - offline all CPUs from group 1. this will free struct cpufreq_policy
> - Online these CPUs back, this will reallocate policy
> - Now run this function, the earlier policy struct is already freed and
> you are accessing it here.

Ah, I understand now.

> 
> >> >> >                 cpumask_or(&done, &done, policy->cpus);
> >> >> > +
> >> >> > +               if (policy->governor != &cpufreq_gov_ondemand)
> >> >> > +                       continue;
> >> >
> >> > This should catch that case no ?
> >>
> >> Policy might be freed and reallocated by then. And so doing
> >> policy->governor is dangerous.
> >
> > Are you worried that after we have passed the above if check, and
> > before we access ->tuner governor change might occur?
> >
> > Is there something synonymous to get/put_online_cpus() for cpufreq to
> > prevent governor change while we update ->tuner values?
> >
> > Otherwise, should just spinlock?
> 
> No, i wasn't worrying about this but a sequence of events that I told to
> you earlier.
> 
> Replying to your other mail:
> > Hm . any hints on how to check for if ondemand is running on this CPU
> > or not ? I'm not sure what the best way to handle this is ..
> 
> Make cur_policy zero in cpufreq_governor_dbs() for
> CPUFREQ_GOV_STOP notification. This will make sure we use correct
> policy pointer.

Thanks for the tip :-)

Here is V2:

---8<---

>From d99ee318c0f9c415a60e6b0b79605232edbb749c Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Thu, 27 Jun 2013 09:39:48 -0500
Subject: [PATCH V2 1/1] cpufreq: fix NULL pointer deference at
 od_set_powersave_bias()

When initializing the default powersave_bias value, we need to first
make sure that this policy is running the ondemand governor.

Reported-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 drivers/cpufreq/cpufreq_governor.c |    1 +
 drivers/cpufreq/cpufreq_ondemand.c |   17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index dc9b72e..834ad86 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -403,6 +403,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		gov_cancel_work(dbs_data, policy);
 
 		mutex_lock(&dbs_data->mutex);
+		cpu_cdbs->cur_policy = NULL;
 		mutex_destroy(&cpu_cdbs->timer_mutex);
 
 		mutex_unlock(&dbs_data->mutex);
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 4b9bb5d..93eb5cb 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -47,6 +47,8 @@ static struct od_ops od_ops;
 static struct cpufreq_governor cpufreq_gov_ondemand;
 #endif
 
+static unsigned int default_powersave_bias;
+
 static void ondemand_powersave_bias_init_cpu(int cpu)
 {
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
@@ -543,7 +545,7 @@ static int od_init(struct dbs_data *dbs_data)
 
 	tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
 	tuners->ignore_nice = 0;
-	tuners->powersave_bias = 0;
+	tuners->powersave_bias = default_powersave_bias;
 	tuners->io_is_busy = should_io_be_busy();
 
 	dbs_data->tuners = tuners;
@@ -585,6 +587,7 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
 	unsigned int cpu;
 	cpumask_t done;
 
+	default_powersave_bias = powersave_bias;
 	cpumask_clear(&done);
 
 	get_online_cpus();
@@ -593,11 +596,17 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
 			continue;
 
 		policy = per_cpu(od_cpu_dbs_info, cpu).cdbs.cur_policy;
-		dbs_data = policy->governor_data;
-		od_tuners = dbs_data->tuners;
-		od_tuners->powersave_bias = powersave_bias;
+		if (!policy)
+			continue;
 
 		cpumask_or(&done, &done, policy->cpus);
+
+		if (policy->governor != &cpufreq_gov_ondemand)
+			continue;
+
+		dbs_data = policy->governor_data;
+		od_tuners = dbs_data->tuners;
+		od_tuners->powersave_bias = default_powersave_bias;
 	}
 	put_online_cpus();
 }
-- 
1.7.10.4


