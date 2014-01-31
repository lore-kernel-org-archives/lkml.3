Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaAaC1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:27:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbaAaC1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:27:33 -0500
Date: Thu, 30 Jan 2014 21:27:25 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: thellstrom@vmware.com
Subject: vmwgfx: Fix unitialized stack read in vmw_setup_otable_base
Message-ID: <20140131022725.GB11601@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, thellstrom@vmware.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the error paths in vmw_setup_otable_base causes us to return with
'ret' having never been set to anything causing us to return whatever was
on the stack.

Found with Coverity

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
index 4910e7b81811..d4a5a19cb8c3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -134,6 +134,7 @@ static int vmw_setup_otable_base(struct vmw_private *dev_priv,
 	cmd = vmw_fifo_reserve(dev_priv, sizeof(*cmd));
 	if (unlikely(cmd == NULL)) {
 		DRM_ERROR("Failed reserving FIFO space for OTable setup.\n");
+		ret = -ENOMEM;
 		goto out_no_fifo;
 	}
 
