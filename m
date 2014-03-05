Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaCERUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:20:15 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:40897 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaCERUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:20:13 -0500
Subject: [PATCH] powerpc/le: fix endianness of the arguments passed to the
 ppc_rtas() syscall
To: benh@kernel.crashing.org, paulus@samba.org
From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, anton@samba.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 18:20:06 +0100
Message-ID: <20140305172006.26117.57219.stgit@bahia.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030517-8372-0000-0000-000008E31C81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTAS manipulates its input and output arguments in big endian order.

I have looked at factoring some lines with rtas_call() but it is not really
worth it because of the variable arguments.

Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/rtas.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 4cf674d..00dbe36 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1020,6 +1020,7 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 	char *buff_copy, *errbuf = NULL;
 	int nargs;
 	int rc;
+	int i;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1056,9 +1057,19 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 
 	flags = lock_rtas();
 
-	rtas.args = args;
+	rtas.args.token = cpu_to_be32(args.token);
+	rtas.args.nargs = cpu_to_be32(args.nargs);
+	rtas.args.nret  = cpu_to_be32(args.nret);
+	for (i = 0; i < nargs; ++i)
+		rtas.args.args[i] = cpu_to_be32(args.args[i]);
+	rtas.args.rets  = &rtas.args.args[nargs];
+	for (i = 0; i < args.nret; ++i)
+		rtas.args.rets[i] = 0;
+
 	enter_rtas(__pa(&rtas.args));
-	args = rtas.args;
+
+	for (i = 0; i < args.nret; ++i)
+		args.rets[i] = be32_to_cpu(rtas.args.rets[i]);
 
 	/* A -1 return code indicates that the last command couldn't
 	   be completed due to a hardware error. */

