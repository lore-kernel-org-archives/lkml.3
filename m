Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaFLXWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:22:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaFLXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Boot <crb@tiger-computing.co.uk>,
        Philip Gaw <pgaw@darktech.org.uk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 10/18] target: Fix alua_access_state attribute OOPs for un-configured devices
Date: Thu, 12 Jun 2014 16:22:14 -0700
Message-Id: <20140612232213.407360253@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232212.960235342@linuxfoundation.org>
References: <20140612232212.960235342@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit f1453773514bb8b0bba0716301e8c8f17f8d39c7 upstream.

This patch fixes a OOPs where an attempt to write to the per-device
alua_access_state configfs attribute at:

  /sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP/alua_access_state

results in an NULL pointer dereference when the backend device has not
yet been configured.

This patch adds an explicit check for DF_CONFIGURED, and fails with
-ENODEV to avoid this case.

Reported-by: Chris Boot <crb@tiger-computing.co.uk>
Reported-by: Philip Gaw <pgaw@darktech.org.uk>
Cc: Chris Boot <crb@tiger-computing.co.uk>
Cc: Philip Gaw <pgaw@darktech.org.uk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_configfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2034,6 +2034,11 @@ static ssize_t target_core_alua_tg_pt_gp
 			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
+	if (!(dev->dev_flags & DF_CONFIGURED)) {
+		pr_err("Unable to set alua_access_state while device is"
+		       " not configured\n");
+		return -ENODEV;
+	}
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {


