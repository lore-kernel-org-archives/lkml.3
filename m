Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaFXUQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:16:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59034 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaFXUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:16:19 -0400
Subject: [PATCH 3/3] mm: catch memory commitment underflow
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 00:16:14 +0400
Message-ID: <20140624201614.18273.39034.stgit@zurg>
In-Reply-To: <20140624201606.18273.44270.stgit@zurg>
References: <20140624201606.18273.44270.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prints warning (if CONFIG_DEBUG_VM=y) when
memory commitment becomes too negative.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 mm/mmap.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 129b847..d3decd9 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -134,6 +134,12 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	unsigned long free, allowed, reserve;
 
+#ifdef CONFIG_DEBUG_VM
+	WARN_ONCE(percpu_counter_read(&vm_committed_as) <
+			-(s64)vm_committed_as_batch * num_online_cpus(),
+			"memory commitment underflow");
+#endif
+
 	vm_acct_memory(pages);
 
 	/*

