Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab3CSCbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:31:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46260 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3CSCbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:08 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 12/21] vmcore: allocate per-cpu crash_notes objects on
 page-size boundary
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:01:54 +0900
Message-ID: <20130316040154.15064.35482.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To satisfy mmap()'s page-size boundary requirement, allocate per-cpu
crash_notes objects on page-size boundary.

/proc/vmcore on the 2nd kernel checks if each note objects is
allocated on page-size boundary. If there's some object not satisfying
the page-size boundary requirement, /proc/vmcore doesn't provide
mmap() interface.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 kernel/kexec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index bddd3d7..d1f365e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1234,7 +1234,8 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	crash_notes = __alloc_percpu(roundup(sizeof(note_buf_t), PAGE_SIZE),
+				     PAGE_SIZE);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");

