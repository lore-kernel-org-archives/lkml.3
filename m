Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831Ab3K0CEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:04:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab3K0A4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fan Du <fan.du@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [PATCH 3.4 18/39] include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock
Date: Tue, 26 Nov 2013 16:56:42 -0800
Message-Id: <20131127005620.303584957@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Du <fan.du@windriver.com>

commit 74e3d1e17b2e11d175970b85acd44f5927000ba2 upstream.

Two rt tasks bind to one CPU core.

The higher priority rt task A preempts a lower priority rt task B which
has already taken the write seq lock, and then the higher priority rt
task A try to acquire read seq lock, it's doomed to lockup.

rt task A with lower priority: call write
i_size_write                                        rt task B with higher priority: call sync, and preempt task A
  write_seqcount_begin(&inode->i_size_seqcount);    i_size_read
  inode->i_size = i_size;                             read_seqcount_begin <-- lockup here...

So disable preempt when acquiring every i_size_seqcount *write* lock will
cure the problem.

Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/fs.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -915,9 +915,11 @@ static inline loff_t i_size_read(const s
 static inline void i_size_write(struct inode *inode, loff_t i_size)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	preempt_disable();
 	write_seqcount_begin(&inode->i_size_seqcount);
 	inode->i_size = i_size;
 	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
 	preempt_disable();
 	inode->i_size = i_size;


