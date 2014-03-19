Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511AbaCSQDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:03:01 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:54986 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:02:59 -0400
Subject: [PATCH] powerpc/le: big endian arguments for ppc_rtas()
To: benh@kernel.crashing.org, paulus@samba.org
From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, anton@samba.org,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Mar 2014 17:02:51 +0100
Message-ID: <20140319155143.25510.71041.stgit@bahia.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031916-2966-0000-0000-00000AA277FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ppc_rtas() syscall allows userspace to interact directly with RTAS.
For the moment, it assumes every thing is big endian and returns either
EINVAL or EFAULT when called in a little endian environment.

As suggested by Benjamin, to avoid bugs when userspace wants to pass
a non 32 bit value to RTAS, it is far better to stick with a simple
rationale: ppc_rtas() should be called with a big endian rtas_args
structure.

With this patch, it is now up to userspace to forge big endian arguments,
as expected by RTAS.

Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
---

Ben,

The chunk with the -1 return code check may look a bit pedantic. Please feel
free to kill it. :)

Cheers.

--
Greg

 arch/powerpc/kernel/rtas.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 4cf674d..f386296 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1013,12 +1013,13 @@ struct pseries_errorlog *get_pseries_errorlog(struct rtas_error_log *log,
 	return NULL;
 }
 
+/* We assume to be passed big endian arguments */
 asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 {
 	struct rtas_args args;
 	unsigned long flags;
 	char *buff_copy, *errbuf = NULL;
-	int nargs;
+	int nargs, nret, token;
 	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1027,10 +1028,13 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 	if (copy_from_user(&args, uargs, 3 * sizeof(u32)) != 0)
 		return -EFAULT;
 
-	nargs = args.nargs;
+	nargs = be32_to_cpu(args.nargs);
+	nret  = be32_to_cpu(args.nret);
+	token = be32_to_cpu(args.token);
+
 	if (nargs > ARRAY_SIZE(args.args)
-	    || args.nret > ARRAY_SIZE(args.args)
-	    || nargs + args.nret > ARRAY_SIZE(args.args))
+	    || nret > ARRAY_SIZE(args.args)
+	    || nargs + nret > ARRAY_SIZE(args.args))
 		return -EINVAL;
 
 	/* Copy in args. */
@@ -1038,14 +1042,14 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 			   nargs * sizeof(rtas_arg_t)) != 0)
 		return -EFAULT;
 
-	if (args.token == RTAS_UNKNOWN_SERVICE)
+	if (token == RTAS_UNKNOWN_SERVICE)
 		return -EINVAL;
 
 	args.rets = &args.args[nargs];
-	memset(args.rets, 0, args.nret * sizeof(rtas_arg_t));
+	memset(args.rets, 0, nret * sizeof(rtas_arg_t));
 
 	/* Need to handle ibm,suspend_me call specially */
-	if (args.token == ibm_suspend_me_token) {
+	if (token == ibm_suspend_me_token) {
 		rc = rtas_ibm_suspend_me(&args);
 		if (rc)
 			return rc;
@@ -1062,7 +1066,7 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 
 	/* A -1 return code indicates that the last command couldn't
 	   be completed due to a hardware error. */
-	if (args.rets[0] == -1)
+	if (be32_to_cpu(args.rets[0]) == -1)
 		errbuf = __fetch_rtas_last_error(buff_copy);
 
 	unlock_rtas(flags);
@@ -1077,7 +1081,7 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 	/* Copy out args. */
 	if (copy_to_user(uargs->args + nargs,
 			 args.args + nargs,
-			 args.nret * sizeof(rtas_arg_t)) != 0)
+			 nret * sizeof(rtas_arg_t)) != 0)
 		return -EFAULT;
 
 	return 0;

