Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3L2DC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:02:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906Ab3L2CJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:51 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Nico Golde" <nico@ngolde.de>,
        "Mahesh Rajashekhara" <Mahesh.Rajashekhara@pmcs.com>,
        "Fabian Yamaguchi" <fabs@goesec.de>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.68024822@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 178/185] aacraid: prevent invalid pointer dereference
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/aacraid/commctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -508,7 +508,8 @@ static int aac_send_raw_srb(struct aac_d
 		goto cleanup;
 	}
 
-	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
+	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
+	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
 		rcode = -EINVAL;
 		goto cleanup;
 	}

