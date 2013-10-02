Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3JBQnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:43:45 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:62446 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3JBQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:43:42 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: James Bates <james.h.bates@gmail.com>, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v3] efifb: prevent null-deref when iterating dmi_list
Date: Wed,  2 Oct 2013 18:43:39 +0200
Message-Id: <1380732219-5458-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380732056-5387-1-git-send-email-dh.herrmann@gmail.com>
References: <1380732056-5387-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bates <james.h.bates@gmail.com>

The dmi_list array is initialized using gnu designated initializers, and
therefore may contain fewer explicitly defined entries as there are
elements in it. This is because the enum above with M_xyz constants
contains more items than the designated initializer. Those elements not
explicitly initialized are implicitly set to 0.

Now efifb_setup() loops through all these array elements, and performs
a strcmp on each item. For non explicitly initialized elements this will
be a null pointer:

This patch swaps the check order in the if statement, thus checks first
whether dmi_list[i].base is null.

Signed-off-by: James Bates <james.h.bates@gmail.com>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
v3: fixes the "Author" field and James' email address

 drivers/video/efifb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 7f9ff75..fcb9500 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -108,8 +108,8 @@ static int efifb_setup(char *options)
 			if (!*this_opt) continue;
 
 			for (i = 0; i < M_UNKNOWN; i++) {
-				if (!strcmp(this_opt, efifb_dmi_list[i].optname) &&
-				    efifb_dmi_list[i].base != 0) {
+				if (efifb_dmi_list[i].base != 0 &&
+				    !strcmp(this_opt, efifb_dmi_list[i].optname)) {
 					screen_info.lfb_base = efifb_dmi_list[i].base;
 					screen_info.lfb_linelength = efifb_dmi_list[i].stride;
 					screen_info.lfb_width = efifb_dmi_list[i].width;
-- 
1.8.4

