Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaB0HeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 02:34:25 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58461 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaB0HeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 02:34:18 -0500
Subject: [PATCH -tip v7 24/26] kprobes: Enlarge hash table to 4096 entries
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Feb 2014 16:34:14 +0900
Message-ID: <20140227073414.20992.16882.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, since the kprobes expects to be used
with less than 100 probe points, its hash table
just has 64 entries. This is too little to handle
several thousands of probes.
Enlarge this to 4096 entires which just consumes
32KB (on 64bit arch) for better scalability.

Without this patch, enabling 17787 probes takes
more than 2 hours! (9428sec, 1 min intervals for
each 2000 probes enabled)

  Enabling trace events: start at 1392782584
  0 1392782585 a2mp_chan_alloc_skb_cb_38556
  1 1392782585 a2mp_chan_close_cb_38555
  ....
  17785 1392792008 lookup_vport_34987
  17786 1392792010 loop_add_23485
  17787 1392792012 loop_attr_do_show_autoclear_23464

I profiled it and saw that more than 90% of
cycles are consumed on get_kprobe.

  Samples: 18K of event 'cycles', Event count (approx.): 37759714934
  +  95.90%  [k] get_kprobe
  +   0.76%  [k] ftrace_lookup_ip
  +   0.54%  [k] kprobe_trace_func

And also more than 60% of executed instructions
were in get_kprobe too.

  Samples: 17K of event 'instructions', Event count (approx.): 1321391290
  +  65.48%  [k] get_kprobe
  +   4.07%  [k] kprobe_trace_func
  +   2.93%  [k] optimized_callback


And annotating get_kprobe also shows the hlist
is too long and takes a time on tracking it.

       |            struct hlist_head *head;
       |            struct kprobe *p;
       |
       |            head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
       |            hlist_for_each_entry_rcu(p, head, hlist) {
 86.33 |      mov    (%rax),%rax
 11.24 |      test   %rax,%rax
       |      jne    60
       |                    if (p->addr == addr)
       |                            return p;
       |            }

With this fix, enabling 20,000 probes just takes
40 min (2303 sec, 1 min intervals for
each 2000 probes enabled)

  Enabling trace events: start at 1392794306
  0 1392794307 a2mp_chan_alloc_skb_cb_38556
  1 1392794307 a2mp_chan_close_cb_38555
  ....
  19997 1392796603 nfs4_negotiate_security_12119
  19998 1392796603 nfs4_open_confirm_done_11767
  19999 1392796603 nfs4_open_confirm_prepare_11779

And it reduced cycles on get_kprobe (with 20,000 probes).

  Samples: 5K of event 'cycles', Event count (approx.): 4540269674
  +  68.77%  [k] get_kprobe
  +   8.56%  [k] ftrace_lookup_ip
  +   3.04%  [k] kprobe_trace_func

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index abdede5..302ff42 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -54,7 +54,7 @@
 #include <asm/errno.h>
 #include <asm/uaccess.h>
 
-#define KPROBE_HASH_BITS 6
+#define KPROBE_HASH_BITS 12
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
 
 


