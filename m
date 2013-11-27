Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab3K0BFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:05:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab3K0BAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:00:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.12 093/116] powerpc/pseries: Duplicate dtl entries sometimes sent to userspace
Date: Tue, 26 Nov 2013 16:57:46 -0800
Message-Id: <20131127005743.335159897@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -213,8 +213,6 @@ static u64 scan_dispatch_log(u64 stop_tb
 	if (i == be64_to_cpu(vpa->dtl_idx))
 		return 0;
 	while (i < be64_to_cpu(vpa->dtl_idx)) {
-		if (dtl_consumer)
-			dtl_consumer(dtl, i);
 		dtb = be64_to_cpu(dtl->timebase);
 		tb_delta = be32_to_cpu(dtl->enqueue_to_dispatch_time) +
 			be32_to_cpu(dtl->ready_to_enqueue_time);
@@ -227,6 +225,8 @@ static u64 scan_dispatch_log(u64 stop_tb
 		}
 		if (dtb > stop_tb)
 			break;
+		if (dtl_consumer)
+			dtl_consumer(dtl, i);
 		stolen += tb_delta;
 		++i;
 		++dtl;


