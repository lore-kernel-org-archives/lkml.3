Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3FYQTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:19:52 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:14194
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab3FYQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:19:46 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MOYIOP-01-9DG-02
X-M-MSG: 
Date: Tue, 25 Jun 2013 11:19:35 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
Message-ID: <20130625161935.GA10208@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
 <CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:26:14PM +0530, Viresh Kumar wrote:
> On 24 June 2013 22:29, Tim Gardner <tim.gardner@canonical.com> wrote:
> > This is from Ubuntu Saucy based on 3.10-rc7:
> >
> > [   12.911676] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000070
> > [   12.911691] IP: [<ffffffff8156e572>] od_set_powersave_bias+0x92/0xc0
> >
> 
> Can you please look into this bug? It occurred after your
> patch... This is the boot log crash we have:

Hi,

Yes, so sorry about that, it looks like I failed to test with:

CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_X86_AMD_FREQ_SENSITIVITY=m

The following patch fixes this, Tim, could you please test ? :

---8<---

>From 3c727b1f775448599e67c5fb2121d79448e80c90 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Tue, 25 Jun 2013 10:40:54 -0500
Subject: [PATCH 1/1] cpufreq: fix NULL pointer deference at
 od_set_powersave_bias()

When initializing the default powersave_bias value, we need to first
make sure that this policy is running the ondemand governor.

Reported-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

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
1.7.9.5


