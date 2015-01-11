Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbbAKSVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 13:21:54 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:58351 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbAKSVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 13:21:50 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Trond Myklebust <trond.myklebust@primarydata.com>,
        Weston Andros Adamson <dros@primarydata.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Christoph Hellwig <hch@lst.de>,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        Boaz Harrosh <ooo@electrozaur.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfs: objlayout: objio_osd: Remove unused function
Date: Sun, 11 Jan 2015 19:24:54 +0100
Message-Id: <1421000694-22451-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function objio_alloc_deviceid_node() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/nfs/objlayout/objio_osd.c |   75 ------------------------------------------
 1 file changed, 75 deletions(-)

diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
index 9e5bc42..0c7c94f 100644
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -82,81 +82,6 @@ struct objio_state {
 	struct ore_io_state *ios;
 };
 
-/* Send and wait for a get_device_info of devices in the layout,
-   then look them up with the osd_initiator library */
-struct nfs4_deviceid_node *
-objio_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
-			gfp_t gfp_flags)
-{
-	struct pnfs_osd_deviceaddr *deviceaddr;
-	struct objio_dev_ent *ode = NULL;
-	struct osd_dev *od;
-	struct osd_dev_info odi;
-	bool retry_flag = true;
-	__be32 *p;
-	int err;
-
-	deviceaddr = kzalloc(sizeof(*deviceaddr), gfp_flags);
-	if (!deviceaddr)
-		return NULL;
-
-	p = page_address(pdev->pages[0]);
-	pnfs_osd_xdr_decode_deviceaddr(deviceaddr, p);
-
-	odi.systemid_len = deviceaddr->oda_systemid.len;
-	if (odi.systemid_len > sizeof(odi.systemid)) {
-		dprintk("%s: odi.systemid_len > sizeof(systemid=%zd)\n",
-			__func__, sizeof(odi.systemid));
-		err = -EINVAL;
-		goto out;
-	} else if (odi.systemid_len)
-		memcpy(odi.systemid, deviceaddr->oda_systemid.data,
-		       odi.systemid_len);
-	odi.osdname_len	 = deviceaddr->oda_osdname.len;
-	odi.osdname	 = (u8 *)deviceaddr->oda_osdname.data;
-
-	if (!odi.osdname_len && !odi.systemid_len) {
-		dprintk("%s: !odi.osdname_len && !odi.systemid_len\n",
-			__func__);
-		err = -ENODEV;
-		goto out;
-	}
-
-retry_lookup:
-	od = osduld_info_lookup(&odi);
-	if (unlikely(IS_ERR(od))) {
-		err = PTR_ERR(od);
-		dprintk("%s: osduld_info_lookup => %d\n", __func__, err);
-		if (err == -ENODEV && retry_flag) {
-			err = objlayout_autologin(deviceaddr);
-			if (likely(!err)) {
-				retry_flag = false;
-				goto retry_lookup;
-			}
-		}
-		goto out;
-	}
-
-	dprintk("Adding new dev_id(%llx:%llx)\n",
-		_DEVID_LO(&pdev->dev_id), _DEVID_HI(&pdev->dev_id));
-
-	ode = kzalloc(sizeof(*ode), gfp_flags);
-	if (!ode) {
-		dprintk("%s: -ENOMEM od=%p\n", __func__, od);
-		goto out;
-	}
-
-	nfs4_init_deviceid_node(&ode->id_node, server, &pdev->dev_id);
-	kfree(deviceaddr);
-
-	ode->od.od = od;
-	return &ode->id_node;
-
-out:
-	kfree(deviceaddr);
-	return NULL;
-}
-
 static void copy_single_comp(struct ore_components *oc, unsigned c,
 			     struct pnfs_osd_object_cred *src_comp)
 {
-- 
1.7.10.4

