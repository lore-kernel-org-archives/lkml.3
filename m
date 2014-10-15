Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaJONlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:41:51 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49840 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaJONlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:41:50 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: Patrick Palka <patrick@parcs.ath.cx>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] ring-buffer: use atomic_[set|clear]_mask in place of a cmpxchg loop
Date: Wed, 15 Oct 2014 09:41:40 -0400
Message-Id: <1413380500-3914-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 2.1.2.443.g670a3c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding the equivalent cmpxchg loop we can just use
atomic_set_mask and atomic_clear_mask to atomically OR or AND
the value in &buffer->record_disabled.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---

NB: I have only tested this patch on x86_64 by booting with
CONFIG_RING_BUFFER_STARTUP_TEST=y.

 kernel/trace/ring_buffer.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2d75c94..e15ce2a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3050,13 +3050,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_enable);
  */
 void ring_buffer_record_off(struct ring_buffer *buffer)
 {
-	unsigned int rd;
-	unsigned int new_rd;
-
-	do {
-		rd = atomic_read(&buffer->record_disabled);
-		new_rd = rd | RB_BUFFER_OFF;
-	} while (atomic_cmpxchg(&buffer->record_disabled, rd, new_rd) != rd);
+	atomic_set_mask(RB_BUFFER_OFF, &buffer->record_disabled);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_off);
 
@@ -3073,13 +3067,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_off);
  */
 void ring_buffer_record_on(struct ring_buffer *buffer)
 {
-	unsigned int rd;
-	unsigned int new_rd;
-
-	do {
-		rd = atomic_read(&buffer->record_disabled);
-		new_rd = rd & ~RB_BUFFER_OFF;
-	} while (atomic_cmpxchg(&buffer->record_disabled, rd, new_rd) != rd);
+	atomic_clear_mask(RB_BUFFER_OFF, &buffer->record_disabled);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_on);
 
-- 
2.1.2.443.g670a3c1

