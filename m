Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaCLMSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:18:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50360 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaCLMSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:18:45 -0400
Date: Wed, 12 Mar 2014 05:16:00 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-1ed71e59bca79e866c4bebbe1efc0bc18245119d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jejb@parisc-linux.org, peterz@infradead.org, tglx@linutronix.de,
        deller@gmx.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, jejb@parisc-linux.org, tglx@linutronix.de,
        deller@gmx.de
In-Reply-To: <20140304203100.859489993@linutronix.de>
References: <20140304203100.859489993@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] parisc: Validate online cpus in irq_set_affinity()
  callbacks
Git-Commit-ID: 1ed71e59bca79e866c4bebbe1efc0bc18245119d
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

Commit-ID:  1ed71e59bca79e866c4bebbe1efc0bc18245119d
Gitweb:     http://git.kernel.org/tip/1ed71e59bca79e866c4bebbe1efc0bc18245119d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 4 Mar 2014 20:43:40 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Mar 2014 13:07:41 +0100

parisc: Validate online cpus in irq_set_affinity() callbacks

The [user space] interface does not filter out offline cpus. It merily
guarantees that the mask contains at least one online cpu.

So the selector in the irq chip implementation needs to make sure to
pick only an online cpu because otherwise:

     Offline Core 1
     Set affinity to 0xe (is valid due to online mask 0xd)
     cpumask_first will pick core 1, which is offline

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Link: http://lkml.kernel.org/r/20140304203100.859489993@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/parisc/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 8ceac47..cfe056f 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -117,7 +117,7 @@ int cpu_check_affinity(struct irq_data *d, const struct cpumask *dest)
 		return -EINVAL;
 
 	/* whatever mask they set, we just allow one CPU */
-	cpu_dest = first_cpu(*dest);
+	cpu_dest = cpumask_first_and(dest, cpu_online_mask);
 
 	return cpu_dest;
 }
