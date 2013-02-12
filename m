Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab3BLVJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:09:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3BLUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [ 13/61] media: pwc-if: must check vb2_queue_init() success
Date: Tue, 12 Feb 2013 12:34:33 -0800
Message-Id: <20130212203419.986069261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit eda94710d6502672c5ee7de198fa78a63ddfae3a upstream.

drivers/media/usb/pwc/pwc-if.c: In function 'usb_pwc_probe':
drivers/media/usb/pwc/pwc-if.c:1003:16: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]
In the past, it used to have a logic there at queue init that would
BUG() on errors. This logic got removed. Drivers are now required
to explicitly handle the queue initialization errors, or very bad
things may happen.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

---
 drivers/media/usb/pwc/pwc-if.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1000,7 +1000,11 @@ static int usb_pwc_probe(struct usb_inte
 	pdev->vb_queue.buf_struct_size = sizeof(struct pwc_frame_buf);
 	pdev->vb_queue.ops = &pwc_vb_queue_ops;
 	pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
-	vb2_queue_init(&pdev->vb_queue);
+	rc = vb2_queue_init(&pdev->vb_queue);
+	if (rc < 0) {
+		PWC_ERROR("Oops, could not initialize vb2 queue.\n");
+		goto err_free_mem;
+	}
 
 	/* Init video_device structure */
 	memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));


