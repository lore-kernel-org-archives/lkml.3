Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030421Ab3HBKLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030386Ab3HBKLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 64/99] dm ioctl: set noio flag to avoid __vmalloc deadlock
Date: Fri,  2 Aug 2013 18:08:17 +0800
Message-Id: <20130802100234.946549211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1c0e883e86ece31880fac2f84b260545d66a39e0 upstream.

Set noio flag while calling __vmalloc() because it doesn't fully respect
gfp flags to avoid a possible deadlock (see commit
502624bdad3dba45dfaacaf36b7d83e39e74b2d2).

This should be backported to stable kernels 3.8 and newer. The kernel 3.8
doesn't have memalloc_noio_save(), so we should set and restore process
flag PF_MEMALLOC instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1644,7 +1644,10 @@ static int copy_params(struct dm_ioctl _
 	}
 
 	if (!dmi) {
+		unsigned noio_flag;
+		noio_flag = memalloc_noio_save();
 		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
+		memalloc_noio_restore(noio_flag);
 		if (dmi)
 			*param_flags |= DM_PARAMS_VMALLOC;
 	}


