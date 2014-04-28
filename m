Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaD1K7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:59:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45206 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaD1K72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:59:28 -0400
Date: Mon, 28 Apr 2014 13:58:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peng Tao <bergwolf@gmail.com>, Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, walter harms <wharms@bfs.de>
Subject: [patch 2/2 v2] staging: lustre: integer overflow in
 obd_ioctl_is_invalid()
Message-ID: <20140428105858.GA31925@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425072317.GD4963@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The obd_ioctl_getdata() function caps "data->ioc_len" at
OBD_MAX_IOCTL_BUFFER and then calls this obd_ioctl_is_invalid() to check
that the other values inside data are valid.

There are several lengths inside data but when they are added together
they must not be larger than "data->ioc_len".  The checks against
"(data->ioc_inllen1 > (1<<30))" are supposed to ensure that the addition
does not have an integer overflow.  But "(1<<30) * 4" actually can
overflow 32 bits, so the checks are insufficient.

I have changed it to "> OBD_MAX_IOCTL_BUFFER" instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Updated the error messages as Walter Harms pointed out.

diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index bdc9812..3c26bbd 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -179,24 +179,25 @@ static inline int obd_ioctl_packlen(struct obd_ioctl_data *data)
 
 static inline int obd_ioctl_is_invalid(struct obd_ioctl_data *data)
 {
-	if (data->ioc_len > (1<<30)) {
-		CERROR("OBD ioctl: ioc_len larger than 1<<30\n");
+	if (data->ioc_len > OBD_MAX_IOCTL_BUFFER) {
+		CERROR("OBD ioctl: ioc_len larger than %d\n",
+		       OBD_MAX_IOCTL_BUFFER);
 		return 1;
 	}
-	if (data->ioc_inllen1 > (1<<30)) {
-		CERROR("OBD ioctl: ioc_inllen1 larger than 1<<30\n");
+	if (data->ioc_inllen1 > OBD_MAX_IOCTL_BUFFER) {
+		CERROR("OBD ioctl: ioc_inllen1 larger than ioc_len\n");
 		return 1;
 	}
-	if (data->ioc_inllen2 > (1<<30)) {
-		CERROR("OBD ioctl: ioc_inllen2 larger than 1<<30\n");
+	if (data->ioc_inllen2 > OBD_MAX_IOCTL_BUFFER) {
+		CERROR("OBD ioctl: ioc_inllen2 larger than ioc_len\n");
 		return 1;
 	}
-	if (data->ioc_inllen3 > (1<<30)) {
-		CERROR("OBD ioctl: ioc_inllen3 larger than 1<<30\n");
+	if (data->ioc_inllen3 > OBD_MAX_IOCTL_BUFFER) {
+		CERROR("OBD ioctl: ioc_inllen3 larger than ioc_len\n");
 		return 1;
 	}
-	if (data->ioc_inllen4 > (1<<30)) {
-		CERROR("OBD ioctl: ioc_inllen4 larger than 1<<30\n");
+	if (data->ioc_inllen4 > OBD_MAX_IOCTL_BUFFER) {
+		CERROR("OBD ioctl: ioc_inllen4 larger than ioc_len\n");
 		return 1;
 	}
 	if (data->ioc_inlbuf1 && !data->ioc_inllen1) {
