Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaDYOFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:05:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaDYOFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:05:35 -0400
Date: Fri, 25 Apr 2014 10:04:59 -0400
From: Rik van Riel <riel@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, linux-next@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-ID: <20140425100459.7824f676@annuminas.surriel.com>
In-Reply-To: <535992DD.3060808@infradead.org>
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
	<535992DD.3060808@infradead.org>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 15:40:29 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:


> uml on x86_64 defconfig:
> 
> drivers/built-in.o: In function `__handle_sysrq':
> drivers/tty/sysrq.c:514: undefined reference to `rcu_sysrq_start'
> drivers/tty/sysrq.c:558: undefined reference to `rcu_sysrq_end'

Randy, does the patch below fix it?

Mike, this patch should also address your concerns.

Andrew, this can be a -fix patch for the sysctl-rcu patch,
assuming it fixes things :)

Signed-off-by: Rik van Riel <riel@redhat.com
---
 drivers/tty/sysrq.c | 1 +
 kernel/rcu/update.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index dd53af9..0867433 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -46,6 +46,7 @@
 #include <linux/jiffies.h>
 #include <linux/syscalls.h>
 #include <linux/of.h>
+#include <linux/rcupdate.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 2ac3289..d22309c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -322,7 +322,8 @@ int rcu_jiffies_till_stall_check(void)
 
 void rcu_sysrq_start(void)
 {
-	rcu_cpu_stall_suppress = 2;
+	if (!rcu_cpu_stall_suppress)
+		rcu_cpu_stall_suppress = 2;
 }
 
 void rcu_sysrq_end(void)

