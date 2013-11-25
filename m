Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab3KYO2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:28:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58935 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab3KYNxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:37 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Sandeen" <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, "Dave Jones" <davej@redhat.com>,
        "Dave Jones" <davej@fedoraproject.org>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.431840285@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 63/87] ext4: fix memory leak in xattr
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1269,6 +1269,8 @@ retry:
 				    s_min_extra_isize) {
 					tried_min_extra_isize++;
 					new_extra_isize = s_min_extra_isize;
+					kfree(is); is = NULL;
+					kfree(bs); bs = NULL;
 					goto retry;
 				}
 				error = -1;

