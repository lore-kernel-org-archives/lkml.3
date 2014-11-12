Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684AbaKLCzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:55:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422AbaKLBmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:42:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 061/203] dm log userspace: fix memory leak in dm_ulog_tfr_init failure path
Date: Wed, 12 Nov 2014 10:15:31 +0900
Message-Id: <20141112011545.505392175@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 56ec16cb1e1ce46354de8511eef962a417c32c92 upstream.

If cn_add_callback() fails in dm_ulog_tfr_init(), it does not
deallocate prealloced memory but calls cn_del_callback().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -272,7 +272,7 @@ int dm_ulog_tfr_init(void)
 
 	r = cn_add_callback(&ulog_cn_id, "dmlogusr", cn_ulog_callback);
 	if (r) {
-		cn_del_callback(&ulog_cn_id);
+		kfree(prealloced_cn_msg);
 		return r;
 	}
 


