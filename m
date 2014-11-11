Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaKKREW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:04:22 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:44308 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaKKREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:04:20 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.399
From: Shuah Khan <shuahkh@osg.samsung.com>
To: davem@davemloft.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/net: psock_fanout seg faults in sock_fanout_read_ring()
Date: Tue, 11 Nov 2014 10:04:13 -0700
Message-Id: <1415725453-6549-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The while loop in sock_fanout_read_ring() checks mmap region
bounds after access, causing it to segfault. Fix it to check
count before accessing header->tp_status. This problem can be
reproduced consistently when the test in run as follows:

    make -C tools/testing/selftests TARGETS=net run_tests
    or
    make run_tests from tools/testing/selftests
    or
    make run_test from tools/testing/selftests/net

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/net/psock_fanout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/psock_fanout.c b/tools/testing/selftests/net/psock_fanout.c
index 57b9c2b..6f67333 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -128,7 +128,7 @@ static int sock_fanout_read_ring(int fd, void *ring)
 	struct tpacket2_hdr *header = ring;
 	int count = 0;
 
-	while (header->tp_status & TP_STATUS_USER && count < RING_NUM_FRAMES) {
+	while (count < RING_NUM_FRAMES && header->tp_status & TP_STATUS_USER) {
 		count++;
 		header = ring + (count * getpagesize());
 	}
-- 
1.9.1

