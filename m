Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaIFLBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 07:01:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaIFLBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 07:01:52 -0400
Date: Sat, 6 Sep 2014 04:01:31 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-9bf2419fa7bffa16ce58a4d5c20399eff8c970c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gleb@kernel.org, john.stultz@linaro.org, pbonzini@redhat.com,
        chris.j.arges@canonical.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gleb@kernel.org, john.stultz@linaro.org, pbonzini@redhat.com,
        chris.j.arges@canonical.com, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1409050000570.3333@nanos>
References: <alpine.DEB.2.10.1409050000570.3333@nanos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timekeeping:
  Update timekeeper before updating vsyscall and pvclock
Git-Commit-ID: 9bf2419fa7bffa16ce58a4d5c20399eff8c970c9
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

Commit-ID:  9bf2419fa7bffa16ce58a4d5c20399eff8c970c9
Gitweb:     http://git.kernel.org/tip/9bf2419fa7bffa16ce58a4d5c20399eff8c970c9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 6 Sep 2014 12:24:49 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 6 Sep 2014 12:58:18 +0200

timekeeping: Update timekeeper before updating vsyscall and pvclock

The update_walltime() code works on the shadow timekeeper to make the
seqcount protected region as short as possible. But that update to the
shadow timekeeper does not update all timekeeper fields because it's
sufficient to do that once before it becomes life. One of these fields
is tkr.base_mono. That stays stale in the shadow timekeeper unless an
operation happens which copies the real timekeeper to the shadow.

The update function is called after the update calls to vsyscall and
pvclock. While not correct, it did not cause any problems because none
of the invoked update functions used base_mono.

commit cbcf2dd3b3d4 (x86: kvm: Make kvm_get_time_and_clockread()
nanoseconds based) changed that in the kvm pvclock update function, so
the stale mono_base value got used and caused kvm-clock to malfunction.

Put the update where it belongs and fix the issue.

Reported-by: Chris J Arges <chris.j.arges@canonical.com>
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1409050000570.3333@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb4a9c2..ec1791f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -442,11 +442,12 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
-	update_vsyscall(tk);
-	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
 	tk_update_ktime_data(tk);
 
+	update_vsyscall(tk);
+	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
+
 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &tk_core.timekeeper,
 		       sizeof(tk_core.timekeeper));
