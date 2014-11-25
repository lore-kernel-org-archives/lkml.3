Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaKYKkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaKYKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 041/254] tty/vt: don't set font mappings on vc not supporting this
Date: Tue, 25 Nov 2014 10:36:31 +0000
Message-Id: <1416912004-5928-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 9e326f78713a4421fe11afc2ddeac07698fac131 upstream.

We can call this function for a dummy console that doesn't support
setting the font mapping, which will result in a null ptr BUG. So check
for this case and return error for consoles w/o font mapping support.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=59321
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/vt/consolemap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 610b720d3b91..59b25e039968 100644
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
2.1.0

