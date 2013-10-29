Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3J2SKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:10:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3J2SKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:10:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@fedoraproject.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 21/81] ext4: fix memory leak in xattr
Date: Tue, 29 Oct 2013 11:03:42 -0700
Message-Id: <1383069882-11437-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit 6e4ea8e33b2057b85d75175dd89b93f5e26de3bc upstream.

If we take the 2nd retry path in ext4_expand_extra_isize_ea, we
potentionally return from the function without having freed these
allocations.  If we don't do the return, we over-write the previous
allocation pointers, so we leak either way.

Spotted with Coverity.

[ Fixed by tytso to set is and bs to NULL after freeing these
  pointers, in case in the retry loop we later end up triggering an
  error causing a jump to cleanup, at which point we could have a double
  free bug. -- Ted ]

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b93846b..f88c442 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1356,6 +1356,8 @@ retry:
 				    s_min_extra_isize) {
 					tried_min_extra_isize++;
 					new_extra_isize = s_min_extra_isize;
+					kfree(is); is = NULL;
+					kfree(bs); bs = NULL;
 					goto retry;
 				}
 				error = -1;
-- 
1.8.1.2

