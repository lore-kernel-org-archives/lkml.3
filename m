Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966686AbaCUA33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:29:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965983AbaCUAJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ales Novak <alnovak@suse.cz>, Thomas Abraham <tabraham@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, "K. Y. Srinivasan" <kys@microsoft.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 70/85] SCSI: storvsc: NULL pointer dereference fix
Date: Thu, 20 Mar 2014 17:10:13 -0700
Message-Id: <20140321000608.711367720@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ales Novak <alnovak@suse.cz>

commit b12bb60d6c350b348a4e1460cd68f97ccae9822e upstream.

If the initialization of storvsc fails, the storvsc_device_destroy()
causes NULL pointer dereference.

storvsc_bus_scan()
  scsi_scan_target()
    __scsi_scan_target()
      scsi_probe_and_add_lun(hostdata=NULL)
        scsi_alloc_sdev(hostdata=NULL)

	  sdev->hostdata = hostdata

	  now the host allocation fails

          __scsi_remove_device(sdev)

	  calls sdev->host->hostt->slave_destroy() ==
	  storvsc_device_destroy(sdev)
	    access of sdev->hostdata->request_mempool

Signed-off-by: Ales Novak <alnovak@suse.cz>
Signed-off-by: Thomas Abraham <tabraham@suse.com>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1189,6 +1189,9 @@ static void storvsc_device_destroy(struc
 {
 	struct stor_mem_pools *memp = sdevice->hostdata;
 
+	if (!memp)
+		return;
+
 	mempool_destroy(memp->request_mempool);
 	kmem_cache_destroy(memp->request_pool);
 	kfree(memp);


