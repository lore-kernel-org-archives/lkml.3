Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3LERge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:36:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab3LERg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 05/90] aacraid: prevent invalid pointer dereference
Date: Thu,  5 Dec 2013 17:34:47 +0000
Message-Id: <1386264972-5399-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

commit b4789b8e6be3151a955ade74872822f30e8cd914 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/aacraid/commctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 0bd38da..05fbc3d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -508,7 +508,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
+	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
+	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
 		rcode = -EINVAL;
 		goto cleanup;
 	}
-- 
1.8.3.2

