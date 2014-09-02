Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaIBWTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:19:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaIBWTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:19:02 -0400
Date: Tue, 2 Sep 2014 15:18:47 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-df24fb859a4e200d9324e2974229fbb7adf00aef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sbsiddha@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sbsiddha@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <20140902175717.GA21649@redhat.com>
References: <20140902175717.GA21649@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: __restore_xstate_sig()->
 math_state_restore() needs preempt_disable()
Git-Commit-ID: df24fb859a4e200d9324e2974229fbb7adf00aef
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

Commit-ID:  df24fb859a4e200d9324e2974229fbb7adf00aef
Gitweb:     http://git.kernel.org/tip/df24fb859a4e200d9324e2974229fbb7adf00aef
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 2 Sep 2014 19:57:17 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Sep 2014 14:51:15 -0700

x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_disable()

Add preempt_disable() + preempt_enable() around math_state_restore() in
__restore_xstate_sig(). Otherwise __switch_to() after __thread_fpu_begin()
can overwrite fpu->state we are going to restore.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175717.GA21649@redhat.com
Cc: <stable@vger.kernel.org> # v3.7+
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index cf0b830..4c540c4 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -400,8 +400,11 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
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
