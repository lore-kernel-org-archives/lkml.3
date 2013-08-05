Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3HEL2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:28:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:59360 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3HEL2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:28:44 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH v2] staging: ozwpan: Fix farewell report.
Date: Mon, 5 Aug 2013 12:28:33 +0100
Message-ID: <1375702113-6797-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130803031049.GA2999@kroah.com>
References: <20130803031049.GA2999@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix following issues reported by Dan:-

1) There is no check limiting the size to 32 and it could be up to
   253 bytes.
2) Use defines instead of magic numbers.
3) The oz_farewell struct is supposed to be a variable length struct
   but the variable part is put in the middle.  It doesn't make any
   sense to put the length of the variable size array after then end
   of the array because we can never find it again!  Put the
   variable size array at the end.  Make it a zero length array.
   u8 len;
   u8 report[0];
4) In oz_add_farewell() we do this:

	f = kmalloc(sizeof(struct oz_farewell) + len - 1, GFP_ATOMIC);

    The "- 1" refers to sizeof(f->report) but because it was a magic
    number then it was missed when the sizeof(f->report) changed.
5) In [patch 6/6] we set the ->len member.  But because it is at the
   end of a variable length array with no limit check the remote
   attacker can just rewrite it using the memcpy() on the next line.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.h    |    2 +-
 drivers/staging/ozwpan/ozproto.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index 57e98c8..996ef65 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -48,8 +48,8 @@ struct oz_farewell {
 	struct list_head link;
 	u8 ep_num;
 	u8 index;
-	u8 report[32];
 	u8 len;
+	u8 report[0];
 };
 
 /* Data structure that holds information on a specific peripheral device (PD).
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 084307a..3d1a89f 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -291,7 +291,7 @@ static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
 	struct oz_farewell *f;
 	struct oz_farewell *f2;
 	int found = 0;
-	f = kmalloc(sizeof(struct oz_farewell) + len - 1, GFP_ATOMIC);
+	f = kmalloc(sizeof(struct oz_farewell) + len, GFP_ATOMIC);
 	if (!f)
 		return;
 	f->ep_num = ep_num;
-- 
1.7.9.5

