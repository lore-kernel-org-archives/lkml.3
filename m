Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaHMQ60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:58:26 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64657 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaHMQ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:58:22 -0400
Message-ID: <53EB992D.6040608@adfin.com>
Date: Wed, 13 Aug 2014 12:58:21 -0400
From: Milosz Tanski <milosz@adfin.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-cachefs@redhat.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
References: <cover.1407948737.git.milosz@adfin.com>
In-Reply-To: <cover.1407948737.git.milosz@adfin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing issues with disposing cookies under vma pressure. The symptom
is that the refcount gets out of sync. In this case we fail to decrement the
refcount if submit fails. I found this while auditing the error in and around
cookie operations.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/fscache/object.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index d3b4539..e1eb1f5 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -982,6 +982,8 @@ nomem:
 submit_op_failed:
 	clear_bit(FSCACHE_OBJECT_IS_LIVE, &object->flags);
 	spin_unlock(&cookie->lock);
+	if (__fscache_unuse_cookie(cookie))
+		__fscache_wake_unused_cookie(cookie);
 	kfree(op);
 	_leave(" [EIO]");
 	return transit_to(KILL_OBJECT);
-- 
1.7.9.5


