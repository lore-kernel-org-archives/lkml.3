Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193AbaGOXQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068AbaGOXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vincent Minet <vincent@vincent-minet.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.15 47/84] intel_pstate: Set CPU number before accessing MSRs
Date: Tue, 15 Jul 2014 16:17:44 -0700
Message-Id: <20140715231714.623077138@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Minet <vincent@vincent-minet.net>

commit 179e8471673ce0249cd4ecda796008f7757e5bad upstream.

Ensure that cpu->cpu is set before writing MSR_IA32_PERF_CTL during CPU
initialization. Otherwise only cpu0 has its P-state set and all other
cores are left with their values unchanged.

In most cases, this is not too serious because the P-states will be set
correctly when the timer function is run.  But when the default governor
is set to performance, the per-CPU current_pstate stays the same forever
and no attempts are made to write the MSRs again.

Signed-off-by: Vincent Minet <vincent@vincent-minet.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -709,9 +709,8 @@ static int intel_pstate_init_cpu(unsigne
 
 	cpu = all_cpu_data[cpunum];
 
-	intel_pstate_get_cpu_pstates(cpu);
-
 	cpu->cpu = cpunum;
+	intel_pstate_get_cpu_pstates(cpu);
 
 	init_timer_deferrable(&cpu->timer);
 	cpu->timer.function = intel_pstate_timer_func;


