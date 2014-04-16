Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaDPUmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:42:24 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48399 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDPUmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:42:19 -0400
Message-ID: <534EEB29.9020900@gmail.com>
Date: Wed, 16 Apr 2014 22:42:17 +0200
From: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Arve_?= =?ISO-8859-1?Q?Hj=F8nnev=E5g?= 
	<arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Bojan Prtvar <prtvar.b@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: android: binder.c: avoid sparse checker warning:
 cast removes address space of expression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__user should be kept when casting to struct binder_version *


Signed-off-by: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
---
 drivers/staging/android/binder.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..0f74e43 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2683,16 +2683,21 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		binder_free_thread(proc, thread);
 		thread = NULL;
 		break;
-	case BINDER_VERSION:
+	case BINDER_VERSION: {
+		struct binder_version __user *bv =
+			(struct binder_version __user *)ubuf;
+
 		if (size != sizeof(struct binder_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+				&(bv->protocol_version))) {
 			ret = -EINVAL;
 			goto err;
 		}
 		break;
+	}
 	default:
 		ret = -EINVAL;
 		goto err;
-- 
1.8.3.2

