Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaH0CbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:31:00 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38018 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbaH0Cay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:30:54 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v7 net-next 21/28] samples: bpf: add mini eBPF library to manipulate maps and programs
Date: Tue, 26 Aug 2014 19:29:35 -0700
Message-Id: <1409106582-10095-22-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the library includes a trivial set of BPF syscall wrappers:

int bpf_create_map(int key_size, int value_size, int max_entries);

int bpf_update_elem(int fd, void *key, void *value);

int bpf_lookup_elem(int fd, void *key, void *value);

int bpf_delete_elem(int fd, void *key);

int bpf_get_next_key(int fd, void *key, void *next_key);

int bpf_prog_load(enum bpf_prog_type prog_type,
		  const struct sock_filter_int *insns, int insn_len,
		  const char *license);

bpf_prog_load() stores verifier log into global bpf_log_buf[] array

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 samples/bpf/libbpf.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++
 samples/bpf/libbpf.h |   21 ++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 samples/bpf/libbpf.c
 create mode 100644 samples/bpf/libbpf.h

diff --git a/samples/bpf/libbpf.c b/samples/bpf/libbpf.c
new file mode 100644
index 000000000000..cae0c734274c
--- /dev/null
+++ b/samples/bpf/libbpf.c
@@ -0,0 +1,89 @@
+/* eBPF mini library */
+#include <stdlib.h>
+#include <stdio.h>
+#include <linux/unistd.h>
+#include <unistd.h>
+#include <string.h>
+#include <linux/netlink.h>
+#include <linux/bpf.h>
+#include <errno.h>
+#include "libbpf.h"
+
+int bpf_create_map(enum bpf_map_type map_type, int key_size, int value_size,
+		   int max_entries)
+{
+	union bpf_attr attr = {
+		.map_type = map_type,
+		.key_size = key_size,
+		.value_size = value_size,
+		.max_entries = max_entries
+	};
+
+	return syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
+}
+
+int bpf_update_elem(int fd, void *key, void *value)
+{
+	union bpf_attr attr = {
+		.map_fd = fd,
+		.key = key,
+		.value = value,
+	};
+
+	return syscall(__NR_bpf, BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
+}
+
+int bpf_lookup_elem(int fd, void *key, void *value)
+{
+	union bpf_attr attr = {
+		.map_fd = fd,
+		.key = key,
+		.value = value,
+	};
+
+	return syscall(__NR_bpf, BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
+}
+
+int bpf_delete_elem(int fd, void *key)
+{
+	union bpf_attr attr = {
+		.map_fd = fd,
+		.key = key,
+	};
+
+	return syscall(__NR_bpf, BPF_MAP_DELETE_ELEM, &attr, sizeof(attr));
+}
+
+int bpf_get_next_key(int fd, void *key, void *next_key)
+{
+	union bpf_attr attr = {
+		.map_fd = fd,
+		.key = key,
+		.next_key = next_key,
+	};
+
+	return syscall(__NR_bpf, BPF_MAP_GET_NEXT_KEY, &attr, sizeof(attr));
+}
+
+#define ROUND_UP(x, n) (((x) + (n) - 1u) & ~((n) - 1u))
+
+char bpf_log_buf[LOG_BUF_SIZE];
+
+int bpf_prog_load(enum bpf_prog_type prog_type,
+		  const struct bpf_insn *insns, int prog_len,
+		  const char *license)
+{
+	union bpf_attr attr = {
+		.prog_type = prog_type,
+		.insns = insns,
+		.insn_cnt = prog_len / sizeof(struct bpf_insn),
+		.license = license,
+		.log_buf = bpf_log_buf,
+		.log_size = LOG_BUF_SIZE,
+		.log_level = 1,
+	};
+
+	bpf_log_buf[0] = 0;
+
+	return syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
+}
diff --git a/samples/bpf/libbpf.h b/samples/bpf/libbpf.h
new file mode 100644
index 000000000000..b19e39794291
--- /dev/null
+++ b/samples/bpf/libbpf.h
@@ -0,0 +1,21 @@
+/* eBPF mini library */
+#ifndef __LIBBPF_H
+#define __LIBBPF_H
+
+struct bpf_insn;
+
+int bpf_create_map(enum bpf_map_type map_type, int key_size, int value_size,
+		   int max_entries);
+int bpf_update_elem(int fd, void *key, void *value);
+int bpf_lookup_elem(int fd, void *key, void *value);
+int bpf_delete_elem(int fd, void *key);
+int bpf_get_next_key(int fd, void *key, void *next_key);
+
+int bpf_prog_load(enum bpf_prog_type prog_type,
+		  const struct bpf_insn *insns, int insn_len,
+		  const char *license);
+
+#define LOG_BUF_SIZE 8192
+extern char bpf_log_buf[LOG_BUF_SIZE];
+
+#endif
-- 
1.7.9.5

