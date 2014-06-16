Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaFPB3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 21:29:34 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64704 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaFPB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 21:29:30 -0400
Date: Sun, 15 Jun 2014 18:28:00 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Lukas Czerner <lczerner@redhat.com>, Namjae Jeon <namjae.jeon@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently
 supported
Message-ID: <alpine.LSU.2.11.1406151816410.31998@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was well aware of FALLOC_FL_ZERO_RANGE and FALLOC_FL_COLLAPSE_RANGE
support being added to fallocate(); but didn't realize until now that
I had been too stupid to future-proof shmem_fallocate() against new
additions.  -EOPNOTSUPP instead of going on to ordinary fallocation.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # v3.15
---

 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

--- v3.15/mm/shmem.c	2014-06-08 11:19:54.000000000 -0700
+++ linux/mm/shmem.c	2014-06-15 18:01:16.988996166 -0700
@@ -1728,6 +1728,9 @@ static long shmem_fallocate(struct file
 	pgoff_t start, index, end;
 	int error;
 
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
