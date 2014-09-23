Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaIWGEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:04:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:1121 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaIWGEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:04:51 -0400
Message-ID: <54210D7B.8030103@huawei.com>
Date: Tue, 23 Sep 2014 14:04:43 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Miao Xie <miaox@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 2/3] sched: add a macro to define bitops for task atomic
 flags
References: <54210D3F.2090409@huawei.com>
In-Reply-To: <54210D3F.2090409@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.54210D81.000D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d7c0df31139d2b7925d380a3c8036294
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will simplify code when we add new flags.

v2:
- updated scripts/tags.sh, suggested by Peter

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/sched.h | 20 +++++++++++---------
 scripts/tags.sh       |  6 ++++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4557765..04a2ae2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1959,15 +1959,17 @@ static inline void memalloc_noio_restore(unsigned int flags)
 /* Per-process atomic flags. */
 #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
 
-static inline bool task_no_new_privs(struct task_struct *p)
-{
-	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
-
-static inline void task_set_no_new_privs(struct task_struct *p)
-{
-	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
+#define TASK_PFA_BITOPS(name, func)				\
+static inline bool task_##func(struct task_struct *p)		\
+{ return test_bit(PFA_##name, &p->atomic_flags); }		\
+								\
+static inline void task_set_##func(struct task_struct *p)	\
+{ set_bit(PFA_##name, &p->atomic_flags); }			\
+								\
+static inline void task_clear_##func(struct task_struct *p)	\
+{ clear_bit(PFA_##name, &p->atomic_flags); }
+
+TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)
 
 /*
  * task->jobctl flags
diff --git a/scripts/tags.sh b/scripts/tags.sh
index cbfd269..8591b57 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -197,6 +197,9 @@ exuberant()
 	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
 	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+	--regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_\1/'	\
+	--regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_clear_\1/'  \
 	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
 	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
 	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
@@ -260,6 +263,9 @@ emacs()
 	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
 	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+	--regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_\1/'	\
+	--regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_clear_\1/'	\
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
 	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'\
-- 
1.8.0.2

