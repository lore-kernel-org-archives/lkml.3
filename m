Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3L2CLH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:11:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55441 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844Ab3L2CK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Anton Blanchard" <anton@samba.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.79887554@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 080/185] powerpc/pseries: Duplicate dtl entries
 sometimes sent to userspace
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 84b073868b9d9e754ae48b828337633d1b386482 upstream.

When reading from the dispatch trace log (dtl) userspace interface, I
sometimes see duplicate entries. One example:

# hexdump -C dtl.out

00000000  07 04 00 0c 00 00 48 44  00 00 00 00 00 00 00 00
00000010  00 0c a0 b4 16 83 6d 68  00 00 00 00 00 00 00 00
00000020  00 00 00 00 10 00 13 50  80 00 00 00 00 00 d0 32

00000030  07 04 00 0c 00 00 48 44  00 00 00 00 00 00 00 00
00000040  00 0c a0 b4 16 83 6d 68  00 00 00 00 00 00 00 00
00000050  00 00 00 00 10 00 13 50  80 00 00 00 00 00 d0 32

The problem is in scan_dispatch_log() where we call dtl_consumer()
but bail out before incrementing the index.

To fix this I moved dtl_consumer() after the timebase comparison.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -235,8 +235,6 @@ static u64 scan_dispatch_log(u64 stop_tb
 	if (i == vpa->dtl_idx)
 		return 0;
 	while (i < vpa->dtl_idx) {
-		if (dtl_consumer)
-			dtl_consumer(dtl, i);
 		dtb = dtl->timebase;
 		tb_delta = dtl->enqueue_to_dispatch_time +
 			dtl->ready_to_enqueue_time;
@@ -249,6 +247,8 @@ static u64 scan_dispatch_log(u64 stop_tb
 		}
 		if (dtb > stop_tb)
 			break;
+		if (dtl_consumer)
+			dtl_consumer(dtl, i);
 		stolen += tb_delta;
 		++i;
 		++dtl;

