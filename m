Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3ENPre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:47:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3ENPrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:47:32 -0400
Date: Tue, 14 May 2013 08:46:59 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f7ea0fd639c2c48d3c61b6eec75362be290c6874@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tony.luck@intel.com, jkosina@suse.cz, bp@alien8.de, fweisbec@gmail.com,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, tony.luck@intel.com, bp@alien8.de, fweisbec@gmail.com,
        tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <alpine.LFD.2.02.1305132138160.2863@ionos>
References: <alpine.LFD.2.02.1305132138160.2863@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick: Don't invoke tick_nohz_stop_sched_tick(
 ) if the cpu is offline
Git-Commit-ID: f7ea0fd639c2c48d3c61b6eec75362be290c6874
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7ea0fd639c2c48d3c61b6eec75362be290c6874
Gitweb:     http://git.kernel.org/tip/f7ea0fd639c2c48d3c61b6eec75362be290c6874
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 13 May 2013 21:40:27 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 14 May 2013 17:40:31 +0200

tick: Don't invoke tick_nohz_stop_sched_tick() if the cpu is offline

commit 5b39939a4 (nohz: Move ts->idle_calls incrementation into strict
idle logic) moved code out of tick_nohz_stop_sched_tick() and missed
to bail out when the cpu is offline. That's causing subsequent
failures as an offline CPU is supposed to die and not to fiddle with
nohz magic.

Return false in can_stop_idle_tick() if the cpu is offline.

Reported-and-tested-by: Jiri Kosina <jkosina@suse.cz>
Reported-and-tested-by: Prarit Bhargava <prarit@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305132138160.2863@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0eed1db..0121421 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -469,6 +469,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(!cpu_online(cpu))) {
 		if (cpu == tick_do_timer_cpu)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		return false;
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
