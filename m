Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaKLBVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:21:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaKLBVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:21:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        hujianyang <hujianyang@huawei.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 3.17 049/319] UBIFS: fix free log space calculation
Date: Wed, 12 Nov 2014 10:13:07 +0900
Message-Id: <20141112011000.684239839@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit ba29e721eb2df6df8f33c1f248388bb037a47914 upstream.

Hu (hujianyang <hujianyang@huawei.com>) discovered an issue in the
'empty_log_bytes()' function, which calculates how many bytes are left in the
log:

"
If 'c->lhead_lnum + 1 == c->ltail_lnum' and 'c->lhead_offs == c->leb_size', 'h'
would equalent to 't' and 'empty_log_bytes()' would return 'c->log_bytes'
instead of 0.
"

At this point it is not clear what would be the consequences of this, and
whether this may lead to any problems, but this patch addresses the issue just
in case.

Tested-by: hujianyang <hujianyang@huawei.com>
Reported-by: hujianyang <hujianyang@huawei.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/log.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -106,10 +106,14 @@ static inline long long empty_log_bytes(
 	h = (long long)c->lhead_lnum * c->leb_size + c->lhead_offs;
 	t = (long long)c->ltail_lnum * c->leb_size;
 
-	if (h >= t)
+	if (h > t)
 		return c->log_bytes - h + t;
-	else
+	else if (h != t)
 		return t - h;
+	else if (c->lhead_lnum != c->ltail_lnum)
+		return 0;
+	else
+		return c->log_bytes;
 }
 
 /**


