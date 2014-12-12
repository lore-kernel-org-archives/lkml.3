Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbaLLGRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:17:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52081 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757942AbaLLGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>, "Shai Fultheim" <shai@scalemp.com>,
        "Ido Yariv" <ido@wizery.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.27240288@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 073/164] x86: Conditionally update time when ack-ing
 pending irqs
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shai Fultheim <shai@scalemp.com>

commit 42fa4250436304d4650fa271f37671f6cee24e08 upstream.

On virtual environments, apic_read could take a long time. As a
result, under certain conditions the ack pending loop may exit
without any queued irqs left, but after more than one second. A
warning will be printed needlessly in this case.

If the loop is about to exit regardless of max_loops, don't
update it.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ rebased and reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1334873552-31346-1-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/apic/apic.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1309,11 +1309,13 @@ void __cpuinit setup_local_APIC(void)
 			       acked);
 			break;
 		}
-		if (cpu_has_tsc) {
-			rdtscll(ntsc);
-			max_loops = (cpu_khz << 10) - (ntsc - tsc);
-		} else
-			max_loops--;
+		if (queued) {
+			if (cpu_has_tsc) {
+				rdtscll(ntsc);
+				max_loops = (cpu_khz << 10) - (ntsc - tsc);
+			} else
+				max_loops--;
+		}
 	} while (queued && max_loops > 0);
 	WARN_ON(max_loops <= 0);
 

