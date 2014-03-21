Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbaCUBH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:07:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965253AbaCUAET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.13 089/149] cpufreq: Skip current frequency initialization for ->setpolicy drivers
Date: Thu, 20 Mar 2014 17:04:12 -0700
Message-Id: <20140321000440.042523880@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 2ed99e39cb9392312c100d9da591c20641c64d12 upstream.

After commit da60ce9f2fac (cpufreq: call cpufreq_driver->get() after
calling ->init()) __cpufreq_add_dev() sometimes fails for CPUs handled
by intel_pstate, because that driver may return 0 from its ->get()
callback if it has not run long enough to collect enough samples on the
given CPU.  That didn't happen before commit da60ce9f2fac which added
policy->cur initialization to __cpufreq_add_dev() to help reduce code
duplication in other cpufreq drivers.

However, the code added by commit da60ce9f2fac need not be executed
for cpufreq drivers having the ->setpolicy callback defined, because
the subsequent invocation of cpufreq_set_policy() will use that
callback to initialize the policy anyway and it doesn't need
policy->cur to be initialized upfront.  The analogous code in
cpufreq_update_policy() is also unnecessary for cpufreq drivers
having ->setpolicy set and may be skipped for them as well.

Since intel_pstate provides ->setpolicy, skipping the upfront
policy->cur initialization for cpufreq drivers with that callback
set will cover intel_pstate and the problem it's been having after
commit da60ce9f2fac will be addressed.

Fixes: da60ce9f2fac (cpufreq: call cpufreq_driver->get() after calling ->init())
References: https://bugzilla.kernel.org/show_bug.cgi?id=71931
Reported-and-tested-by: Patrik Lundquist <patrik.lundquist@gmail.com>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1051,7 +1051,7 @@ static int __cpufreq_add_dev(struct devi
 		goto err_set_policy_cpu;
 	}
 
-	if (cpufreq_driver->get) {
+	if (cpufreq_driver->get && !cpufreq_driver->setpolicy) {
 		policy->cur = cpufreq_driver->get(policy->cpu);
 		if (!policy->cur) {
 			pr_err("%s: ->get() failed\n", __func__);
@@ -2051,7 +2051,7 @@ int cpufreq_update_policy(unsigned int c
 	 * BIOS might change freq behind our back
 	 * -> ask driver for current freq and notify governors about a change
 	 */
-	if (cpufreq_driver->get) {
+	if (cpufreq_driver->get && !cpufreq_driver->setpolicy) {
 		new_policy.cur = cpufreq_driver->get(cpu);
 		if (!policy->cur) {
 			pr_debug("Driver did not initialize current freq");


