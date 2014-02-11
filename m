Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaBKT45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:56:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaBKTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.12 092/107] drm/vmwgfx: Fix regression caused by "drm/ttm: make ttm reservation calls behave like reservation calls"
Date: Tue, 11 Feb 2014 11:05:58 -0800
Message-Id: <20140211184750.821707952@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit cf5e3413337309050c05e13dcebe85b7194a21e5 upstream.

The call to ttm_eu_backoff_reservation() as part of an error path would cause
a lock imbalance if the reservation ticket was not initialized. This error is
easily triggered from user-space by submitting a bogus command stream.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1483,11 +1483,11 @@ int vmw_execbuf_process(struct drm_file
 	ret = vmw_cmd_check_all(dev_priv, sw_context, kernel_commands,
 				command_size);
 	if (unlikely(ret != 0))
-		goto out_err;
+		goto out_err_nores;
 
 	ret = vmw_resources_reserve(sw_context);
 	if (unlikely(ret != 0))
-		goto out_err;
+		goto out_err_nores;
 
 	ret = ttm_eu_reserve_buffers(&ticket, &sw_context->validate_nodes);
 	if (unlikely(ret != 0))
@@ -1569,10 +1569,11 @@ int vmw_execbuf_process(struct drm_file
 	return 0;
 
 out_err:
-	vmw_resource_relocations_free(&sw_context->res_relocations);
-	vmw_free_relocations(sw_context);
 	ttm_eu_backoff_reservation(&ticket, &sw_context->validate_nodes);
+out_err_nores:
 	vmw_resource_list_unreserve(&sw_context->resource_list, true);
+	vmw_resource_relocations_free(&sw_context->res_relocations);
+	vmw_free_relocations(sw_context);
 	vmw_clear_validations(sw_context);
 	if (unlikely(dev_priv->pinned_bo != NULL &&
 		     !dev_priv->query_cid_valid))


