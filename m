Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab3GVQKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:50 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61507 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3GVQKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:44 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Li Wei <wei.g.li@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 11/48] staging/lustre/ptlrpc: Translate between host and network errnos
Date: Tue, 23 Jul 2013 00:06:32 +0800
Message-Id: <1374509230-3324-12-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Wei <wei.g.li@intel.com>

Lustre puts system errors (e.g., ENOTCONN) on wire as numbers
essentially specific to senders' architectures.  While this is fine
for x86-only sites, where receivers share the same error number
definition with senders, problems will arise, however, for sites
involving multiple architectures with different error number
definitions.  For instance, an ENOTCONN reply from a sparc server will
be put on wire as -57, which, for an x86 client, means EBADSLT
instead.

To solve the problem, this patch defines a set of network errors for
on-wire or on-disk uses.  These errors correspond to a subset of the
x86 system errors and share the same number definition, maintaining
compatibility with existing x86 clients and servers.

Then, either error numbers could be translated at run time, or all
host errors going on wire could be replaced with network errors in the
code.  This patch does the former by introducing both generic and
field-specific translation routines and calling them at proper places,
so that translations for existing fields are transparent.
(Personally, I tend to think the latter way might be worthwhile, as it
is more straightforward conceptually.  Do we really need so many
different errors?  Should errors returned by kernel routines really be
passed up and eventually put on wire?  There could even be security
implications in that.)

Thank Fujitsu for the original idea and their contributions that make
this available upstream.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2743
Lustre-change: http://review.whamcloud.com/5577
Signed-off-by: Li Wei <wei.g.li@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Hiroya Nozaki <nozaki.hiroya@jp.fujitsu.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/Kconfig              |    5 +
 .../lustre/lustre/include/lustre/lustre_errno.h    |  215 +++++++++++
 .../lustre/lustre/include/lustre/lustre_idl.h      |    2 +
 drivers/staging/lustre/lustre/include/lustre_net.h |   32 ++
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    3 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    2 +
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    6 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   10 +
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |    1 +
 drivers/staging/lustre/lustre/osc/osc_request.c    |    2 +
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    1 +
 drivers/staging/lustre/lustre/ptlrpc/errno.c       |  382 ++++++++++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |    3 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    3 +
 14 files changed, 662 insertions(+), 5 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/errno.c

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 0a8eb1ad..19a1c33 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -59,3 +59,8 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
 	  expensive checks that may have a performance impact.
 
 	  Use with caution. If unsure, say N.
+
+config LUSTRE_TRANSLATE_ERRNOS
+	bool
+	depends on LUSTRE_FS && !X86
+	default true
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h b/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
new file mode 100644
index 0000000..2870487
--- /dev/null
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
@@ -0,0 +1,215 @@
+/*
+ * GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; If not, see
+ * http://www.gnu.org/licenses/gpl-2.0.txt
+ *
+ * GPL HEADER END
+ */
+/*
+ * Copyright (C) 2011 FUJITSU LIMITED.  All rights reserved.
+ *
+ * Copyright (c) 2013, Intel Corporation.
+ */
+
+#ifndef LUSTRE_ERRNO_H
+#define LUSTRE_ERRNO_H
+
+/*
+ * Only "network" errnos, which are defined below, are allowed on wire (or on
+ * disk).  Generic routines exist to help translate between these and a subset
+ * of the "host" errnos.  Some host errnos (e.g., EDEADLOCK) are intentionally
+ * left out.  See also the comment on lustre_errno_hton_mapping[].
+ *
+ * To maintain compatibility with existing x86 clients and servers, each of
+ * these network errnos has the same numerical value as its corresponding host
+ * errno on x86.
+ */
+#define LUSTRE_EPERM		1	/* Operation not permitted */
+#define LUSTRE_ENOENT		2	/* No such file or directory */
+#define LUSTRE_ESRCH		3	/* No such process */
+#define LUSTRE_EINTR		4	/* Interrupted system call */
+#define LUSTRE_EIO		5	/* I/O error */
+#define LUSTRE_ENXIO		6	/* No such device or address */
+#define LUSTRE_E2BIG		7	/* Argument list too long */
+#define LUSTRE_ENOEXEC		8	/* Exec format error */
+#define LUSTRE_EBADF		9	/* Bad file number */
+#define LUSTRE_ECHILD		10	/* No child processes */
+#define LUSTRE_EAGAIN		11	/* Try again */
+#define LUSTRE_ENOMEM		12	/* Out of memory */
+#define LUSTRE_EACCES		13	/* Permission denied */
+#define LUSTRE_EFAULT		14	/* Bad address */
+#define LUSTRE_ENOTBLK		15	/* Block device required */
+#define LUSTRE_EBUSY		16	/* Device or resource busy */
+#define LUSTRE_EEXIST		17	/* File exists */
+#define LUSTRE_EXDEV		18	/* Cross-device link */
+#define LUSTRE_ENODEV		19	/* No such device */
+#define LUSTRE_ENOTDIR		20	/* Not a directory */
+#define LUSTRE_EISDIR		21	/* Is a directory */
+#define LUSTRE_EINVAL		22	/* Invalid argument */
+#define LUSTRE_ENFILE		23	/* File table overflow */
+#define LUSTRE_EMFILE		24	/* Too many open files */
+#define LUSTRE_ENOTTY		25	/* Not a typewriter */
+#define LUSTRE_ETXTBSY		26	/* Text file busy */
+#define LUSTRE_EFBIG		27	/* File too large */
+#define LUSTRE_ENOSPC		28	/* No space left on device */
+#define LUSTRE_ESPIPE		29	/* Illegal seek */
+#define LUSTRE_EROFS		30	/* Read-only file system */
+#define LUSTRE_EMLINK		31	/* Too many links */
+#define LUSTRE_EPIPE		32	/* Broken pipe */
+#define LUSTRE_EDOM		33	/* Math argument out of domain of
+					   func */
+#define LUSTRE_ERANGE		34	/* Math result not representable */
+#define LUSTRE_EDEADLK		35	/* Resource deadlock would occur */
+#define LUSTRE_ENAMETOOLONG	36	/* File name too long */
+#define LUSTRE_ENOLCK		37	/* No record locks available */
+#define LUSTRE_ENOSYS		38	/* Function not implemented */
+#define LUSTRE_ENOTEMPTY	39	/* Directory not empty */
+#define LUSTRE_ELOOP		40	/* Too many symbolic links
+					   encountered */
+#define LUSTRE_ENOMSG		42	/* No message of desired type */
+#define LUSTRE_EIDRM		43	/* Identifier removed */
+#define LUSTRE_ECHRNG		44	/* Channel number out of range */
+#define LUSTRE_EL2NSYNC		45	/* Level 2 not synchronized */
+#define LUSTRE_EL3HLT		46	/* Level 3 halted */
+#define LUSTRE_EL3RST		47	/* Level 3 reset */
+#define LUSTRE_ELNRNG		48	/* Link number out of range */
+#define LUSTRE_EUNATCH		49	/* Protocol driver not attached */
+#define LUSTRE_ENOCSI		50	/* No CSI structure available */
+#define LUSTRE_EL2HLT		51	/* Level 2 halted */
+#define LUSTRE_EBADE		52	/* Invalid exchange */
+#define LUSTRE_EBADR		53	/* Invalid request descriptor */
+#define LUSTRE_EXFULL		54	/* Exchange full */
+#define LUSTRE_ENOANO		55	/* No anode */
+#define LUSTRE_EBADRQC		56	/* Invalid request code */
+#define LUSTRE_EBADSLT		57	/* Invalid slot */
+#define LUSTRE_EBFONT		59	/* Bad font file format */
+#define LUSTRE_ENOSTR		60	/* Device not a stream */
+#define LUSTRE_ENODATA		61	/* No data available */
+#define LUSTRE_ETIME		62	/* Timer expired */
+#define LUSTRE_ENOSR		63	/* Out of streams resources */
+#define LUSTRE_ENONET		64	/* Machine is not on the network */
+#define LUSTRE_ENOPKG		65	/* Package not installed */
+#define LUSTRE_EREMOTE		66	/* Object is remote */
+#define LUSTRE_ENOLINK		67	/* Link has been severed */
+#define LUSTRE_EADV		68	/* Advertise error */
+#define LUSTRE_ESRMNT		69	/* Srmount error */
+#define LUSTRE_ECOMM		70	/* Communication error on send */
+#define LUSTRE_EPROTO		71	/* Protocol error */
+#define LUSTRE_EMULTIHOP	72	/* Multihop attempted */
+#define LUSTRE_EDOTDOT		73	/* RFS specific error */
+#define LUSTRE_EBADMSG		74	/* Not a data message */
+#define LUSTRE_EOVERFLOW	75	/* Value too large for defined data
+					   type */
+#define LUSTRE_ENOTUNIQ		76	/* Name not unique on network */
+#define LUSTRE_EBADFD		77	/* File descriptor in bad state */
+#define LUSTRE_EREMCHG		78	/* Remote address changed */
+#define LUSTRE_ELIBACC		79	/* Can not access a needed shared
+					   library */
+#define LUSTRE_ELIBBAD		80	/* Accessing a corrupted shared
+					   library */
+#define LUSTRE_ELIBSCN		81	/* .lib section in a.out corrupted */
+#define LUSTRE_ELIBMAX		82	/* Attempting to link in too many shared
+					   libraries */
+#define LUSTRE_ELIBEXEC		83	/* Cannot exec a shared library
+					   directly */
+#define LUSTRE_EILSEQ		84	/* Illegal byte sequence */
+#define LUSTRE_ERESTART		85	/* Interrupted system call should be
+					   restarted */
+#define LUSTRE_ESTRPIPE		86	/* Streams pipe error */
+#define LUSTRE_EUSERS		87	/* Too many users */
+#define LUSTRE_ENOTSOCK		88	/* Socket operation on non-socket */
+#define LUSTRE_EDESTADDRREQ	89	/* Destination address required */
+#define LUSTRE_EMSGSIZE		90	/* Message too long */
+#define LUSTRE_EPROTOTYPE	91	/* Protocol wrong type for socket */
+#define LUSTRE_ENOPROTOOPT	92	/* Protocol not available */
+#define LUSTRE_EPROTONOSUPPORT	93	/* Protocol not supported */
+#define LUSTRE_ESOCKTNOSUPPORT	94	/* Socket type not supported */
+#define LUSTRE_EOPNOTSUPP	95	/* Operation not supported on transport
+					   endpoint */
+#define LUSTRE_EPFNOSUPPORT	96	/* Protocol family not supported */
+#define LUSTRE_EAFNOSUPPORT	97	/* Address family not supported by
+					   protocol */
+#define LUSTRE_EADDRINUSE	98	/* Address already in use */
+#define LUSTRE_EADDRNOTAVAIL	99	/* Cannot assign requested address */
+#define LUSTRE_ENETDOWN		100	/* Network is down */
+#define LUSTRE_ENETUNREACH	101	/* Network is unreachable */
+#define LUSTRE_ENETRESET	102	/* Network dropped connection because of
+					   reset */
+#define LUSTRE_ECONNABORTED	103	/* Software caused connection abort */
+#define LUSTRE_ECONNRESET	104	/* Connection reset by peer */
+#define LUSTRE_ENOBUFS		105	/* No buffer space available */
+#define LUSTRE_EISCONN		106	/* Transport endpoint is already
+					   connected */
+#define LUSTRE_ENOTCONN		107	/* Transport endpoint is not
+					   connected */
+#define LUSTRE_ESHUTDOWN	108	/* Cannot send after transport endpoint
+					   shutdown */
+#define LUSTRE_ETOOMANYREFS	109	/* Too many references: cannot splice */
+#define LUSTRE_ETIMEDOUT	110	/* Connection timed out */
+#define LUSTRE_ECONNREFUSED	111	/* Connection refused */
+#define LUSTRE_EHOSTDOWN	112	/* Host is down */
+#define LUSTRE_EHOSTUNREACH	113	/* No route to host */
+#define LUSTRE_EALREADY		114	/* Operation already in progress */
+#define LUSTRE_EINPROGRESS	115	/* Operation now in progress */
+#define LUSTRE_ESTALE		116	/* Stale NFS file handle */
+#define LUSTRE_EUCLEAN		117	/* Structure needs cleaning */
+#define LUSTRE_ENOTNAM		118	/* Not a XENIX named type file */
+#define LUSTRE_ENAVAIL		119	/* No XENIX semaphores available */
+#define LUSTRE_EISNAM		120	/* Is a named type file */
+#define LUSTRE_EREMOTEIO	121	/* Remote I/O error */
+#define LUSTRE_EDQUOT		122	/* Quota exceeded */
+#define LUSTRE_ENOMEDIUM	123	/* No medium found */
+#define LUSTRE_EMEDIUMTYPE	124	/* Wrong medium type */
+#define LUSTRE_ECANCELED	125	/* Operation Canceled */
+#define LUSTRE_ENOKEY		126	/* Required key not available */
+#define LUSTRE_EKEYEXPIRED	127	/* Key has expired */
+#define LUSTRE_EKEYREVOKED	128	/* Key has been revoked */
+#define LUSTRE_EKEYREJECTED	129	/* Key was rejected by service */
+#define LUSTRE_EOWNERDEAD	130	/* Owner died */
+#define LUSTRE_ENOTRECOVERABLE	131	/* State not recoverable */
+#define LUSTRE_ERESTARTSYS	512
+#define LUSTRE_ERESTARTNOINTR	513
+#define LUSTRE_ERESTARTNOHAND	514	/* restart if no handler.. */
+#define LUSTRE_ENOIOCTLCMD	515	/* No ioctl command */
+#define LUSTRE_ERESTART_RESTARTBLOCK 516 /* restart by calling
+					    sys_restart_syscall */
+#define LUSTRE_EBADHANDLE	521	/* Illegal NFS file handle */
+#define LUSTRE_ENOTSYNC		522	/* Update synchronization mismatch */
+#define LUSTRE_EBADCOOKIE	523	/* Cookie is stale */
+#define LUSTRE_ENOTSUPP		524	/* Operation is not supported */
+#define LUSTRE_ETOOSMALL	525	/* Buffer or request is too small */
+#define LUSTRE_ESERVERFAULT	526	/* An untranslatable error occurred */
+#define LUSTRE_EBADTYPE		527	/* Type not supported by server */
+#define LUSTRE_EJUKEBOX		528	/* Request initiated, but will not
+					   complete before timeout */
+#define LUSTRE_EIOCBQUEUED	529	/* iocb queued, will get completion
+					   event */
+#define LUSTRE_EIOCBRETRY	530	/* iocb queued, will trigger a retry */
+
+/*
+ * Translations are optimized away on x86.  Host errnos that shouldn't be put
+ * on wire could leak through as a result.  Do not count on this side effect.
+ */
+#ifdef CONFIG_LUSTRE_TRANSLATE_ERRNOS
+unsigned int lustre_errno_hton(unsigned int h);
+unsigned int lustre_errno_ntoh(unsigned int n);
+#else
+#define lustre_errno_hton(h) (h)
+#define lustre_errno_ntoh(n) (n)
+#endif
+
+#endif /* LUSTRE_ERRNO_H */
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 1cfebfe..4829419 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -98,6 +98,8 @@
 /* Defn's shared with user-space. */
 #include <lustre/lustre_user.h>
 
+#include <lustre/lustre_errno.h>
+
 /*
  *  GENERAL STUFF
  */
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 1b99b5d..8d7cc7a 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -3166,6 +3166,38 @@ lustre_shrink_reply(struct ptlrpc_request *req, int segment,
 	req->rq_replen = lustre_shrink_msg(req->rq_repmsg, segment,
 					   newlen, move_data);
 }
+
+#ifdef CONFIG_LUSTRE_TRANSLATE_ERRNOS
+
+static inline int ptlrpc_status_hton(int h)
+{
+	/*
+	 * Positive errnos must be network errnos, such as LUSTRE_EDEADLK,
+	 * ELDLM_LOCK_ABORTED, etc.
+	 */
+	if (h < 0)
+		return -lustre_errno_hton(-h);
+	else
+		return h;
+}
+
+static inline int ptlrpc_status_ntoh(int n)
+{
+	/*
+	 * See the comment in ptlrpc_status_hton().
+	 */
+	if (n < 0)
+		return -lustre_errno_ntoh(-n);
+	else
+		return n;
+}
+
+#else
+
+#define ptlrpc_status_hton(h) (h)
+#define ptlrpc_status_ntoh(n) (n)
+
+#endif
 /** @} */
 
 /** Change request phase of \a req to \a new_phase */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 93badf5..0b3ea88 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -2208,7 +2208,8 @@ struct ldlm_resource *ldlm_lock_convert(struct ldlm_lock *lock, int new_mode,
 	/* I can't check the type of lock here because the bitlock of lock
 	 * is not held here, so do the allocation blindly. -jay */
 	OBD_SLAB_ALLOC_PTR_GFP(node, ldlm_interval_slab, __GFP_IO);
-	if (node == NULL)  /* Actually, this causes EDEADLOCK to be returned */
+	if (node == NULL)
+		/* Actually, this causes EDEADLOCK to be returned */
 		RETURN(NULL);
 
 	LASSERTF((new_mode == LCK_PW && lock->l_granted_mode == LCK_PR),
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 324d5e4..f79b244 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -555,6 +555,8 @@ static int ldlm_handle_qc_callback(struct ptlrpc_request *req)
 		RETURN(-EPROTO);
 	}
 
+	oqctl->qc_stat = ptlrpc_status_ntoh(oqctl->qc_stat);
+
 	cli->cl_qchk_stat = oqctl->qc_stat;
 	return 0;
 }
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 1a690ed..ab41fea 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -1023,7 +1023,7 @@ static int ldlm_cli_convert_local(struct ldlm_lock *lock, int new_mode,
 		ldlm_reprocess_all(res);
 		rc = 0;
 	} else {
-		rc = EDEADLOCK;
+		rc = LUSTRE_EDEADLK;
 	}
 	LDLM_DEBUG(lock, "client-side local convert handler END");
 	LDLM_LOCK_PUT(lock);
@@ -1095,7 +1095,7 @@ int ldlm_cli_convert(struct lustre_handle *lockh, int new_mode, __u32 *flags)
 				GOTO(out, rc);
 		}
 	} else {
-		rc = EDEADLOCK;
+		rc = LUSTRE_EDEADLK;
 	}
 	EXIT;
  out:
@@ -1248,7 +1248,7 @@ int ldlm_cli_cancel_req(struct obd_export *exp, struct list_head *cancels,
 		} else {
 			rc = ptlrpc_queue_wait(req);
 		}
-		if (rc == ESTALE) {
+		if (rc == LUSTRE_ESTALE) {
 			CDEBUG(D_DLMTRACE, "client/server (nid %s) "
 			       "out of sync -- not fatal\n",
 			       libcfs_nid2str(req->rq_import->
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 1cc90b6..bae2d67 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -840,6 +840,9 @@ resend:
 	lockrep = req_capsule_server_get(&req->rq_pill, &RMF_DLM_REP);
 	LASSERT(lockrep != NULL);
 
+	lockrep->lock_policy_res2 =
+		ptlrpc_status_ntoh(lockrep->lock_policy_res2);
+
 	/* Retry the create infinitely when we get -EINPROGRESS from
 	 * server. This is required by the new quota design. */
 	if (it && it->it_op & IT_CREAT &&
@@ -1139,6 +1142,7 @@ static int mdc_intent_getattr_async_interpret(const struct lu_env *env,
 	struct lookup_intent     *it;
 	struct lustre_handle     *lockh;
 	struct obd_device	*obddev;
+	struct ldlm_reply	 *lockrep;
 	__u64		     flags = LDLM_FL_HAS_INTENT;
 	ENTRY;
 
@@ -1159,6 +1163,12 @@ static int mdc_intent_getattr_async_interpret(const struct lu_env *env,
 		GOTO(out, rc);
 	}
 
+	lockrep = req_capsule_server_get(&req->rq_pill, &RMF_DLM_REP);
+	LASSERT(lockrep != NULL);
+
+	lockrep->lock_policy_res2 =
+		ptlrpc_status_ntoh(lockrep->lock_policy_res2);
+
 	rc = mdc_finish_enqueue(exp, req, einfo, it, lockh, rc);
 	if (rc)
 		GOTO(out, rc);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 21e8a9d..b8bf2dc 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1189,6 +1189,7 @@ static int mdc_ioc_hsm_progress(struct obd_export *exp,
 		GOTO(out, rc = -EPROTO);
 
 	*req_hpk = *hpk;
+	req_hpk->hpk_errval = lustre_errno_hton(hpk->hpk_errval);
 
 	ptlrpc_request_set_replen(req);
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index 53d6a35..0c0e07b 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -2347,6 +2347,8 @@ static int osc_enqueue_fini(struct ptlrpc_request *req, struct ost_lvb *lvb,
 						     &RMF_DLM_REP);
 
 			LASSERT(rep != NULL);
+			rep->lock_policy_res1 =
+				ptlrpc_status_ntoh(rep->lock_policy_res1);
 			if (rep->lock_policy_res1)
 				rc = rep->lock_policy_res1;
 		}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/Makefile b/drivers/staging/lustre/lustre/ptlrpc/Makefile
index 983eb66..a379558 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/Makefile
+++ b/drivers/staging/lustre/lustre/ptlrpc/Makefile
@@ -16,6 +16,7 @@ ptlrpc_objs += sec.o sec_bulk.o sec_gc.o sec_config.o sec_lproc.o
 ptlrpc_objs += sec_null.o sec_plain.o nrs.o nrs_fifo.o
 
 ptlrpc-y := $(ldlm_objs) $(ptlrpc_objs)
+ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.c
 
 obj-$(CONFIG_PTLRPC_GSS) += gss/
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/errno.c b/drivers/staging/lustre/lustre/ptlrpc/errno.c
new file mode 100644
index 0000000..46e259e
--- /dev/null
+++ b/drivers/staging/lustre/lustre/ptlrpc/errno.c
@@ -0,0 +1,382 @@
+/*
+ * GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; If not, see
+ * http://www.gnu.org/licenses/gpl-2.0.txt
+ *
+ * GPL HEADER END
+ */
+/*
+ * Copyright (C) 2011 FUJITSU LIMITED.  All rights reserved.
+ *
+ * Copyright (c) 2013, Intel Corporation.
+ */
+
+#include <libcfs/libcfs.h>
+#include <lustre/lustre_errno.h>
+
+/*
+ * The two translation tables below must define a one-to-one mapping between
+ * host and network errnos.
+ *
+ * EWOULDBLOCK is equal to EAGAIN on all architectures except for parisc, which
+ * appears irrelevant.  Thus, existing references to EWOULDBLOCK are fine.
+ *
+ * EDEADLOCK is equal to EDEADLK on x86 but not on sparc, at least.  A sparc
+ * host has no context-free way to determine if a LUSTRE_EDEADLK represents an
+ * EDEADLK or an EDEADLOCK.  Therefore, all existing references to EDEADLOCK
+ * that need to be transferred on wire have been replaced with EDEADLK.
+ */
+static int lustre_errno_hton_mapping[] = {
+	[EPERM]			= LUSTRE_EPERM,
+	[ENOENT]		= LUSTRE_ENOENT,
+	[ESRCH]			= LUSTRE_ESRCH,
+	[EINTR]			= LUSTRE_EINTR,
+	[EIO]			= LUSTRE_EIO,
+	[ENXIO]			= LUSTRE_ENXIO,
+	[E2BIG]			= LUSTRE_E2BIG,
+	[ENOEXEC]		= LUSTRE_ENOEXEC,
+	[EBADF]			= LUSTRE_EBADF,
+	[ECHILD]		= LUSTRE_ECHILD,
+	[EAGAIN]		= LUSTRE_EAGAIN,
+	[ENOMEM]		= LUSTRE_ENOMEM,
+	[EACCES]		= LUSTRE_EACCES,
+	[EFAULT]		= LUSTRE_EFAULT,
+	[ENOTBLK]		= LUSTRE_ENOTBLK,
+	[EBUSY]			= LUSTRE_EBUSY,
+	[EEXIST]		= LUSTRE_EEXIST,
+	[EXDEV]			= LUSTRE_EXDEV,
+	[ENODEV]		= LUSTRE_ENODEV,
+	[ENOTDIR]		= LUSTRE_ENOTDIR,
+	[EISDIR]		= LUSTRE_EISDIR,
+	[EINVAL]		= LUSTRE_EINVAL,
+	[ENFILE]		= LUSTRE_ENFILE,
+	[EMFILE]		= LUSTRE_EMFILE,
+	[ENOTTY]		= LUSTRE_ENOTTY,
+	[ETXTBSY]		= LUSTRE_ETXTBSY,
+	[EFBIG]			= LUSTRE_EFBIG,
+	[ENOSPC]		= LUSTRE_ENOSPC,
+	[ESPIPE]		= LUSTRE_ESPIPE,
+	[EROFS]			= LUSTRE_EROFS,
+	[EMLINK]		= LUSTRE_EMLINK,
+	[EPIPE]			= LUSTRE_EPIPE,
+	[EDOM]			= LUSTRE_EDOM,
+	[ERANGE]		= LUSTRE_ERANGE,
+	[EDEADLK]		= LUSTRE_EDEADLK,
+	[ENAMETOOLONG]		= LUSTRE_ENAMETOOLONG,
+	[ENOLCK]		= LUSTRE_ENOLCK,
+	[ENOSYS]		= LUSTRE_ENOSYS,
+	[ENOTEMPTY]		= LUSTRE_ENOTEMPTY,
+	[ELOOP]			= LUSTRE_ELOOP,
+	[ENOMSG]		= LUSTRE_ENOMSG,
+	[EIDRM]			= LUSTRE_EIDRM,
+	[ECHRNG]		= LUSTRE_ECHRNG,
+	[EL2NSYNC]		= LUSTRE_EL2NSYNC,
+	[EL3HLT]		= LUSTRE_EL3HLT,
+	[EL3RST]		= LUSTRE_EL3RST,
+	[ELNRNG]		= LUSTRE_ELNRNG,
+	[EUNATCH]		= LUSTRE_EUNATCH,
+	[ENOCSI]		= LUSTRE_ENOCSI,
+	[EL2HLT]		= LUSTRE_EL2HLT,
+	[EBADE]			= LUSTRE_EBADE,
+	[EBADR]			= LUSTRE_EBADR,
+	[EXFULL]		= LUSTRE_EXFULL,
+	[ENOANO]		= LUSTRE_ENOANO,
+	[EBADRQC]		= LUSTRE_EBADRQC,
+	[EBADSLT]		= LUSTRE_EBADSLT,
+	[EBFONT]		= LUSTRE_EBFONT,
+	[ENOSTR]		= LUSTRE_ENOSTR,
+	[ENODATA]		= LUSTRE_ENODATA,
+	[ETIME]			= LUSTRE_ETIME,
+	[ENOSR]			= LUSTRE_ENOSR,
+	[ENONET]		= LUSTRE_ENONET,
+	[ENOPKG]		= LUSTRE_ENOPKG,
+	[EREMOTE]		= LUSTRE_EREMOTE,
+	[ENOLINK]		= LUSTRE_ENOLINK,
+	[EADV]			= LUSTRE_EADV,
+	[ESRMNT]		= LUSTRE_ESRMNT,
+	[ECOMM]			= LUSTRE_ECOMM,
+	[EPROTO]		= LUSTRE_EPROTO,
+	[EMULTIHOP]		= LUSTRE_EMULTIHOP,
+	[EDOTDOT]		= LUSTRE_EDOTDOT,
+	[EBADMSG]		= LUSTRE_EBADMSG,
+	[EOVERFLOW]		= LUSTRE_EOVERFLOW,
+	[ENOTUNIQ]		= LUSTRE_ENOTUNIQ,
+	[EBADFD]		= LUSTRE_EBADFD,
+	[EREMCHG]		= LUSTRE_EREMCHG,
+	[ELIBACC]		= LUSTRE_ELIBACC,
+	[ELIBBAD]		= LUSTRE_ELIBBAD,
+	[ELIBSCN]		= LUSTRE_ELIBSCN,
+	[ELIBMAX]		= LUSTRE_ELIBMAX,
+	[ELIBEXEC]		= LUSTRE_ELIBEXEC,
+	[EILSEQ]		= LUSTRE_EILSEQ,
+	[ERESTART]		= LUSTRE_ERESTART,
+	[ESTRPIPE]		= LUSTRE_ESTRPIPE,
+	[EUSERS]		= LUSTRE_EUSERS,
+	[ENOTSOCK]		= LUSTRE_ENOTSOCK,
+	[EDESTADDRREQ]		= LUSTRE_EDESTADDRREQ,
+	[EMSGSIZE]		= LUSTRE_EMSGSIZE,
+	[EPROTOTYPE]		= LUSTRE_EPROTOTYPE,
+	[ENOPROTOOPT]		= LUSTRE_ENOPROTOOPT,
+	[EPROTONOSUPPORT]	= LUSTRE_EPROTONOSUPPORT,
+	[ESOCKTNOSUPPORT]	= LUSTRE_ESOCKTNOSUPPORT,
+	[EOPNOTSUPP]		= LUSTRE_EOPNOTSUPP,
+	[EPFNOSUPPORT]		= LUSTRE_EPFNOSUPPORT,
+	[EAFNOSUPPORT]		= LUSTRE_EAFNOSUPPORT,
+	[EADDRINUSE]		= LUSTRE_EADDRINUSE,
+	[EADDRNOTAVAIL]		= LUSTRE_EADDRNOTAVAIL,
+	[ENETDOWN]		= LUSTRE_ENETDOWN,
+	[ENETUNREACH]		= LUSTRE_ENETUNREACH,
+	[ENETRESET]		= LUSTRE_ENETRESET,
+	[ECONNABORTED]		= LUSTRE_ECONNABORTED,
+	[ECONNRESET]		= LUSTRE_ECONNRESET,
+	[ENOBUFS]		= LUSTRE_ENOBUFS,
+	[EISCONN]		= LUSTRE_EISCONN,
+	[ENOTCONN]		= LUSTRE_ENOTCONN,
+	[ESHUTDOWN]		= LUSTRE_ESHUTDOWN,
+	[ETOOMANYREFS]		= LUSTRE_ETOOMANYREFS,
+	[ETIMEDOUT]		= LUSTRE_ETIMEDOUT,
+	[ECONNREFUSED]		= LUSTRE_ECONNREFUSED,
+	[EHOSTDOWN]		= LUSTRE_EHOSTDOWN,
+	[EHOSTUNREACH]		= LUSTRE_EHOSTUNREACH,
+	[EALREADY]		= LUSTRE_EALREADY,
+	[EINPROGRESS]		= LUSTRE_EINPROGRESS,
+	[ESTALE]		= LUSTRE_ESTALE,
+	[EUCLEAN]		= LUSTRE_EUCLEAN,
+	[ENOTNAM]		= LUSTRE_ENOTNAM,
+	[ENAVAIL]		= LUSTRE_ENAVAIL,
+	[EISNAM]		= LUSTRE_EISNAM,
+	[EREMOTEIO]		= LUSTRE_EREMOTEIO,
+	[EDQUOT]		= LUSTRE_EDQUOT,
+	[ENOMEDIUM]		= LUSTRE_ENOMEDIUM,
+	[EMEDIUMTYPE]		= LUSTRE_EMEDIUMTYPE,
+	[ECANCELED]		= LUSTRE_ECANCELED,
+	[ENOKEY]		= LUSTRE_ENOKEY,
+	[EKEYEXPIRED]		= LUSTRE_EKEYEXPIRED,
+	[EKEYREVOKED]		= LUSTRE_EKEYREVOKED,
+	[EKEYREJECTED]		= LUSTRE_EKEYREJECTED,
+	[EOWNERDEAD]		= LUSTRE_EOWNERDEAD,
+	[ENOTRECOVERABLE]	= LUSTRE_ENOTRECOVERABLE,
+	[ERESTARTSYS]		= LUSTRE_ERESTARTSYS,
+	[ERESTARTNOINTR]	= LUSTRE_ERESTARTNOINTR,
+	[ERESTARTNOHAND]	= LUSTRE_ERESTARTNOHAND,
+	[ENOIOCTLCMD]		= LUSTRE_ENOIOCTLCMD,
+	[ERESTART_RESTARTBLOCK]	= LUSTRE_ERESTART_RESTARTBLOCK,
+	[EBADHANDLE]		= LUSTRE_EBADHANDLE,
+	[ENOTSYNC]		= LUSTRE_ENOTSYNC,
+	[EBADCOOKIE]		= LUSTRE_EBADCOOKIE,
+	[ENOTSUPP]		= LUSTRE_ENOTSUPP,
+	[ETOOSMALL]		= LUSTRE_ETOOSMALL,
+	[ESERVERFAULT]		= LUSTRE_ESERVERFAULT,
+	[EBADTYPE]		= LUSTRE_EBADTYPE,
+	[EJUKEBOX]		= LUSTRE_EJUKEBOX,
+	[EIOCBQUEUED]		= LUSTRE_EIOCBQUEUED,
+	[EIOCBRETRY]		= LUSTRE_EIOCBRETRY
+};
+
+static int lustre_errno_ntoh_mapping[] = {
+	[LUSTRE_EPERM]			= EPERM,
+	[LUSTRE_ENOENT]			= ENOENT,
+	[LUSTRE_ESRCH]			= ESRCH,
+	[LUSTRE_EINTR]			= EINTR,
+	[LUSTRE_EIO]			= EIO,
+	[LUSTRE_ENXIO]			= ENXIO,
+	[LUSTRE_E2BIG]			= E2BIG,
+	[LUSTRE_ENOEXEC]		= ENOEXEC,
+	[LUSTRE_EBADF]			= EBADF,
+	[LUSTRE_ECHILD]			= ECHILD,
+	[LUSTRE_EAGAIN]			= EAGAIN,
+	[LUSTRE_ENOMEM]			= ENOMEM,
+	[LUSTRE_EACCES]			= EACCES,
+	[LUSTRE_EFAULT]			= EFAULT,
+	[LUSTRE_ENOTBLK]		= ENOTBLK,
+	[LUSTRE_EBUSY]			= EBUSY,
+	[LUSTRE_EEXIST]			= EEXIST,
+	[LUSTRE_EXDEV]			= EXDEV,
+	[LUSTRE_ENODEV]			= ENODEV,
+	[LUSTRE_ENOTDIR]		= ENOTDIR,
+	[LUSTRE_EISDIR]			= EISDIR,
+	[LUSTRE_EINVAL]			= EINVAL,
+	[LUSTRE_ENFILE]			= ENFILE,
+	[LUSTRE_EMFILE]			= EMFILE,
+	[LUSTRE_ENOTTY]			= ENOTTY,
+	[LUSTRE_ETXTBSY]		= ETXTBSY,
+	[LUSTRE_EFBIG]			= EFBIG,
+	[LUSTRE_ENOSPC]			= ENOSPC,
+	[LUSTRE_ESPIPE]			= ESPIPE,
+	[LUSTRE_EROFS]			= EROFS,
+	[LUSTRE_EMLINK]			= EMLINK,
+	[LUSTRE_EPIPE]			= EPIPE,
+	[LUSTRE_EDOM]			= EDOM,
+	[LUSTRE_ERANGE]			= ERANGE,
+	[LUSTRE_EDEADLK]		= EDEADLK,
+	[LUSTRE_ENAMETOOLONG]		= ENAMETOOLONG,
+	[LUSTRE_ENOLCK]			= ENOLCK,
+	[LUSTRE_ENOSYS]			= ENOSYS,
+	[LUSTRE_ENOTEMPTY]		= ENOTEMPTY,
+	[LUSTRE_ELOOP]			= ELOOP,
+	[LUSTRE_ENOMSG]			= ENOMSG,
+	[LUSTRE_EIDRM]			= EIDRM,
+	[LUSTRE_ECHRNG]			= ECHRNG,
+	[LUSTRE_EL2NSYNC]		= EL2NSYNC,
+	[LUSTRE_EL3HLT]			= EL3HLT,
+	[LUSTRE_EL3RST]			= EL3RST,
+	[LUSTRE_ELNRNG]			= ELNRNG,
+	[LUSTRE_EUNATCH]		= EUNATCH,
+	[LUSTRE_ENOCSI]			= ENOCSI,
+	[LUSTRE_EL2HLT]			= EL2HLT,
+	[LUSTRE_EBADE]			= EBADE,
+	[LUSTRE_EBADR]			= EBADR,
+	[LUSTRE_EXFULL]			= EXFULL,
+	[LUSTRE_ENOANO]			= ENOANO,
+	[LUSTRE_EBADRQC]		= EBADRQC,
+	[LUSTRE_EBADSLT]		= EBADSLT,
+	[LUSTRE_EBFONT]			= EBFONT,
+	[LUSTRE_ENOSTR]			= ENOSTR,
+	[LUSTRE_ENODATA]		= ENODATA,
+	[LUSTRE_ETIME]			= ETIME,
+	[LUSTRE_ENOSR]			= ENOSR,
+	[LUSTRE_ENONET]			= ENONET,
+	[LUSTRE_ENOPKG]			= ENOPKG,
+	[LUSTRE_EREMOTE]		= EREMOTE,
+	[LUSTRE_ENOLINK]		= ENOLINK,
+	[LUSTRE_EADV]			= EADV,
+	[LUSTRE_ESRMNT]			= ESRMNT,
+	[LUSTRE_ECOMM]			= ECOMM,
+	[LUSTRE_EPROTO]			= EPROTO,
+	[LUSTRE_EMULTIHOP]		= EMULTIHOP,
+	[LUSTRE_EDOTDOT]		= EDOTDOT,
+	[LUSTRE_EBADMSG]		= EBADMSG,
+	[LUSTRE_EOVERFLOW]		= EOVERFLOW,
+	[LUSTRE_ENOTUNIQ]		= ENOTUNIQ,
+	[LUSTRE_EBADFD]			= EBADFD,
+	[LUSTRE_EREMCHG]		= EREMCHG,
+	[LUSTRE_ELIBACC]		= ELIBACC,
+	[LUSTRE_ELIBBAD]		= ELIBBAD,
+	[LUSTRE_ELIBSCN]		= ELIBSCN,
+	[LUSTRE_ELIBMAX]		= ELIBMAX,
+	[LUSTRE_ELIBEXEC]		= ELIBEXEC,
+	[LUSTRE_EILSEQ]			= EILSEQ,
+	[LUSTRE_ERESTART]		= ERESTART,
+	[LUSTRE_ESTRPIPE]		= ESTRPIPE,
+	[LUSTRE_EUSERS]			= EUSERS,
+	[LUSTRE_ENOTSOCK]		= ENOTSOCK,
+	[LUSTRE_EDESTADDRREQ]		= EDESTADDRREQ,
+	[LUSTRE_EMSGSIZE]		= EMSGSIZE,
+	[LUSTRE_EPROTOTYPE]		= EPROTOTYPE,
+	[LUSTRE_ENOPROTOOPT]		= ENOPROTOOPT,
+	[LUSTRE_EPROTONOSUPPORT]	= EPROTONOSUPPORT,
+	[LUSTRE_ESOCKTNOSUPPORT]	= ESOCKTNOSUPPORT,
+	[LUSTRE_EOPNOTSUPP]		= EOPNOTSUPP,
+	[LUSTRE_EPFNOSUPPORT]		= EPFNOSUPPORT,
+	[LUSTRE_EAFNOSUPPORT]		= EAFNOSUPPORT,
+	[LUSTRE_EADDRINUSE]		= EADDRINUSE,
+	[LUSTRE_EADDRNOTAVAIL]		= EADDRNOTAVAIL,
+	[LUSTRE_ENETDOWN]		= ENETDOWN,
+	[LUSTRE_ENETUNREACH]		= ENETUNREACH,
+	[LUSTRE_ENETRESET]		= ENETRESET,
+	[LUSTRE_ECONNABORTED]		= ECONNABORTED,
+	[LUSTRE_ECONNRESET]		= ECONNRESET,
+	[LUSTRE_ENOBUFS]		= ENOBUFS,
+	[LUSTRE_EISCONN]		= EISCONN,
+	[LUSTRE_ENOTCONN]		= ENOTCONN,
+	[LUSTRE_ESHUTDOWN]		= ESHUTDOWN,
+	[LUSTRE_ETOOMANYREFS]		= ETOOMANYREFS,
+	[LUSTRE_ETIMEDOUT]		= ETIMEDOUT,
+	[LUSTRE_ECONNREFUSED]		= ECONNREFUSED,
+	[LUSTRE_EHOSTDOWN]		= EHOSTDOWN,
+	[LUSTRE_EHOSTUNREACH]		= EHOSTUNREACH,
+	[LUSTRE_EALREADY]		= EALREADY,
+	[LUSTRE_EINPROGRESS]		= EINPROGRESS,
+	[LUSTRE_ESTALE]			= ESTALE,
+	[LUSTRE_EUCLEAN]		= EUCLEAN,
+	[LUSTRE_ENOTNAM]		= ENOTNAM,
+	[LUSTRE_ENAVAIL]		= ENAVAIL,
+	[LUSTRE_EISNAM]			= EISNAM,
+	[LUSTRE_EREMOTEIO]		= EREMOTEIO,
+	[LUSTRE_EDQUOT]			= EDQUOT,
+	[LUSTRE_ENOMEDIUM]		= ENOMEDIUM,
+	[LUSTRE_EMEDIUMTYPE]		= EMEDIUMTYPE,
+	[LUSTRE_ECANCELED]		= ECANCELED,
+	[LUSTRE_ENOKEY]			= ENOKEY,
+	[LUSTRE_EKEYEXPIRED]		= EKEYEXPIRED,
+	[LUSTRE_EKEYREVOKED]		= EKEYREVOKED,
+	[LUSTRE_EKEYREJECTED]		= EKEYREJECTED,
+	[LUSTRE_EOWNERDEAD]		= EOWNERDEAD,
+	[LUSTRE_ENOTRECOVERABLE]	= ENOTRECOVERABLE,
+	[LUSTRE_ERESTARTSYS]		= ERESTARTSYS,
+	[LUSTRE_ERESTARTNOINTR]		= ERESTARTNOINTR,
+	[LUSTRE_ERESTARTNOHAND]		= ERESTARTNOHAND,
+	[LUSTRE_ENOIOCTLCMD]		= ENOIOCTLCMD,
+	[LUSTRE_ERESTART_RESTARTBLOCK]	= ERESTART_RESTARTBLOCK,
+	[LUSTRE_EBADHANDLE]		= EBADHANDLE,
+	[LUSTRE_ENOTSYNC]		= ENOTSYNC,
+	[LUSTRE_EBADCOOKIE]		= EBADCOOKIE,
+	[LUSTRE_ENOTSUPP]		= ENOTSUPP,
+	[LUSTRE_ETOOSMALL]		= ETOOSMALL,
+	[LUSTRE_ESERVERFAULT]		= ESERVERFAULT,
+	[LUSTRE_EBADTYPE]		= EBADTYPE,
+	[LUSTRE_EJUKEBOX]		= EJUKEBOX,
+	[LUSTRE_EIOCBQUEUED]		= EIOCBQUEUED,
+	[LUSTRE_EIOCBRETRY]		= EIOCBRETRY
+};
+
+unsigned int lustre_errno_hton(unsigned int h)
+{
+	unsigned int n;
+
+	if (h == 0) {
+		n = 0;
+	} else if (h < ARRAY_SIZE(lustre_errno_hton_mapping)) {
+		n = lustre_errno_hton_mapping[h];
+		if (n == 0)
+			goto generic;
+	} else {
+generic:
+		/*
+		 * A generic errno is better than the unknown one that could
+		 * mean anything to a different host.
+		 */
+		n = LUSTRE_EIO;
+	}
+
+	return n;
+}
+EXPORT_SYMBOL(lustre_errno_hton);
+
+unsigned int lustre_errno_ntoh(unsigned int n)
+{
+	unsigned int h;
+
+	if (n == 0) {
+		h = 0;
+	} else if (n < ARRAY_SIZE(lustre_errno_ntoh_mapping)) {
+		h = lustre_errno_ntoh_mapping[n];
+		if (h == 0)
+			goto generic;
+	} else {
+generic:
+		/*
+		 * Similar to the situation in lustre_errno_hton(), an unknown
+		 * network errno could coincide with anything.  Hence, it is
+		 * better to return a generic errno.
+		 */
+		h = EIO;
+	}
+
+	return h;
+}
+EXPORT_SYMBOL(lustre_errno_ntoh);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index de3f0db..5f1b889 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -400,7 +400,8 @@ int ptlrpc_send_reply(struct ptlrpc_request *req, int flags)
 		req->rq_type = PTL_RPC_MSG_REPLY;
 
 	lustre_msg_set_type(req->rq_repmsg, req->rq_type);
-	lustre_msg_set_status(req->rq_repmsg, req->rq_status);
+	lustre_msg_set_status(req->rq_repmsg,
+			      ptlrpc_status_hton(req->rq_status));
 	lustre_msg_set_opc(req->rq_repmsg,
 		req->rq_reqmsg ? lustre_msg_get_opc(req->rq_reqmsg) : 0);
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index 1437636..be246d4 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -642,6 +642,9 @@ static inline int lustre_unpack_ptlrpc_body_v2(struct ptlrpc_request *req,
 		 return -EINVAL;
 	}
 
+	if (!inout)
+		pb->pb_status = ptlrpc_status_ntoh(pb->pb_status);
+
 	return 0;
 }
 
-- 
1.7.9.5

