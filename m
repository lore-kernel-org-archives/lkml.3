Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3CRMsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:48:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52165 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3CRMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:48:52 -0400
Date: Mon, 18 Mar 2013 13:48:47 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com, fweisbec@gmail.com
Subject: [PATCH] perf: fix ring_buffer perf_output_space() boundary
 calculation
Message-ID: <20130318124847.GA2491@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a flaw in perf_output_space(). In case the size
of the space needed is bigger than the actual buffer size, there
may be situations where the function would return true (i.e., there
is space) when it should not. head > offset due to rounding of the
masking logic.

The problem can be tested by activating BTS on Intel processors.
A BTS record can be as big as 16 pages. The following command
fails:

$ perf record -m 4 -c 1 -e branches:u my_test_program

You will get a buffer corruption with this. Perf report won't be
able to parse the perf.data.

The fix is to first check that the requested space is smaller than the
buffer size. If so, then the masking logic will work fine. If not, then
there is no chance the record can be saved and it will be gracefully handled
by upper code layers.

This patch also fixes the writable test. If the buffer is not writable, the
function should return false because obviously nothing can be written in
the buffer.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..73147b9 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -18,12 +18,19 @@
 static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
 			      unsigned long offset, unsigned long head)
 {
-	unsigned long mask;
+	unsigned long sz = perf_data_size(rb);
+	unsigned long mask = sz - 1;
 
 	if (!rb->writable)
-		return true;
+		return false;
 
-	mask = perf_data_size(rb) - 1;
+	/*
+	 * verify that payload is not bigger than buffer
+	 * otherwise masking logic may fail to detect
+	 * the "not enough space" condition
+	 */
+	if ((head - offset) > sz)
+		return false;
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
