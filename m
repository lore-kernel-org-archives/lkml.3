Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaHYSKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:10:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaHYSKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:10:31 -0400
Date: Mon, 25 Aug 2014 20:08:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, fpu: __restore_xstate_sig()->math_state_restore()
	needs preempt_disable()
Message-ID: <20140825180806.GA22193@redhat.com>
References: <20140822171142.GA14812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822171142.GA14812@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add preempt_disable() + preempt_enable() around math_state_restore() in
__restore_xstate_sig(). Otherwise __switch_to() after __thread_fpu_begin()
can overwrite fpu->state we are going to restore.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/xsave.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 453343c..c52eb9c 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -397,8 +397,11 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 			set_used_math();
 		}
 
-		if (use_eager_fpu())
+		if (use_eager_fpu()) {
+			preempt_disable();
 			math_state_restore();
+			preempt_enable();
+		}
 
 		return err;
 	} else {
-- 
1.5.5.1


