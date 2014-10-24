Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaJXKUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaJXKUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:20:36 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: linux-api@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages
Date: Fri, 24 Oct 2014 12:20:27 +0200
Message-Id: <1414146027-1915-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 include/uapi/linux/hyperv.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 0a8e6ba..bb1cb73 100644
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
1.9.3

