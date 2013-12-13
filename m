Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3LMWpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:45:52 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48637 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3LMW0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 022/115] gpu: ion: IOCTL return success when error occurs
Date: Fri, 13 Dec 2013 14:23:56 -0800
Message-Id: <1386973529-4884-23-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olav Haugan <ohaugan@codeaurora.org>

ION_IOC_MAP, ION_IOC_SHARE, and ION_IOC_IMPORT may return
success when an error occurs.

Add correct error handling to ION_IOC_MAP, ION_IOC_SHARE, and
ION_IOC_IMPORT.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index f536ce5..a054edd 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1040,20 +1040,27 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		data.fd = ion_share_dma_buf(client, data.handle);
 		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
 			return -EFAULT;
+		if (data.fd < 0)
+			return data.fd;
 		break;
 	}
 	case ION_IOC_IMPORT:
 	{
 		struct ion_fd_data data;
+		int ret = 0;
 		if (copy_from_user(&data, (void __user *)arg,
 				   sizeof(struct ion_fd_data)))
 			return -EFAULT;
 		data.handle = ion_import_dma_buf(client, data.fd);
-		if (IS_ERR(data.handle))
+		if (IS_ERR(data.handle)) {
+			ret = PTR_ERR(data.handle);
 			data.handle = NULL;
+		}
 		if (copy_to_user((void __user *)arg, &data,
 				 sizeof(struct ion_fd_data)))
 			return -EFAULT;
+		if (ret < 0)
+			return ret;
 		break;
 	}
 	case ION_IOC_SYNC:
-- 
1.8.3.2

