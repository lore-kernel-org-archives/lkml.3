Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaKRPKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:10:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbaKROJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:37 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/206] x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_disable()
Date: Tue, 18 Nov 2014 15:07:02 +0100
Message-Id: <03f43efc6a00eb29015222f8e9caeafdd9986a63.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit df24fb859a4e200d9324e2974229fbb7adf00aef upstream.

Add preempt_disable() + preempt_enable() around math_state_restore() in
__restore_xstate_sig(). Otherwise __switch_to() after __thread_fpu_begin()
can overwrite fpu->state we are going to restore.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175717.GA21649@redhat.com
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/xsave.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 422fd8223470..7305625c2767 100644
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
2.1.3

