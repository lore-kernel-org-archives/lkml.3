Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaHVQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:56:24 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:63335 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbaHVQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:39 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/15] percpu: make percpu-km set chunk->populated bitmap properly
Date: Fri, 22 Aug 2014 12:53:11 -0400
Message-Id: <1408726399-4436-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu-km instantiates the whole chunk on creation and doesn't make
use of chunk->populated bitmap and leaves it as zero.  While this
currently doesn't cause any problem, the inconsistency makes it
difficult to build further logic on top of chunk->populated.  This
patch makes percpu-km fill chunk->populated on creation so that the
bitmap is always consistent.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu-km.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index a6e34bc..67a971b 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -67,6 +67,9 @@ static struct pcpu_chunk *pcpu_create_chunk(void)
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages) - pcpu_group_offsets[0];
+
+	bitmap_fill(chunk->populated, nr_pages);
+
 	return chunk;
 }
 
-- 
1.9.3

