Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3KYO3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:29:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58884 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989Ab3KYNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:36 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Fan Du" <fan.du@windriver.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.690243829@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 35/87] include/linux/fs.h: disable preempt when
 acquire i_size_seqcount write lock
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -911,9 +911,11 @@ static inline loff_t i_size_read(const s
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

