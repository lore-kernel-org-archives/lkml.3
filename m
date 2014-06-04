Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaFDX1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:27:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaFDXYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Leech <cleech@redhat.com>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 088/103] target: Dont allow setting WC emulation if device doesnt support
Date: Wed,  4 Jun 2014 16:25:51 -0700
Message-Id: <20140604232549.686493808@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

commit 07b8dae38b09bcfede7e726f172e39b5ce8390d9 upstream.

Just like for pSCSI, if the transport sets get_write_cache, then it is
not valid to enable write cache emulation for it. Return an error.

see https://bugzilla.redhat.com/show_bug.cgi?id=1082675

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -796,10 +796,10 @@ int se_dev_set_emulate_write_cache(struc
 		pr_err("emulate_write_cache not supported for pSCSI\n");
 		return -EINVAL;
 	}
-	if (dev->transport->get_write_cache) {
-		pr_warn("emulate_write_cache cannot be changed when underlying"
-			" HW reports WriteCacheEnabled, ignoring request\n");
-		return 0;
+	if (flag &&
+	    dev->transport->get_write_cache) {
+		pr_err("emulate_write_cache not supported for this device\n");
+		return -EINVAL;
 	}
 
 	dev->dev_attrib.emulate_write_cache = flag;


