Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaC1Nwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:52:36 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45102 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaC1Nwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:52:33 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 06/28] ktap: add include/ktap_arch.h and error header file
Date: Fri, 28 Mar 2014 09:47:27 -0400
Message-Id: <1396014469-5937-7-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple arch related definition and error msg definition.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/include/ktap_arch.h   |  33 ++++++++++
 tools/ktap/include/ktap_err.h    |  11 ++++
 tools/ktap/include/ktap_errmsg.h | 135 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+)
 create mode 100644 tools/ktap/include/ktap_arch.h
 create mode 100644 tools/ktap/include/ktap_err.h
 create mode 100644 tools/ktap/include/ktap_errmsg.h

diff --git a/tools/ktap/include/ktap_arch.h b/tools/ktap/include/ktap_arch.h
new file mode 100644
index 0000000..aeb7036
--- /dev/null
+++ b/tools/ktap/include/ktap_arch.h
@@ -0,0 +1,33 @@
+#ifndef __KTAP_ARCH__
+#define __KTAP_ARCH__
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#if defined(__LITTLE_ENDIAN)
+#define KP_LE				1
+#define KP_BE				0
+#define KP_ENDIAN_SELECT(le, be)        le
+#elif defined(__BIG_ENDIAN)
+#define KP_LE				0
+#define KP_BE				1
+#define KP_ENDIAN_SELECT(le, be)        be
+#endif
+
+#else /* __KERNEL__ */
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define KP_LE				1
+#define KP_BE				0
+#define KP_ENDIAN_SELECT(le, be)        le
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define KP_LE				0
+#define KP_BE				1
+#define KP_ENDIAN_SELECT(le, be)        be
+#else
+#error "could not determine byte order"
+#endif
+
+#endif
+#endif
diff --git a/tools/ktap/include/ktap_err.h b/tools/ktap/include/ktap_err.h
new file mode 100644
index 0000000..b7e1a31
--- /dev/null
+++ b/tools/ktap/include/ktap_err.h
@@ -0,0 +1,11 @@
+#ifndef __KTAP_ERR_H__
+#define __KTAP_ERR_H__
+
+typedef enum {
+#define ERRDEF(name, msg) \
+	KP_ERR_##name, KP_ERR_##name##_ = KP_ERR_##name + sizeof(msg)-1,
+#include "ktap_errmsg.h"
+	KP_ERR__MAX
+} ErrMsg;
+
+#endif
diff --git a/tools/ktap/include/ktap_errmsg.h b/tools/ktap/include/ktap_errmsg.h
new file mode 100644
index 0000000..fd7a081
--- /dev/null
+++ b/tools/ktap/include/ktap_errmsg.h
@@ -0,0 +1,135 @@
+/*
+ * VM error messages.
+ * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+ * Copyright (C) 2005-2014 Mike Pall.
+ */
+
+/* Basic error handling. */
+ERRDEF(ERRMEM,	"not enough memory")
+ERRDEF(ERRERR,	"error in error handling")
+
+/* Allocations. */
+ERRDEF(STROV,	"string length overflow")
+ERRDEF(UDATAOV,	"userdata length overflow")
+ERRDEF(STKOV,	"stack overflow")
+ERRDEF(STKOVM,	"stack overflow (%s)")
+ERRDEF(TABOV,	"table overflow")
+
+/* Table indexing. */
+ERRDEF(NANIDX,	"table index is NaN")
+ERRDEF(NILIDX,	"table index is nil")
+ERRDEF(NEXTIDX,	"invalid key to " KTAP_QL("next"))
+
+/* Metamethod resolving. */
+ERRDEF(BADCALL,	"attempt to call a %s value")
+ERRDEF(BADOPRT,	"attempt to %s %s " KTAP_QS " (a %s value)")
+ERRDEF(BADOPRV,	"attempt to %s a %s value")
+ERRDEF(BADCMPT,	"attempt to compare %s with %s")
+ERRDEF(BADCMPV,	"attempt to compare two %s values")
+ERRDEF(GETLOOP,	"loop in gettable")
+ERRDEF(SETLOOP,	"loop in settable")
+ERRDEF(OPCALL,	"call")
+ERRDEF(OPINDEX,	"index")
+ERRDEF(OPARITH,	"perform arithmetic on")
+ERRDEF(OPCAT,	"concatenate")
+ERRDEF(OPLEN,	"get length of")
+
+/* Type checks. */
+ERRDEF(BADSELF,	"calling " KTAP_QS " on bad self (%s)")
+ERRDEF(BADARG,	"bad argument #%d to " KTAP_QS " (%s)")
+ERRDEF(BADTYPE,	"%s expected, got %s")
+ERRDEF(BADVAL,	"invalid value")
+ERRDEF(NOVAL,	"value expected")
+ERRDEF(NOCORO,	"coroutine expected")
+ERRDEF(NOTABN,	"nil or table expected")
+ERRDEF(NOLFUNC,	"ktap function expected")
+ERRDEF(NOFUNCL,	"function or level expected")
+ERRDEF(NOSFT,	"string/function/table expected")
+ERRDEF(NOPROXY,	"boolean or proxy expected")
+ERRDEF(FORINIT,	KTAP_QL("for") " initial value must be a number")
+ERRDEF(FORLIM,	KTAP_QL("for") " limit must be a number")
+ERRDEF(FORSTEP,	KTAP_QL("for") " step must be a number")
+
+/* C API checks. */
+ERRDEF(NOENV,	"no calling environment")
+ERRDEF(CYIELD,	"attempt to yield across C-call boundary")
+ERRDEF(BADLU,	"bad light userdata pointer")
+
+/* Standard library function errors. */
+ERRDEF(ASSERT,	"assertion failed!")
+ERRDEF(PROTMT,	"cannot change a protected metatable")
+ERRDEF(UNPACK,	"too many results to unpack")
+ERRDEF(RDRSTR,	"reader function must return a string")
+ERRDEF(PRTOSTR,	KTAP_QL("tostring") " must return a string to " KTAP_QL("print"))
+ERRDEF(IDXRNG,	"index out of range")
+ERRDEF(BASERNG,	"base out of range")
+ERRDEF(LVLRNG,	"level out of range")
+ERRDEF(INVLVL,	"invalid level")
+ERRDEF(INVOPT,	"invalid option")
+ERRDEF(INVOPTM,	"invalid option " KTAP_QS)
+ERRDEF(INVFMT,	"invalid format")
+ERRDEF(SETFENV,	KTAP_QL("setfenv") " cannot change environment of given object")
+ERRDEF(CORUN,	"cannot resume running coroutine")
+ERRDEF(CODEAD,	"cannot resume dead coroutine")
+ERRDEF(COSUSP,	"cannot resume non-suspended coroutine")
+ERRDEF(TABINS,	"wrong number of arguments to " KTAP_QL("insert"))
+ERRDEF(TABCAT,	"invalid value (%s) at index %d in table for " KTAP_QL("concat"))
+ERRDEF(TABSORT,	"invalid order function for sorting")
+ERRDEF(IOCLFL,	"attempt to use a closed file")
+ERRDEF(IOSTDCL,	"standard file is closed")
+ERRDEF(OSUNIQF,	"unable to generate a unique filename")
+ERRDEF(OSDATEF,	"field " KTAP_QS " missing in date table")
+ERRDEF(STRDUMP,	"unable to dump given function")
+ERRDEF(STRSLC,	"string slice too long")
+ERRDEF(STRPATB,	"missing " KTAP_QL("[") " after " KTAP_QL("%f") " in pattern")
+ERRDEF(STRPATC,	"invalid pattern capture")
+ERRDEF(STRPATE,	"malformed pattern (ends with " KTAP_QL("%") ")")
+ERRDEF(STRPATM,	"malformed pattern (missing " KTAP_QL("]") ")")
+ERRDEF(STRPATU,	"unbalanced pattern")
+ERRDEF(STRPATX,	"pattern too complex")
+ERRDEF(STRCAPI,	"invalid capture index")
+ERRDEF(STRCAPN,	"too many captures")
+ERRDEF(STRCAPU,	"unfinished capture")
+ERRDEF(STRFMT,	"invalid option " KTAP_QS " to " KTAP_QL("format"))
+ERRDEF(STRGSRV,	"invalid replacement value (a %s)")
+ERRDEF(BADMODN,	"name conflict for module " KTAP_QS)
+ERRDEF(JITOPT,	"unknown or malformed optimization flag " KTAP_QS)
+
+/* Lexer/parser errors. */
+ERRDEF(XMODE,	"attempt to load chunk with wrong mode")
+ERRDEF(XNEAR,	"%s near " KTAP_QS)
+ERRDEF(XLINES,	"chunk has too many lines")
+ERRDEF(XLEVELS,	"chunk has too many syntax levels")
+ERRDEF(XNUMBER,	"malformed number")
+ERRDEF(XLSTR,	"unfinished long string")
+ERRDEF(XLCOM,	"unfinished long comment")
+ERRDEF(XSTR,	"unfinished string")
+ERRDEF(XESC,	"invalid escape sequence")
+ERRDEF(XLDELIM,	"invalid long string delimiter")
+ERRDEF(XTOKEN,	KTAP_QS " expected")
+ERRDEF(XJUMP,	"control structure too long")
+ERRDEF(XSLOTS,	"function or expression too complex")
+ERRDEF(XLIMC,	"chunk has more than %d local variables")
+ERRDEF(XLIMM,	"main function has more than %d %s")
+ERRDEF(XLIMF,	"function at line %d has more than %d %s")
+ERRDEF(XMATCH,	KTAP_QS " expected (to close " KTAP_QS " at line %d)")
+ERRDEF(XFIXUP,	"function too long for return fixup")
+ERRDEF(XPARAM,	"<name> or " KTAP_QL("...") " expected")
+ERRDEF(XAMBIG,	"ambiguous syntax (function call x new statement)")
+ERRDEF(XFUNARG,	"function arguments expected")
+ERRDEF(XSYMBOL,	"unexpected symbol")
+ERRDEF(XDOTS,	"cannot use " KTAP_QL("...") " outside a vararg function")
+ERRDEF(XSYNTAX,	"syntax error")
+ERRDEF(XFOR,	KTAP_QL("=") " or " KTAP_QL("in") " expected")
+ERRDEF(XBREAK,	"no loop to break")
+ERRDEF(XLUNDEF,	"undefined label " KTAP_QS)
+ERRDEF(XLDUP,	"duplicate label " KTAP_QS)
+ERRDEF(XGSCOPE,	"<goto %s> jumps into the scope of local " KTAP_QS)
+ERRDEF(XEVENTDEF,"cannot parse eventdef " KTAP_QS)
+
+/* Bytecode reader errors. */
+ERRDEF(BCFMT,	"cannot load incompatible bytecode")
+ERRDEF(BCBAD,	"cannot load malformed bytecode")
+
+#undef ERRDEF
+
-- 
1.8.1.4

