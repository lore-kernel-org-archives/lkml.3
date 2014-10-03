Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaJCVcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:32:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaJCVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.16 001/357] module: Clean up ro/nx after early module load failures
Date: Fri,  3 Oct 2014 14:26:27 -0700
Message-Id: <20141003212933.505957731@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit ff7e0055bb5ddbbb320cdd8dfd3e18672bddd2ad upstream.

The commit

    4982223e51e8 module: set nx before marking module MODULE_STATE_COMING.

introduced a regression: if a module fails to parse its arguments or
if mod_sysfs_setup fails, then the module's memory will be freed
while still read-only.  Anything that reuses that memory will crash
as soon as it tries to write to it.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3308,6 +3308,11 @@ static int load_module(struct load_info
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
 	mutex_unlock(&module_mutex);
+
+	/* we can't deallocate the module until we clear memory protection */
+	unset_module_init_ro_nx(mod);
+	unset_module_core_ro_nx(mod);
+
  ddebug_cleanup:
 	dynamic_debug_remove(info->debug);
 	synchronize_sched();


