Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3EQVnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:43:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab3EQVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 085/102] cpufreq / intel_pstate: fix ffmpeg regression
Date: Fri, 17 May 2013 14:36:40 -0700
Message-Id: <20130517213253.223861866@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit ca182aee389f8026401510f4c63841cb02c820e8 upstream.

The ffmpeg benchmark in the phoronix test suite has threads on
multiple cores that rely on the progress on of threads on other cores
and ping pong back and forth fast enough to make the core appear less
busy than it "should" be.  If the core has been at minimum p-state for
a while bump the pstate up to kick the core to see if it is in this
ping pong state.  If the core is truly idle the p-state will be
reduced at the next sample time.  If the core makes more progress it
will send more work to the thread bringing both threads out of the
ping pong scenario and the p-state will be selected normally.

This fixes a performance regression of approximately 30%

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -551,22 +551,16 @@ static void intel_pstate_timer_func(unsi
 	struct cpudata *cpu = (struct cpudata *) __data;
 
 	intel_pstate_sample(cpu);
+	intel_pstate_adjust_busy_pstate(cpu);
 
-	if (!cpu->idle_mode)
-		intel_pstate_adjust_busy_pstate(cpu);
-	else
-		intel_pstate_adjust_idle_pstate(cpu);
-
-#if defined(XPERF_FIX)
 	if (cpu->pstate.current_pstate == cpu->pstate.min_pstate) {
 		cpu->min_pstate_count++;
 		if (!(cpu->min_pstate_count % 5)) {
 			intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
-			intel_pstate_idle_mode(cpu);
 		}
 	} else
 		cpu->min_pstate_count = 0;
-#endif
+
 	intel_pstate_set_sample_time(cpu);
 }
 


