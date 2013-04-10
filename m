Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212Ab3DJXKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937246Ab3DJWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 38/64] remoteproc/ste: fix memory leak on shutdown
Date: Wed, 10 Apr 2013 15:46:35 -0700
Message-Id: <20130410224342.073305659@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>

commit 1cd425b660bd5b4f41b9175b0b7bf3828ce88144 upstream.

Fixes coherent memory leakage, caused by non-deallocated
firmware image chunk.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Acked-by: Ido Yariv <ido@wizery.com>
[slightly edit subject and commit log]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/ste_modem_rproc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/ste_modem_rproc.c
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -240,6 +240,8 @@ static int sproc_drv_remove(struct platf
 
 	/* Unregister as remoteproc device */
 	rproc_del(sproc->rproc);
+	dma_free_coherent(sproc->rproc->dev.parent, SPROC_FW_SIZE,
+			  sproc->fw_addr, sproc->fw_dma_addr);
 	rproc_put(sproc->rproc);
 
 	mdev->drv_data = NULL;
@@ -297,10 +299,13 @@ static int sproc_probe(struct platform_d
 	/* Register as a remoteproc device */
 	err = rproc_add(rproc);
 	if (err)
-		goto free_rproc;
+		goto free_mem;
 
 	return 0;
 
+free_mem:
+	dma_free_coherent(rproc->dev.parent, SPROC_FW_SIZE,
+			  sproc->fw_addr, sproc->fw_dma_addr);
 free_rproc:
 	/* Reset device data upon error */
 	mdev->drv_data = NULL;


