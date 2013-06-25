Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3FYSfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:35:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3FYSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Dunlop <chris@onthe.net.au>,
        Josh Durgin <josh.durgin@inktank.com>, Sage Weil <sage@inktank.com>,
        Lingzhu Xiang <lxiang@redhat.com>, Zhouping Liu <zliu@redhat.com>
Subject: [ 90/95] rbd: use the correct length for format 2 object names
Date: Tue, 25 Jun 2013 11:33:17 -0700
Message-Id: <20130625182203.811404199@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit 3a96d5cd7bdce45d5dded75c3a62d4fb98050280 upstream.

[Backported for 3.9-stable.
'kmalloc(MAX_OBJ_NAME_SIZE + 1, GFP_NOIO)' was changed as
'kmem_cache_alloc(rbd_segment_name_cache, GFP_NOIO)' in 78c2a44
since 3.10-rc1, and 78c2a44 is relied on a big patchset, so restore
it as 3.9 did.]

Format 2 objects use 16 characters for the object name suffix to be
able to express the full 64-bit range of object numbers. Format 1
images only use 12 characters for this. Using 12-character names for
format 2 caused userspace and kernel rbd clients to read differently
named objects, which made an image written by one client look empty to
the other client.

Reported-by: Chris Dunlop <chris@onthe.net.au>
Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Reviewed-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -833,12 +833,16 @@ static const char *rbd_segment_name(stru
 	char *name;
 	u64 segment;
 	int ret;
+	char *name_format;
 
 	name = kmalloc(MAX_OBJ_NAME_SIZE + 1, GFP_NOIO);
 	if (!name)
 		return NULL;
 	segment = offset >> rbd_dev->header.obj_order;
-	ret = snprintf(name, MAX_OBJ_NAME_SIZE + 1, "%s.%012llx",
+	name_format = "%s.%012llx";
+	if (rbd_dev->image_format == 2)
+		name_format = "%s.%016llx";
+	ret = snprintf(name, MAX_OBJ_NAME_SIZE + 1, name_format,
 			rbd_dev->header.object_prefix, segment);
 	if (ret < 0 || ret > MAX_OBJ_NAME_SIZE) {
 		pr_err("error formatting segment name for #%llu (%d)\n",


