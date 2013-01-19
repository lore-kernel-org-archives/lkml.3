Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3ASBh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:37:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:56226 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab3ASBRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Luciano Coelho <coelho@ti.com>, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 03/33] firmware: make sure the fw file size is not 0
Date: Fri, 18 Jan 2013 17:16:28 -0800
Message-Id: <20130119010347.078399362@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <coelho@ti.com>

commit 4adf07fba3bd64472921a01aae0e116f9f948b77 upstream.

If the requested firmware file size is 0 bytes in the filesytem, we
will try to vmalloc(0), which causes a warning:

  vmalloc: allocation failure: 0 bytes
  kworker/1:1: page allocation failure: order:0, mode:0xd2
    __vmalloc_node_range+0x164/0x208
    __vmalloc_node+0x4c/0x58
    vmalloc+0x38/0x44
    _request_firmware_load+0x220/0x6b0
    request_firmware+0x64/0xc8
    wl18xx_setup+0xb4/0x570 [wl18xx]
    wlcore_nvs_cb+0x64/0x9f8 [wlcore]
    request_firmware_work_func+0x94/0x100
    process_one_work+0x1d0/0x750
    worker_thread+0x184/0x4ac
    kthread+0xb4/0xc0

To fix this, check whether the file size is less than or equal to zero
in fw_read_file_contents().

Signed-off-by: Luciano Coelho <coelho@ti.com>
Acked-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -295,7 +295,7 @@ static bool fw_read_file_contents(struct
 	char *buf;
 
 	size = fw_file_size(file);
-	if (size < 0)
+	if (size <= 0)
 		return false;
 	buf = vmalloc(size);
 	if (!buf)


