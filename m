Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041Ab3JPSCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:02:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934307Ab3JPRqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@fedoraproject.org>, "Theodore Tso" <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [ 10/50] ext4: fix memory leak in xattr
Date: Wed, 16 Oct 2013 10:44:56 -0700
Message-Id: <20131016174359.643248978@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1350,6 +1350,8 @@ retry:
 				    s_min_extra_isize) {
 					tried_min_extra_isize++;
 					new_extra_isize = s_min_extra_isize;
+					kfree(is); is = NULL;
+					kfree(bs); bs = NULL;
 					goto retry;
 				}
 				error = -1;


