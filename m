Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3LERh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:37:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3LERhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 66/90] powerpc/pseries: Duplicate dtl entries sometimes sent to userspace
Date: Thu,  5 Dec 2013 17:35:48 +0000
Message-Id: <1386264972-5399-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 84b073868b9d9e754ae48b828337633d1b386482 upstream.

When reading from the dispatch trace log (dtl) userspace interface, I
sometimes see duplicate entries. One example:

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3c50ed9..fe33f00 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -213,8 +213,6 @@ static u64 scan_dispatch_log(u64 stop_tb)
 	if (i == vpa->dtl_idx)
 		return 0;
 	while (i < vpa->dtl_idx) {
-		if (dtl_consumer)
-			dtl_consumer(dtl, i);
 		dtb = dtl->timebase;
 		tb_delta = dtl->enqueue_to_dispatch_time +
 			dtl->ready_to_enqueue_time;
@@ -227,6 +225,8 @@ static u64 scan_dispatch_log(u64 stop_tb)
 		}
 		if (dtb > stop_tb)
 			break;
+		if (dtl_consumer)
+			dtl_consumer(dtl, i);
 		stolen += tb_delta;
 		++i;
 		++dtl;
-- 
1.8.3.2

