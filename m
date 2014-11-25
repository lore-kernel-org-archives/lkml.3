Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbaKYLg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:36:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaKYKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 090/254] x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_disable()
Date: Tue, 25 Nov 2014 10:37:20 +0000
Message-Id: <1416912004-5928-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit df24fb859a4e200d9324e2974229fbb7adf00aef upstream.

Add preempt_disable() + preempt_enable() around math_state_restore() in
__restore_xstate_sig(). Otherwise __switch_to() after __thread_fpu_begin()
can overwrite fpu->state we are going to restore.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175717.GA21649@redhat.com
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/xsave.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a4b451c6addf..4679ef4005da 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -399,8 +399,11 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
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
2.1.0

