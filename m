Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaFEAmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:42:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaFDXVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.14 044/228] module: remove warning about waiting module removal.
Date: Wed,  4 Jun 2014 16:21:13 -0700
Message-Id: <20140604232349.494410524@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 79465d2fd48e68940c2bdecddbdecd45bbba06fe upstream.

We remove the waiting module removal in commit 3f2b9c9cdf38 (September
2013), but it turns out that modprobe in kmod (< version 16) was
asking for waiting module removal.  No one noticed since modprobe would
check for 0 usage immediately before trying to remove the module, and
the race is unlikely.

However, it means that anyone running old (but not ancient) kmod
versions is hitting the printk designed to see if anyone was running
"rmmod -w".  All reports so far have been false positives, so remove
the warning.

Fixes: 3f2b9c9cdf389e303b2273679af08aab5f153517
Reported-by: Valerio Vanni <valerio.vanni@inwind.it>
Cc: Elliott, Robert (Server Storage) <Elliott@hp.com>
Acked-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -815,9 +815,6 @@ SYSCALL_DEFINE2(delete_module, const cha
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	if (!(flags & O_NONBLOCK))
-		pr_warn("waiting module removal not supported: please upgrade\n");
-
 	if (mutex_lock_interruptible(&module_mutex) != 0)
 		return -EINTR;
 


