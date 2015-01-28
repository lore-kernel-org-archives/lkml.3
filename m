Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbbA1EhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:37:20 -0500
Received: from mail.kernel.org ([198.145.29.136]:40918 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934488AbbA1EZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:03 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 142/177] tty/vt: don't set font mappings on vc not supporting this
Date: Wed, 28 Jan 2015 12:10:00 +0800
Message-Id: <1422418236-12852-233-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 9e326f78713a4421fe11afc2ddeac07698fac131 upstream.

We can call this function for a dummy console that doesn't support
setting the font mapping, which will result in a null ptr BUG. So check
for this case and return error for consoles w/o font mapping support.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=59321
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: just return -EINVAL as we don't need to unlock]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/tty/vt/consolemap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 8308fc7..87025d0 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -518,6 +518,10 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 
 	/* Save original vc_unipagdir_loc in case we allocate a new one */
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+
+	if (!p)
+		return -EINVAL;
+
 	if (p->readonly) return -EIO;
 	
 	if (!ct) return 0;
-- 
1.9.1

