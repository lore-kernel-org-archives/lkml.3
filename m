Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaLISF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:05:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaLISF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:05:56 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/6] livepatch v5: avoid race when checking for state of the patch
Date: Tue,  9 Dec 2014 19:05:02 +0100
Message-Id: <1418148307-21434-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

klp_patch_enable() and klp_patch_disable() should check the current state
of the patch under the klp_lock. Otherwise, it might detect that the operation
is valid but the situation might change before it takes the lock.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/livepatch/core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index d6d0f50e81f8..b848069e44cc 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -425,11 +425,13 @@ int klp_disable_patch(struct klp_patch *patch)
 {
 	int ret;
 
-	if (!klp_is_enabled())
-		return -ENODEV;
-
 	mutex_lock(&klp_mutex);
 
+	if (!klp_is_enabled()) {
+		ret = -ENODEV;
+		goto err;
+	}
+
 	if (!klp_patch_is_registered(patch)) {
 		ret = -EINVAL;
 		goto err;
@@ -489,11 +491,13 @@ int klp_enable_patch(struct klp_patch *patch)
 {
 	int ret;
 
-	if (!klp_is_enabled())
-		return -ENODEV;
-
 	mutex_lock(&klp_mutex);
 
+	if (!klp_is_enabled()) {
+		ret = -ENODEV;
+		goto err;
+	}
+
 	if (!klp_patch_is_registered(patch)) {
 		ret = -EINVAL;
 		goto err;
-- 
1.8.5.2

