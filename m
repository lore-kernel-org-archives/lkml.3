Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaHXTuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbaHXTt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:49:59 -0400
Date: Sun, 24 Aug 2014 21:47:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86, fpu: don't drop_fpu() in exit_thread() if
	use_eager_fpu()
Message-ID: <20140824194740.GA27444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824194700.GA27281@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make exit_thread()->drop_fpu() depend on !use_eager_fpu(). This removes
another source of "use_eager_fpu() && !used_math()" special case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/process.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5df9447..7474f56 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -120,7 +120,8 @@ void exit_thread(void)
 		kfree(bp);
 	}
 
-	drop_fpu(me);
+	if (!use_eager_fpu())
+		drop_fpu(me);
 }
 
 void flush_thread(void)
-- 
1.5.5.1

