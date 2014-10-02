Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaJBNfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:35:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:50870 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbaJBNfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="582465630"
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty/vt: don't set font mappings on vc not supporting this
Date: Thu,  2 Oct 2014 16:34:31 +0300
Message-Id: <1412256871-29148-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can call this function for a dummy console that doesn't support
setting the font mapping, which will result in a null ptr BUG. So check
for this case and return error for consoles w/o font mapping support.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=59321
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/tty/vt/consolemap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 610b720..59b25e0 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -539,6 +539,12 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 
 	/* Save original vc_unipagdir_loc in case we allocate a new one */
 	p = *vc->vc_uni_pagedir_loc;
+
+	if (!p) {
+		err = -EINVAL;
+
+		goto out_unlock;
+	}
 	
 	if (p->refcount > 1) {
 		int j, k;
@@ -623,6 +629,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 		set_inverse_transl(vc, p, i); /* Update inverse translations */
 	set_inverse_trans_unicode(vc, p);
 
+out_unlock:
 	console_unlock();
 	return err;
 }
-- 
1.8.4

