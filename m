Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaH0CgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:36:12 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54587 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756AbaH0Cai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:30:38 -0400
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
Subject: [PATCH RFC v7 net-next 15/28] bpf: allow eBPF programs to use maps
Date: Tue, 26 Aug 2014 19:29:29 -0700
Message-Id: <1409106582-10095-16-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

expose bpf_map_lookup_elem(), bpf_map_update_elem(), bpf_map_delete_elem()
map accessors to eBPF programs

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 include/linux/bpf.h      |    5 ++++
 include/uapi/linux/bpf.h |    3 ++
 kernel/bpf/syscall.c     |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ad1bda7ece35..14e23bb10b2d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -131,4 +131,9 @@ struct bpf_prog *bpf_prog_get(u32 ufd);
 /* verify correctness of eBPF program */
 int bpf_check(struct bpf_prog *fp, union bpf_attr *attr);
 
+/* in-kernel helper functions called from eBPF programs */
+u64 bpf_map_lookup_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
+u64 bpf_map_update_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
+u64 bpf_map_delete_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dee7a2469b8d..f87b501b2e1b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -419,6 +419,9 @@ union bpf_attr {
  */
 enum bpf_func_id {
 	BPF_FUNC_unspec,
+	BPF_FUNC_map_lookup_elem, /* void *map_lookup_elem(&map, &key) */
+	BPF_FUNC_map_update_elem, /* int map_update_elem(&map, &key, &value) */
+	BPF_FUNC_map_delete_elem, /* int map_delete_elem(&map, &key) */
 	__BPF_FUNC_MAX_ID,
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8f11d1549cfc..641bb9e6709c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -575,3 +575,71 @@ free_attr:
 	kfree(attr);
 	return err;
 }
+
+/* called from eBPF program under rcu lock
+ *
+ * if kernel subsystem is allowing eBPF programs to call this function,
+ * inside its own verifier_ops->get_func_proto() callback it should return
+ * (struct bpf_func_proto) {
+ *    .ret_type = RET_PTR_TO_MAP_VALUE_OR_NULL,
+ *    .arg1_type = ARG_CONST_MAP_PTR,
+ *    .arg2_type = ARG_PTR_TO_MAP_KEY,
+ * }
+ * so that eBPF verifier properly checks the arguments
+ */
+u64 bpf_map_lookup_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
+{
+	struct bpf_map *map = (struct bpf_map *) (unsigned long) r1;
+	void *key = (void *) (unsigned long) r2;
+	void *value;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	value = map->ops->map_lookup_elem(map, key);
+
+	return (unsigned long) value;
+}
+
+/* called from eBPF program under rcu lock
+ *
+ * if kernel subsystem is allowing eBPF programs to call this function,
+ * inside its own verifier_ops->get_func_proto() callback it should return
+ * (struct bpf_func_proto) {
+ *    .ret_type = RET_INTEGER,
+ *    .arg1_type = ARG_CONST_MAP_PTR,
+ *    .arg2_type = ARG_PTR_TO_MAP_KEY,
+ *    .arg3_type = ARG_PTR_TO_MAP_VALUE,
+ * }
+ * so that eBPF verifier properly checks the arguments
+ */
+u64 bpf_map_update_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
+{
+	struct bpf_map *map = (struct bpf_map *) (unsigned long) r1;
+	void *key = (void *) (unsigned long) r2;
+	void *value = (void *) (unsigned long) r3;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	return map->ops->map_update_elem(map, key, value);
+}
+
+/* called from eBPF program under rcu lock
+ *
+ * if kernel subsystem is allowing eBPF programs to call this function,
+ * inside its own verifier_ops->get_func_proto() callback it should return
+ * (struct bpf_func_proto) {
+ *    .ret_type = RET_INTEGER,
+ *    .arg1_type = ARG_CONST_MAP_PTR,
+ *    .arg2_type = ARG_PTR_TO_MAP_KEY,
+ * }
+ * so that eBPF verifier properly checks the arguments
+ */
+u64 bpf_map_delete_elem(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
+{
+	struct bpf_map *map = (struct bpf_map *) (unsigned long) r1;
+	void *key = (void *) (unsigned long) r2;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	return map->ops->map_delete_elem(map, key);
+}
-- 
1.7.9.5

