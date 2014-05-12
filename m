Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaELBlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:49 -0400
Received: from 1wt.eu ([62.212.114.60]:34403 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaELBlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:46 -0400
Message-Id: <20140512003205.346978002@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 113/143] aacraid: prevent invalid pointer dereference
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

It appears that driver runs into a problem here if fibsize is too small
because we allocate user_srbcmd with fibsize size only but later we
access it until user_srbcmd->sg.count to copy it over to srbcmd.

It is not correct to test (fibsize < sizeof(*user_srbcmd)) because this
structure already includes one sg element and this is not needed for
commands without data.  So, we would recommend to add the following
(instead of test for fibsize == 0).

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit b4789b8e6be3151a955ade74872822f30e8cd914)

CVE-2013-6380
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/aacraid/commctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index a5b8e7b..c895174 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -507,7 +507,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
+	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
+	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
 		rcode = -EINVAL;
 		goto cleanup;
 	}
-- 
1.7.12.2.21.g234cd45.dirty



