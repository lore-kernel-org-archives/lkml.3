Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbaAFWls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968AbaAFWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 105/129] ceph: Add check returned value on func ceph_calc_ceph_pg.
Date: Mon,  6 Jan 2014 14:38:54 -0800
Message-Id: <20140106223902.605024461@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 2fbcbff1d6b9243ef71c64a8ab993bc3c7bb7af1 upstream.

Func ceph_calc_ceph_pg maybe failed.So add check for returned value.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/ioctl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -211,8 +211,12 @@ static long ceph_ioctl_get_dataloc(struc
 	snprintf(dl.object_name, sizeof(dl.object_name), "%llx.%08llx",
 		 ceph_ino(inode), dl.object_no);
 
-	ceph_calc_ceph_pg(&pgid, dl.object_name, osdc->osdmap,
-		ceph_file_layout_pg_pool(ci->i_layout));
+	r = ceph_calc_ceph_pg(&pgid, dl.object_name, osdc->osdmap,
+				ceph_file_layout_pg_pool(ci->i_layout));
+	if (r < 0) {
+		up_read(&osdc->map_sem);
+		return r;
+	}
 
 	dl.osd = ceph_calc_pg_primary(osdc->osdmap, pgid);
 	if (dl.osd >= 0) {


