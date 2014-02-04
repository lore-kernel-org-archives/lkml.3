Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbaBDVjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:39:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbaBDVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@nsn.com>
Subject: [PATCH 3.13 064/140] uio: fix devm_request_irq usage
Date: Tue,  4 Feb 2014 13:10:51 -0800
Message-Id: <20140204211038.787039294@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@nsn.com>

commit 632fefaf1fff7c344191c363e08a43cf006fe60e upstream.

Commit e6789cd3dfb553077606ccafeb05e0043f072481 (uio: Simplify uio error
path by using devres functions) converted uio to use devm_request_irq().
This introduced a change in behaviour since the IRQ is associated with
the parent device instead of the created UIO device. The IRQ will remain
active after uio_unregister_device() is called, and some drivers will
crash because of this. The patch fixes this.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/uio/uio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -847,7 +847,7 @@ int __uio_register_device(struct module
 	info->uio_dev = idev;
 
 	if (info->irq && (info->irq != UIO_IRQ_CUSTOM)) {
-		ret = devm_request_irq(parent, info->irq, uio_interrupt,
+		ret = devm_request_irq(idev->dev, info->irq, uio_interrupt,
 				  info->irq_flags, info->name, idev);
 		if (ret)
 			goto err_request_irq;


