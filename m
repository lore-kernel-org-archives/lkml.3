Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3EPSFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:05:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60626
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab3EPSE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:04:59 -0400
Date: Thu, 16 May 2013 20:03:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: majianpeng <majianpeng@gmail.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, mingo@redhat.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [RFC][PATCH] f2fs: Avoid print false deadlock messages.
Message-ID: <20130516180312.GN19669@dyad.programming.kicks-ass.net>
References: <5193322D.1080009@gmail.com>
 <20130515082834.GB10510@laptop.programming.kicks-ass.net>
 <5194337D.1080503@gmail.com>
 <20130516084143.GE19669@dyad.programming.kicks-ass.net>
 <5194C437.4070801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5194C437.4070801@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 07:34:15PM +0800, majianpeng wrote:

> Thanks very much! I'll take times to understand.
> Can you send a patch about this?

You mean the below or something else?

---
Subject: f2fs, lockdep: Annotate mutex_lock_all()

Majianpeng reported a lockdep splat for f2fs. It turns out mutex_lock_all()
acquires an array of locks (in global/local lock style).

Any such operation is always serialized using cp_mutex, therefore there is no
fs_lock[] lock-order issue; tell lockdep about this using the
mutex_lock_nest_lock() primitive.

Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/f2fs/f2fs.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 20aab02..8454277 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -495,9 +495,17 @@ static inline void clear_ckpt_flags(struct f2fs_checkpoint *cp, unsigned int f)
 
 static inline void mutex_lock_all(struct f2fs_sb_info *sbi)
 {
-	int i = 0;
-	for (; i < NR_GLOBAL_LOCKS; i++)
-		mutex_lock(&sbi->fs_lock[i]);
+	int i;
+
+	for (i = 0; i < NR_GLOBAL_LOCKS; i++) {
+		/*
+		 * This is the only time we take multiple fs_lock[]
+		 * instances; the order is immaterial since we
+		 * always hold cp_mutex, which serializes multiple
+		 * such operations.
+		 */
+		mutex_lock_nest_lock(&sbi->fs_lock[i], &sbi->cp_mutex);
+	}
 }
 
 static inline void mutex_unlock_all(struct f2fs_sb_info *sbi)

