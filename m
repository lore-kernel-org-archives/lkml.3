Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab3DBXEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:04:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab3DBWub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 17/56] Btrfs: limit the global reserve to 512mb
Date: Tue,  2 Apr 2013 15:49:44 -0700
Message-Id: <20130402224713.876193901@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit fdf30d1c1b386e1b73116cc7e0fb14e962b763b0 upstream.

A user reported a problem where he was getting early ENOSPC with hundreds of
gigs of free data space and 6 gigs of free metadata space.  This is because the
global block reserve was taking up the entire free metadata space.  This is
ridiculous, we have infrastructure in place to throttle if we start using too
much of the global reserve, so instead of letting it get this huge just limit it
to 512mb so that users can still get work done.  This allowed the user to
complete his rsync without issues.  Thanks

Reported-and-tested-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3786,7 +3786,7 @@ static void update_global_block_rsv(stru
 	spin_lock(&block_rsv->lock);
 	spin_lock(&sinfo->lock);
 
-	block_rsv->size = num_bytes;
+	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
 		    sinfo->bytes_reserved + sinfo->bytes_readonly +


