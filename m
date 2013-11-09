Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab3KIG5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:57:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3KIGw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [PATCH 3.11 91/94] NTB: Add Error Handling in ntb_device_setup
Date: Fri,  8 Nov 2013 22:52:37 -0800
Message-Id: <20131109065210.674026089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit 3b12a0d15bd1559e72ad21d9d807fd2a6706f0ab upstream.

If an error is encountered in ntb_device_setup, it is possible that the
spci_cmd isn't populated.  Writes to the offset can result in a NULL
pointer dereference.  This issue is easily encountered by running in
NTB-RP mode, as it currently is not supported and will generate an
error.  To get around this issue, return if an error is encountered
prior to attempting to write to the spci_cmd offset.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_hw.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -644,10 +644,13 @@ static int ntb_device_setup(struct ntb_d
 		rc = -ENODEV;
 	}
 
+	if (rc)
+		return rc;
+
 	/* Enable Bus Master and Memory Space on the secondary side */
 	writew(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER, ndev->reg_ofs.spci_cmd);
 
-	return rc;
+	return 0;
 }
 
 static void ntb_device_free(struct ntb_device *ndev)


