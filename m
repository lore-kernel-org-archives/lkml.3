Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaIXPZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:25:30 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47278 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaIXPZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:25:28 -0400
Date: Wed, 24 Sep 2014 17:25:23 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: fix linkat error for unprivileged AT_EMPTY_PATH
Message-ID: <20140924152523.GC7441@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Return proper error value for linkat(..., AT_EMPTY_PATH) without enough
privileges.

I guess ENOENT was used here, because without AT_EMPTY_PATH that's what
we'd return for an empty path.  But it is wrong for AT_EMPTY_PATH, since we
might not even be passing an empty path, we are simply complaining about
lack of privs for which EPERM is the proper error.

Fixes: 11a7b371b64e ("fs: allow AT_EMPTY_PATH in linkat()...")
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # 2.6.39+
---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3957,7 +3957,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, con
 	 */
 	if (flags & AT_EMPTY_PATH) {
 		if (!capable(CAP_DAC_READ_SEARCH))
-			return -ENOENT;
+			return -EPERM;
 		how = LOOKUP_EMPTY;
 	}
 
