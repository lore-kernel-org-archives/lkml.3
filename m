Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3FECaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:30:11 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39755 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3FECaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:30:09 -0400
Message-ID: <51AEA2A8.90605@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 10:30:00 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Borislav Petkov <bp@alien8.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130509125040.GF27333@pd.tnic> <20130509125859.GG27333@pd.tnic> <20130515184528.GO4442@linux.vnet.ibm.com> <20130515224358.GF11783@pd.tnic> <20130515235512.GT4442@linux.vnet.ibm.com> <20130517135641.GF23035@pd.tnic> <alpine.LNX.2.00.1306042319360.6750@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1306042319360.6750@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060502-2674-0000-0000-0000093D4CEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri

On 06/05/2013 05:20 AM, Jiri Kosina wrote:
[snip]
> 
> Just to not let this thread sleep -- I am seeing this as well, even with 
> current Linus' tree (git HEAD == aa4f608).

Have you tried this:

diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index 443442d..449be88 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -26,6 +26,7 @@
 #include <linux/tick.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
+#include <linux/cpu.h>

 #include "cpufreq_governor.h"

@@ -180,8 +181,10 @@ void gov_queue_work(struct dbs_data *dbs_data,
struct cpufreq_policy *policy,
        if (!all_cpus) {
                __gov_queue_work(smp_processor_id(), dbs_data, delay);
        } else {
+               get_online_cpus();
                for_each_cpu(i, policy->cpus)
                        __gov_queue_work(i, dbs_data, delay);
+               put_online_cpus();
        }
 }
 EXPORT_SYMBOL_GPL(gov_queue_work);

Does it works?

Regards,
Michael Wang

> 

