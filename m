Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764065Ab3DDRfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:35:47 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:47916 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764050Ab3DDRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:35:45 -0400
From: dirk.brandewie@gmail.com
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH] cpufreq/intel_pstate: Set timer timeout correctly
Date: Thu,  4 Apr 2013 10:35:35 -0700
Message-Id: <1365096935-16730-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The current calculation of the delay time is wrong and a cut and paste
error from a previous experimental driver.  This can result in the
timeout being set to jiffies + 1 which setup the driver to race with
it's self if the apic timer interrupt happen at just the right time.


https://bugzilla.redhat.com/show_bug.cgi?id=920289

Reported-by: Adam Williamson <awilliam@redhat.com>
Reported-by: Parag Warudkar <parag.lkml@gmail.com>

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/cpufreq/intel_pstate.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 43ffe1c..4d6b988 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -502,7 +502,6 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
 
 	sample_time = cpu->pstate_policy->sample_rate_ms;
 	delay = msecs_to_jiffies(sample_time);
-	delay -= jiffies % delay;
 	mod_timer_pinned(&cpu->timer, jiffies + delay);
 }
 
-- 
1.7.7.6

