Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbaGOJUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:20:31 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43128 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894AbaGOJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:20:28 -0400
Date: Tue, 15 Jul 2014 18:19:11 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8 V2] staging: dgap: fix memory leak in dgap_parsefile()
Message-ID: <20140715091911.GA19104@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The p->u.board.status is allocated and set a string as
"No" once within allocating a node of BNODE type.
But it also set again with kstrdup() in case of "STATUS"
or "ID". So just free this buffer and allocate again with
kstrdup().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: just use kfree for buffers which assigned to newly value
    and then allocate again properly.

 drivers/staging/dgap/dgap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index e4ea68b..76503fe 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -6599,6 +6599,8 @@ static int dgap_parsefile(char **in)
 				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
+
+			kfree(p->u.board.status);
 			p->u.board.status = kstrdup(s, GFP_KERNEL);
 			break;
 
@@ -6649,6 +6651,7 @@ static int dgap_parsefile(char **in)
 				return -1;
 			}
 
+			kfree(p->u.board.status);
 			p->u.board.status = kstrdup(s, GFP_KERNEL);
 
 			if (p->type == CNODE) {
-- 
1.7.1

