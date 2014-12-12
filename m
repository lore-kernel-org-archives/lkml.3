Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbaLLGwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:52:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966003AbaLLGsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:22 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.541260024@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 051/164] fs: make cont_expand_zero interruptible
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c2ca0fcd202863b14bd041a7fece2e789926c225 upstream.

This patch makes it possible to kill a process looping in
cont_expand_zero. A process may spend a lot of time in this function, so
it is desirable to be able to kill it.

It happened to me that I wanted to copy a piece data from the disk to a
file. By mistake, I used the "seek" parameter to dd instead of "skip". Due
to the "seek" parameter, dd attempted to extend the file and became stuck
doing so - the only possibility was to reset the machine or wait many
hours until the filesystem runs out of space and cont_expand_zero fails.
We need this patch to be able to terminate the process.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2261,6 +2261,11 @@ static int cont_expand_zero(struct file
 		err = 0;
 
 		balance_dirty_pages_ratelimited(mapping);
+
+		if (unlikely(fatal_signal_pending(current))) {
+			err = -EINTR;
+			goto out;
+		}
 	}
 
 	/* page covers the boundary, find the boundary offset */

