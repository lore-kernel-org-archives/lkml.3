Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3FYU3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:29:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55068 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3FYU30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:29:26 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 02/45] CPU hotplug: Clarify the usage of different
 synchronization APIs
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 26 Jun 2013 01:56:01 +0530
Message-ID: <20130625202601.16593.54501.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com>
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062520-8878-0000-0000-000007B0A760
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have quite a few APIs now which help synchronize with CPU hotplug.
Among them, get/put_online_cpus() is the oldest and the most well-known,
so no problems there. By extension, its easy to comprehend the new
set : get/put_online_cpus_atomic().

But there is yet another set, which might appear tempting to use:
cpu_hotplug_disable()/cpu_hotplug_enable(). Add comments to clarify
that this latter set is NOT for general use and must be used only in
specific cases where the requirement is really to _disable_ hotplug
and not just to synchronize with it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2d03398..860f51a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -139,6 +139,13 @@ static void cpu_hotplug_done(void)
  * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
  * hotplug path before performing hotplug operations. So acquiring that lock
  * guarantees mutual exclusion from any currently running hotplug operations.
+ *
+ * Note: In most cases, this is *NOT* the function you need. If you simply
+ * want to avoid racing with CPU hotplug operations, use get/put_online_cpus()
+ * or get/put_online_cpus_atomic(), depending on the situation.
+ *
+ * This set of functions is reserved for cases where you really wish to
+ * _disable_ CPU hotplug and not just synchronize with it.
  */
 void cpu_hotplug_disable(void)
 {

