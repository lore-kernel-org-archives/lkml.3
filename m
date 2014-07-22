Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaGVPvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:51:06 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:59938 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbaGVPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:51:01 -0400
Message-ID: <53CE8862.7020201@adfin.com>
Date: Tue, 22 Jul 2014 11:50:58 -0400
From: Milosz Tanski <milosz@adfin.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-cachefs@redhat.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David Howells" <dhowells@redhat.com>, "NeilBrown" <neilb@suse.de>,
        "Shantanu Goel" <sgoel01@yahoo.com>
Subject: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
References: <cover.1406043029.git.milosz@adfin.com>
In-Reply-To: <cover.1406043029.git.milosz@adfin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/fscache/object.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index d3b4539..186076b 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -925,6 +925,7 @@ static const struct fscache_state *_fscache_invalidate_object(struct fscache_obj
 {
 	struct fscache_operation *op;
 	struct fscache_cookie *cookie = object->cookie;
+	bool wake_cookie = false;
 
 	_enter("{OBJ%x},%d", object->debug_id, event);
 
@@ -981,7 +982,10 @@ nomem:
 
 submit_op_failed:
 	clear_bit(FSCACHE_OBJECT_IS_LIVE, &object->flags);
+	wake_cookie = __fscache_unuse_cookie(cookie);
 	spin_unlock(&cookie->lock);
+	if (wake_cookie)
+		__fscache_wake_unused_cookie(cookie);
 	kfree(op);
 	_leave(" [EIO]");
 	return transit_to(KILL_OBJECT);
-- 
1.7.9.5


