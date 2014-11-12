Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaKLD0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:26:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289AbaKLBdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH 3.17 266/319] tty/vt: dont set font mappings on vc not supporting this
Date: Wed, 12 Nov 2014 10:16:44 +0900
Message-Id: <20141112011036.811217548@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 9e326f78713a4421fe11afc2ddeac07698fac131 upstream.

We can call this function for a dummy console that doesn't support
setting the font mapping, which will result in a null ptr BUG. So check
for this case and return error for consoles w/o font mapping support.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=59321
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/consolemap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -539,6 +539,12 @@ int con_set_unimap(struct vc_data *vc, u
 
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
@@ -623,6 +629,7 @@ int con_set_unimap(struct vc_data *vc, u
 		set_inverse_transl(vc, p, i); /* Update inverse translations */
 	set_inverse_trans_unicode(vc, p);
 
+out_unlock:
 	console_unlock();
 	return err;
 }


