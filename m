Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaHYKzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:55:38 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50415 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaHYKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:55:36 -0400
Subject: [RFC PATCH 1/5] module: Wait for RCU synchronizing before releasing
 a module
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Mon, 25 Aug 2014 10:55:27 +0000
Message-ID: <20140825105527.21089.53918.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
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
index 03214bd2..4c8a4f1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3324,6 +3324,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
 	wake_up_all(&module_wq);
+	/* Wait for RCU synchronizing before releasing mod->list. */
+	synchronize_rcu();
 	mutex_unlock(&module_mutex);
  free_module:
 	module_deallocate(mod, info);


