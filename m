Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3KSASr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:18:47 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4509 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3KSASp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:18:45 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>
cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] FS: Fixed buffer overflow issue in seq_read()
Thread-Topic: [PATCH] FS: Fixed buffer overflow issue in seq_read()
Thread-Index: Ac7krU8d+bL/VNzpTjKZYSvDtLeq/Q==
Date: Tue, 19 Nov 2013 00:18:41 +0000
Message-ID: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E9471A71SC9104354-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer count is not initialized when a new buffer is allocated. 

It cause kernel crash with "Unable to handle kernel paging
request..." error in __copy_to_user_std(). It happens when a 
memory allocation failure in the while(1)-loop, which left the 
buffer count (m->count) is larger than buffer size 
(m->size).  

This patch is currently against a linux 3.12 kernel

Signed-off-by: Charley Chu charley.chu@broadcom.com
---
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1cd2388..480a341 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -191,6 +191,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 
        /* grab buffer if we didn't have one */
        if (!m->buf) {
+               m->count = m->from = 0;
                m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
                if (!m->buf)
                        goto Enomem;



