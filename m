Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaARBWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 20:22:53 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:57861 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaARBWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 20:22:52 -0500
Message-ID: <52D9D6F2.2030003@huawei.com>
Date: Sat, 18 Jan 2014 09:20:50 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <robin.yb@huawei.com>, David Rientjes <rientjes@google.com>,
        <viro@zeniv.linux.org.uk>
CC: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] fs: don't write pages when receiving a pending SIGKILL
 in __get_user_pages()
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the process IO direction, dio_refill_pages will call get_user_pages_fast 
to map the page from user space. If ret is less than 0 and IO is write, the 
function will create a zero page to fill data. This may work for some file 
system, but in some device operate we prefer whole write or fail, not half 
data half zero, e.g. fs metadata, like inode, identy.
This happens often when kill a process which is doing direct IO. Consider 
the following cases, the process A is doing IO process, may enter __get_user_pages 
function, if other processes send process A SIG_KILL, A will enter the 
following branches 
		/*
		 * If we have a pending SIGKILL, don't keep faulting
		 * pages and potentially allocating memory.
		 */
		if (unlikely(fatal_signal_pending(current)))
			return i ? i : -ERESTARTSYS;
Return current pages. direct IO will write the pages, the subsequent pages 
which can’t get will use zero page instead. 

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Bin Yang <robin.yb@huawei.com>
---
 fs/direct-io.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0e04142..b74d565 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -174,6 +174,9 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 		&dio->pages[0]);		/* Put results here */
 
 	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
+		/* If task is killed, do not write anymore */
+		if (ret == -ERESTARTSYS)
+			goto out;
 		struct page *page = ZERO_PAGE(0);
 		/*
 		 * A memory fault, but the filesystem has some outstanding
-- 
1.7.1



