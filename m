Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab3APQOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:14:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965Ab3APQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 215/222] signals: sys_ssetmask() uses uninitialized newmask
Date: Wed, 16 Jan 2013 13:56:55 -0200
Message-Id: <1358351822-7675-216-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 5ba53ff648e785445a32ba39112ed07e4cf588d0 upstream.

Commit 77097ae503b1 ("most of set_current_blocked() callers want
SIGKILL/SIGSTOP removed from set") removed the initialization of newmask
by accident, causing ltp to complain like this:

  ssetmask01    1  TFAIL  :  sgetmask() failed: TEST_ERRNO=???(0): Success

Restore the proper initialization.

Reported-and-tested-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6771027..e9d3270 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3215,6 +3215,7 @@ SYSCALL_DEFINE1(ssetmask, int, newmask)
 	int old = current->blocked.sig[0];
 	sigset_t newset;
 
+	siginitset(&newset, newmask);
 	set_current_blocked(&newset);
 
 	return old;
-- 
1.7.9.5

