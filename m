Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaC2PZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:25:04 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54028 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaC2PY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:24:56 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 10/29] ktap: add string handling code(kernel/trace/ktap/kp_[str|mempool].[c|h])
Date: Fri, 28 Mar 2014 10:45:05 -0400
Message-Id: <1396017924-7754-11-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exposed functions:

1). kp_str_new:
        Return a interned string, failure if out of memory
        or exceed max string number(default 9999).
        It allocate memory from mempool, not kmalloc, because we
        don't want dynamic allocate string in probe context.

2). kp_str_resize:
        Initizate interned hash table g->strhash.

3). kp_str_fmt:
        Return a format string, called from 'printf' built-in function.

4). kp_mempool_init/kp_mempool_destroy/kp_mempool_alloc
        mempool is only service for string allocation currently.

All string in ktap is interned, it means ktap keeps
a single copy for any string. Whenever a new string appears, ktap
checks whether it already has a copy of that string and, if so,
reuses that copy. Internalization makes operations like string
comparison and table indexing very fast, but it slows down string creation.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 kernel/trace/ktap/kp_mempool.c |  94 +++++++++++
 kernel/trace/ktap/kp_mempool.h |   8 +
 kernel/trace/ktap/kp_str.c     | 360 +++++++++++++++++++++++++++++++++++++++++
 kernel/trace/ktap/kp_str.h     |  13 ++
 4 files changed, 475 insertions(+)
 create mode 100644 kernel/trace/ktap/kp_mempool.c
 create mode 100644 kernel/trace/ktap/kp_mempool.h
 create mode 100644 kernel/trace/ktap/kp_str.c
 create mode 100644 kernel/trace/ktap/kp_str.h

diff --git a/kernel/trace/ktap/kp_mempool.c b/kernel/trace/ktap/kp_mempool.c
new file mode 100644
index 0000000..37fb8e4
--- /dev/null
+++ b/kernel/trace/ktap/kp_mempool.c
@@ -0,0 +1,94 @@
+/*
+ * kp_mempool.c - ktap memory pool, service for string allocation
+ *
+ * This file is part of ktap by Jovi Zhangwei.
+ *
+ * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+ *
+ * ktap is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * ktap is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <uapi/ktap/ktap_types.h>
+#include "kp_obj.h"
+#include "kp_str.h"
+
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include "ktap.h"
+
+
+/*
+ * allocate memory from mempool, the allocated memory will be free
+ * util ktap exit.
+ * TODO: lock-free allocation
+ */
+void *kp_mempool_alloc(ktap_state_t *ks, int size)
+{
+	ktap_global_state_t *g = G(ks);
+	void *mempool = g->mempool;
+	void *freepos = g->mp_freepos;
+	void *addr;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	arch_spin_lock(&g->mp_lock);
+
+	if (unlikely((unsigned long)((char *)freepos + size)) >
+		     (unsigned long)((char *)mempool + g->mp_size)) {
+		addr = NULL;
+		goto out;
+	}
+
+	addr = freepos;
+	g->mp_freepos = (char *)freepos + size;
+ out:
+
+	arch_spin_unlock(&g->mp_lock);
+	local_irq_restore(flags);
+	return addr;
+}
+
+/*
+ * destroy mempool.
+ */
+void kp_mempool_destroy(ktap_state_t *ks)
+{
+	ktap_global_state_t *g = G(ks);
+
+	if (!g->mempool)
+		return;
+
+	vfree(g->mempool);
+	g->mempool = NULL;
+	g->mp_freepos = NULL;
+	g->mp_size = 0;
+}
+
+/*
+ * pre-allocate size Kbytes memory pool.
+ */
+int kp_mempool_init(ktap_state_t *ks, int size)
+{
+	ktap_global_state_t *g = G(ks);
+
+	g->mempool = vmalloc(size * 1024);
+	if (!g->mempool)
+		return -ENOMEM;
+
+	g->mp_freepos = g->mempool;
+	g->mp_size = size * 1024;
+	g->mp_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+	return 0;
+}
+
diff --git a/kernel/trace/ktap/kp_mempool.h b/kernel/trace/ktap/kp_mempool.h
new file mode 100644
index 0000000..3eabf5e
--- /dev/null
+++ b/kernel/trace/ktap/kp_mempool.h
@@ -0,0 +1,8 @@
+#ifndef __KTAP_MEMPOOL_H__
+#define __KTAP_MEMPOOL_H__
+
+void *kp_mempool_alloc(ktap_state_t *ks, int size);
+void kp_mempool_destroy(ktap_state_t *ks);
+int kp_mempool_init(ktap_state_t *ks, int size);
+
+#endif /* __KTAP_MEMPOOL_H__ */
diff --git a/kernel/trace/ktap/kp_str.c b/kernel/trace/ktap/kp_str.c
new file mode 100644
index 0000000..9d2e741
--- /dev/null
+++ b/kernel/trace/ktap/kp_str.c
@@ -0,0 +1,360 @@
+/*
+ * kp_str.c - ktap string data struction manipulation
+ *
+ * This file is part of ktap by Jovi Zhangwei.
+ *
+ * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+ *
+ * Adapted from luajit and lua interpreter.
+ * Copyright (C) 2005-2014 Mike Pall.
+ * Copyright (C) 1994-2008 Lua.org, PUC-Rio.
+ *
+ * ktap is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * ktap is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <uapi/ktap/ktap_types.h>
+#include "kp_obj.h"
+#include "kp_str.h"
+#include "kp_mempool.h"
+
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include "ktap.h"
+#include "kp_transport.h"
+#include "kp_vm.h"
+#include "kp_events.h"
+
+/* Fast string data comparison. Caveat: unaligned access to 1st string! */
+static __always_inline int str_fastcmp(const char *a, const char *b, int len)
+{
+	int i = 0;
+
+	kp_assert(len > 0);
+	kp_assert((((uintptr_t)a + len - 1)&(PAGE_SIZE - 1)) <= PAGE_SIZE - 4);
+
+	do {  /* Note: innocuous access up to end of string + 3. */
+		uint32_t v = *(uint32_t *)(a + i) ^ *(const uint32_t *)(b + i);
+		if (v) {
+			i -= len;
+#if KP_LE
+			return (int32_t)i >= -3 ? (v << (32 + (i << 3))) : 1;
+#else
+			return (int32_t)i >= -3 ? (v >> (32 + (i << 3))) : 1;
+#endif
+		}
+		i += 4;
+	} while (i < len);
+	return 0;
+}
+
+
+//TODO: change hash algo
+
+#define STRING_HASHLIMIT	5
+static __always_inline unsigned int kp_str_hash(const char *str, size_t len)
+{
+	unsigned int h = 201236 ^ len;
+	size_t step = (len >> STRING_HASHLIMIT) + 1;
+	size_t l1;
+
+	for (l1 = len; l1 >= step; l1 -= step)
+		h = h ^ ((h<<5) + (h>>2) + (u8)(str[l1 - 1]));
+
+	return h;
+}
+
+
+/*
+ * resizes the string table
+ */
+int kp_str_resize(ktap_state_t *ks, int newmask)
+{
+	ktap_global_state_t *g = G(ks);
+	ktap_str_t **newhash;
+
+	newhash = kp_zalloc(ks, (newmask + 1) * sizeof(ktap_str_t *));
+	if (!newhash)
+		return -ENOMEM;
+
+	g->strmask = newmask;
+	g->strhash = newhash;
+	return 0;
+}
+
+/*
+ * Intern a string and return string object.
+ */
+ktap_str_t *kp_str_new(ktap_state_t *ks, const char *str, size_t len)
+{
+	ktap_global_state_t *g = G(ks);
+	ktap_str_t *s;
+	ktap_obj_t *o;
+	unsigned int h = kp_str_hash(str, len);
+	unsigned long flags;
+
+	if (len >= KP_MAX_STR)
+		return NULL;
+
+	local_irq_save(flags);
+	arch_spin_lock(&g->str_lock);
+
+	o = (ktap_obj_t *)g->strhash[h & g->strmask];
+	if (likely((((uintptr_t)str+len-1) & (PAGE_SIZE-1)) <= PAGE_SIZE-4)) {
+		while (o != NULL) {
+			ktap_str_t *sx = (ktap_str_t *)o;
+			if (sx->len == len &&
+			    !str_fastcmp(str, getstr(sx), len)) {
+				arch_spin_unlock(&g->str_lock);
+				local_irq_restore(flags);
+				return sx; /* Return existing string. */
+			}
+			o = gch(o)->nextgc;
+		}
+	} else { /* Slow path: end of string is too close to a page boundary */
+		while (o != NULL) {
+			ktap_str_t *sx = (ktap_str_t *)o;
+			if (sx->len == len &&
+			    !memcmp(str, getstr(sx), len)) {
+				arch_spin_unlock(&g->str_lock);
+				local_irq_restore(flags);
+				return sx; /* Return existing string. */
+			}
+			o = gch(o)->nextgc;
+		}
+	}
+
+	/* create a new string, allocate it from mempool, not use kmalloc. */
+	s = kp_mempool_alloc(ks, sizeof(ktap_str_t) + len + 1);
+	if (unlikely(!s))
+		goto out;
+	s->gct = ~KTAP_TSTR;
+	s->len = len;
+	s->hash = h;
+	s->reserved = 0;
+	memcpy(s + 1, str, len);
+	((char *)(s + 1))[len] = '\0';  /* ending 0 */
+
+	/* Add it to string hash table */
+	h &= g->strmask;
+	s->nextgc = (ktap_obj_t *)g->strhash[h];
+	g->strhash[h] = s;
+	if (g->strnum++ > KP_MAX_STRNUM) {
+		kp_error(ks, "exceed max string number %d\n", KP_MAX_STRNUM);
+		s = NULL;
+	}
+
+ out:
+	arch_spin_unlock(&g->str_lock);
+	local_irq_restore(flags);
+	return s; /* Return newly interned string. */
+}
+
+void kp_str_freeall(ktap_state_t *ks)
+{
+	/* don't need to free string in here, it will handled by mempool */
+	kp_free(ks, G(ks)->strhash);
+}
+
+/* kp_str_fmt - printf implementation */
+
+/* macro to `unsign' a character */
+#define uchar(c)	((unsigned char)(c))
+
+#define L_ESC		'%'
+
+/* valid flags in a format specification */
+#define FLAGS	"-+ #0"
+
+#define INTFRMLEN	"ll"
+#define INTFRM_T	long long
+
+/*
+ * maximum size of each format specification (such as '%-099.99d')
+ * (+10 accounts for %99.99x plus margin of error)
+ */
+#define MAX_FORMAT	(sizeof(FLAGS) + sizeof(INTFRMLEN) + 10)
+
+static const char *scanformat(ktap_state_t *ks, const char *strfrmt, char *form)
+{
+	const char *p = strfrmt;
+	while (*p != '\0' && strchr(FLAGS, *p) != NULL)
+		p++;  /* skip flags */
+
+	if ((size_t)(p - strfrmt) >= sizeof(FLAGS)/sizeof(char)) {
+		kp_error(ks, "invalid format (repeated flags)\n");
+		return NULL;
+	}
+
+	if (isdigit(uchar(*p)))
+		p++;  /* skip width */
+
+	if (isdigit(uchar(*p)))
+		p++;  /* (2 digits at most) */
+
+	if (*p == '.') {
+		p++;
+		if (isdigit(uchar(*p)))
+			p++;  /* skip precision */
+		if (isdigit(uchar(*p)))
+			p++;  /* (2 digits at most) */
+	}
+
+	if (isdigit(uchar(*p))) {
+		kp_error(ks, "invalid format (width or precision too long)\n");
+		return NULL;
+	}
+
+	*(form++) = '%';
+	memcpy(form, strfrmt, (p - strfrmt + 1) * sizeof(char));
+	form += p - strfrmt + 1;
+	*form = '\0';
+	return p;
+}
+
+
+/*
+ * add length modifier into formats
+ */
+static void addlenmod(char *form, const char *lenmod)
+{
+	size_t l = strlen(form);
+	size_t lm = strlen(lenmod);
+	char spec = form[l - 1];
+
+	strcpy(form + l - 1, lenmod);
+	form[l + lm - 1] = spec;
+	form[l + lm] = '\0';
+}
+
+
+static void arg_error(ktap_state_t *ks, int narg, const char *extramsg)
+{
+	kp_error(ks, "bad argument #%d: (%s)\n", narg, extramsg);
+}
+
+int kp_str_fmt(ktap_state_t *ks, struct trace_seq *seq)
+{
+	int arg = 1;
+	size_t sfl;
+	ktap_val_t *arg_fmt = kp_arg(ks, 1);
+	int argnum = kp_arg_nr(ks);
+	const char *strfrmt, *strfrmt_end;
+
+	strfrmt = svalue(arg_fmt);
+	sfl = rawtsvalue(arg_fmt)->len;
+	strfrmt_end = strfrmt + sfl;
+
+	while (strfrmt < strfrmt_end) {
+		if (*strfrmt != L_ESC)
+			trace_seq_putc(seq, *strfrmt++);
+		else if (*++strfrmt == L_ESC)
+			trace_seq_putc(seq, *strfrmt++);
+		else { /* format item */
+			char form[MAX_FORMAT];
+
+			if (++arg > argnum) {
+				arg_error(ks, arg, "no value");
+				return -1;
+			}
+
+			strfrmt = scanformat(ks, strfrmt, form);
+			switch (*strfrmt++) {
+			case 'c':
+				kp_arg_checknumber(ks, arg);
+
+				trace_seq_printf(seq, form,
+						 nvalue(kp_arg(ks, arg)));
+				break;
+			case 'd':  case 'i': {
+				ktap_number n;
+				INTFRM_T ni;
+
+				kp_arg_checknumber(ks, arg);
+
+				n = nvalue(kp_arg(ks, arg));
+				ni = (INTFRM_T)n;
+				addlenmod(form, INTFRMLEN);
+				trace_seq_printf(seq, form, ni);
+				break;
+			}
+			case 'p': {
+				char str[KSYM_SYMBOL_LEN];
+
+				kp_arg_checknumber(ks, arg);
+
+				SPRINT_SYMBOL(str, nvalue(kp_arg(ks, arg)));
+				_trace_seq_puts(seq, str);
+				break;
+			}
+			case 'o':  case 'u':  case 'x':  case 'X': {
+				ktap_number n;
+				unsigned INTFRM_T ni;
+
+				kp_arg_checknumber(ks, arg);
+
+				n = nvalue(kp_arg(ks, arg));
+				ni = (unsigned INTFRM_T)n;
+				addlenmod(form, INTFRMLEN);
+				trace_seq_printf(seq, form, ni);
+				break;
+			}
+			case 's': {
+				ktap_val_t *v = kp_arg(ks, arg);
+				const char *s;
+				size_t l;
+
+				if (is_nil(v)) {
+					_trace_seq_puts(seq, "nil");
+					return 0;
+				}
+
+				if (is_eventstr(v)) {
+					const char *str = kp_event_tostr(ks);
+					if (!str)
+						return  -1;
+					_trace_seq_puts(seq,
+						kp_event_tostr(ks));
+					return 0;
+				}
+
+				kp_arg_checkstring(ks, arg);
+
+				s = svalue(v);
+				l = rawtsvalue(v)->len;
+				if (!strchr(form, '.') && l >= 100) {
+					/*
+					 * no precision and string is too long
+					 * to be formatted;
+					 * keep original string
+					 */
+					_trace_seq_puts(seq, s);
+					break;
+				} else {
+					trace_seq_printf(seq, form, s);
+					break;
+				}
+			}
+			default: /* also treat cases `pnLlh' */
+				kp_error(ks, "invalid option " KTAP_QL("%%%c")
+					     " to " KTAP_QL("format"),
+					     *(strfrmt - 1));
+				return -1;
+			}
+		}
+	}
+
+	return 0;
+}
+
diff --git a/kernel/trace/ktap/kp_str.h b/kernel/trace/ktap/kp_str.h
new file mode 100644
index 0000000..4510e4a
--- /dev/null
+++ b/kernel/trace/ktap/kp_str.h
@@ -0,0 +1,13 @@
+#ifndef __KTAP_STR_H__
+#define __KTAP_STR_H__
+
+int kp_str_resize(ktap_state_t *ks, int newmask);
+void kp_str_freeall(ktap_state_t *ks);
+ktap_str_t * kp_str_new(ktap_state_t *ks, const char *str, size_t len);
+
+#define kp_str_newz(ks, s)	(kp_str_new(ks, s, strlen(s)))
+
+#include <linux/trace_seq.h>
+int kp_str_fmt(ktap_state_t *ks, struct trace_seq *seq);
+
+#endif /* __KTAP_STR_H__ */
-- 
1.8.1.4

