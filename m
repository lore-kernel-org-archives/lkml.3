Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaCDVeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:34:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbaCDUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.13 026/172] jbd2: fix use after free in jbd2_journal_start_reserved()
Date: Tue,  4 Mar 2014 12:01:50 -0800
Message-Id: <20140304200300.565875701@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 92e3b40537707001d17bbad800d150ab04e53bf4 upstream.

If start_this_handle() fails then it leads to a use after free of
"handle".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/transaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -514,11 +514,13 @@ int jbd2_journal_start_reserved(handle_t
 	 * similarly constrained call sites
 	 */
 	ret = start_this_handle(journal, handle, GFP_NOFS);
-	if (ret < 0)
+	if (ret < 0) {
 		jbd2_journal_free_reserved(handle);
+		return ret;
+	}
 	handle->h_type = type;
 	handle->h_line_no = line_no;
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(jbd2_journal_start_reserved);
 


