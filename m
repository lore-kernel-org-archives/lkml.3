Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbaLBT1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:27:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832AbaLBT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:27:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 039/121] tty/vt: don't set font mappings on vc not supporting this
Date: Tue,  2 Dec 2014 11:18:38 -0800
Message-Id: <1417548000-1794-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 9e326f78713a4421fe11afc2ddeac07698fac131 upstream.

We can call this function for a dummy console that doesn't support
setting the font mapping, which will result in a null ptr BUG. So check
for this case and return error for consoles w/o font mapping support.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=59321
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/vt/consolemap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 2978ca5..d0a3e23 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -540,6 +540,13 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 
 	/* Save original vc_unipagdir_loc in case we allocate a new one */
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+
+	if (!p) {
+		err = -EINVAL;
+
+		goto out_unlock;
+	}
+
 	if (p->readonly) {
 		console_unlock();
 		return -EIO;
@@ -633,6 +640,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 		set_inverse_transl(vc, p, i); /* Update inverse translations */
 	set_inverse_trans_unicode(vc, p);
 
+out_unlock:
 	console_unlock();
 	return err;
 }
-- 
1.9.1

