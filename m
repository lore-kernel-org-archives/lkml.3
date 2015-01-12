Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbbALTNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:13:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57384 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbALSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 021/216] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages
Date: Mon, 12 Jan 2015 18:02:18 +0000
Message-Id: <1421085933-32536-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 31d4ea1a093fcf668d5f95af44b8d41488bdb7ec upstream.

An attempt to fix fcopy on i586 (bc5a5b0 Drivers: hv: util: Properly pack the data
for file copy functionality) led to a regression on x86_64 (and actually didn't fix
i586 breakage). Fcopy messages from Hyper-V host come in the following format:

struct do_fcopy_hdr   |   36 bytes
0000                  |    4 bytes
offset                |    8 bytes
size                  |    4 bytes
data                  | 6144 bytes

On x86_64 struct hv_do_fcopy matched this format without ' __attribute__((packed))'
and on i586 adding ' __attribute__((packed))' to it doesn't change anything. Keep
the structure packed and add padding to match re reality. Tested both i586 and x86_64
on Hyper-V Server 2012 R2.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/uapi/linux/hyperv.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 0a8e6badb29b..bb1cb73c927a 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -134,6 +134,7 @@ struct hv_start_fcopy {
 
 struct hv_do_fcopy {
 	struct hv_fcopy_hdr hdr;
+	__u32   pad;
 	__u64	offset;
 	__u32	size;
 	__u8	data[DATA_FRAGMENT];
-- 
2.1.4

