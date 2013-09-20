Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab3ITO3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3ITO33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:29:29 -0400
Date: Fri, 20 Sep 2013 10:29:18 -0400
From: Dave Jones <davej@redhat.com>
To: tytso@mit.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: ext4: fix memory leak in xattr code.
Message-ID: <20130920142918.GA21988@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we take the 2nd retry path in ext4_expand_extra_isize_ea, we potentionally
return from the function without having freed these allocations.
If we don't do the return, we over-write the previous allocation pointers, 
so we leak either way.

Spotted with Coverity.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c081e34..f3a6220 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1350,6 +1350,8 @@ retry:
 				    s_min_extra_isize) {
 					tried_min_extra_isize++;
 					new_extra_isize = s_min_extra_isize;
+					kfree(is);
+					kfree(bs);
 					goto retry;
 				}
 				error = -1;
