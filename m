Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaGHADs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:03:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaGHADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 42/44] powerpc/pseries: Duplicate dtl entries sometimes sent to userspace
Date: Mon,  7 Jul 2014 17:07:32 -0700
Message-Id: <20140707235859.892289926@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -212,8 +212,6 @@ static u64 scan_dispatch_log(u64 stop_tb
 	if (i == vpa->dtl_idx)
 		return 0;
 	while (i < vpa->dtl_idx) {
-		if (dtl_consumer)
-			dtl_consumer(dtl, i);
 		dtb = dtl->timebase;
 		tb_delta = dtl->enqueue_to_dispatch_time +
 			dtl->ready_to_enqueue_time;
@@ -226,6 +224,8 @@ static u64 scan_dispatch_log(u64 stop_tb
 		}
 		if (dtb > stop_tb)
 			break;
+		if (dtl_consumer)
+			dtl_consumer(dtl, i);
 		stolen += tb_delta;
 		++i;
 		++dtl;


