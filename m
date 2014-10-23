Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaJWLad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:30:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46276 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaJWLa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:29 -0400
Subject: [PATCH v2 1/5] module: Wait for RCU synchronizing before releasing
 a module
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Thu, 23 Oct 2014 15:26:43 -0400
Message-ID: <20141023192643.10463.91439.stgit@localhost.localdomain>
In-Reply-To: <20141023192636.10463.45031.stgit@localhost.localdomain>
References: <20141023192636.10463.45031.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait for RCU synchronizing on failure path of module loading
before releasing struct module, because the memory of mod->list
can still be accessed by list walkers (e.g. kallsyms).

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/module.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 88cec1d..331b03f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3326,6 +3326,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
 	wake_up_all(&module_wq);
+	/* Wait for RCU synchronizing before releasing mod->list. */
+	synchronize_rcu();
 	mutex_unlock(&module_mutex);
  free_module:
 	module_deallocate(mod, info);


