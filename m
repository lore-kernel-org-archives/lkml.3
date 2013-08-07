Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3HGSLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab3HGSLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:11:23 -0400
Date: Wed, 7 Aug 2013 20:05:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] audit_alloc: clear TIF_SYSCALL_AUDIT if !audit_context
Message-ID: <20130807180553.GA4920@redhat.com>
References: <20130807180530.GA4916@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807180530.GA4916@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If audit_filter_task() nacks the new thread it makes sense
to clear TIF_SYSCALL_AUDIT which can be copied from parent
by dup_task_struct().

A wrong TIF_SYSCALL_AUDIT is not really bad, but it triggers
the "slow" audit paths in entry.S.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/auditsc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9845cb3..95293ab 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -943,8 +943,10 @@ int audit_alloc(struct task_struct *tsk)
 		return 0; /* Return if not auditing. */
 
 	state = audit_filter_task(tsk, &key);
-	if (state == AUDIT_DISABLED)
+	if (state == AUDIT_DISABLED) {
+		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 		return 0;
+	}
 
 	if (!(context = audit_alloc_context(state))) {
 		kfree(key);
-- 
1.5.5.1


