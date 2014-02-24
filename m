Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaBXO4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:56:13 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:34894 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaBXO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:56:12 -0500
Date: Mon, 24 Feb 2014 15:56:05 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 bug fixes for the 3.14-rc5
Message-ID: <20140224155605.48300e29@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022414-2966-0000-0000-00000A6282FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
A couple of s390 bug fixes. The PCI segment boundary issue is a nasty
one as it can lead to data corruption.

Gerald Schaefer (1):
      s390/pci/dma: use correct segment boundary size

Heiko Carstens (1):
      s390/compat: fix sys_sched_getattr compat wrapper

Ingo Tuchscherer (1):
      s390/zcrypt: additional check to avoid overflow in msg-type 6 requests

Peter Oberparleiter (1):
      s390/cio: Fix missing subchannels after CHPID configure on

 arch/s390/kernel/compat_wrapper.S     |    2 +-
 arch/s390/pci/pci_dma.c               |    8 +++++---
 drivers/s390/cio/chsc.c               |    1 +
 drivers/s390/crypto/zcrypt_msgtype6.c |   24 +++++++++++++++++++++++-
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 59c8efc..0248949 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1421,5 +1421,5 @@ ENTRY(sys_sched_setattr_wrapper)
 ENTRY(sys_sched_getattr_wrapper)
 	lgfr	%r2,%r2			# pid_t
 	llgtr	%r3,%r3			# const char __user *
-	llgfr	%r3,%r3			# unsigned int
+	llgfr	%r4,%r4			# unsigned int
 	jg	sys_sched_getattr
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 60c11a6..f91c031 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -206,11 +206,13 @@ static void dma_cleanup_tables(struct zpci_dev *zdev)
 	zdev->dma_table = NULL;
 }
 
-static unsigned long __dma_alloc_iommu(struct zpci_dev *zdev, unsigned long start,
-				   int size)
+static unsigned long __dma_alloc_iommu(struct zpci_dev *zdev,
+				       unsigned long start, int size)
 {
-	unsigned long boundary_size = 0x1000000;
+	unsigned long boundary_size;
 
+	boundary_size = ALIGN(dma_get_seg_boundary(&zdev->pdev->dev) + 1,
+			      PAGE_SIZE) >> PAGE_SHIFT;
 	return iommu_area_alloc(zdev->iommu_bitmap, zdev->iommu_pages,
 				start, size, 0, boundary_size, 0);
 }
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index f6b9188..9f0ea6c 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -610,6 +610,7 @@ void chsc_chp_online(struct chp_id chpid)
 		css_wait_for_slow_path();
 		for_each_subchannel_staged(__s390_process_res_acc, NULL,
 					   &link);
+		css_schedule_reprobe();
 	}
 }
 
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index dc542e0..0bc91e4 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -311,7 +311,7 @@ static int XCRB_msg_to_type6CPRB_msgX(struct zcrypt_device *zdev,
 	} __packed * msg = ap_msg->message;
 
 	int rcblen = CEIL4(xcRB->request_control_blk_length);
-	int replylen;
+	int replylen, req_sumlen, resp_sumlen;
 	char *req_data = ap_msg->message + sizeof(struct type6_hdr) + rcblen;
 	char *function_code;
 
@@ -321,12 +321,34 @@ static int XCRB_msg_to_type6CPRB_msgX(struct zcrypt_device *zdev,
 		xcRB->request_data_length;
 	if (ap_msg->length > MSGTYPE06_MAX_MSG_SIZE)
 		return -EINVAL;
+
+	/* Overflow check
+	   sum must be greater (or equal) than the largest operand */
+	req_sumlen = CEIL4(xcRB->request_control_blk_length) +
+			xcRB->request_data_length;
+	if ((CEIL4(xcRB->request_control_blk_length) <=
+						xcRB->request_data_length) ?
+		(req_sumlen < xcRB->request_data_length) :
+		(req_sumlen < CEIL4(xcRB->request_control_blk_length))) {
+		return -EINVAL;
+	}
+
 	replylen = sizeof(struct type86_fmt2_msg) +
 		CEIL4(xcRB->reply_control_blk_length) +
 		xcRB->reply_data_length;
 	if (replylen > MSGTYPE06_MAX_MSG_SIZE)
 		return -EINVAL;
 
+	/* Overflow check
+	   sum must be greater (or equal) than the largest operand */
+	resp_sumlen = CEIL4(xcRB->reply_control_blk_length) +
+			xcRB->reply_data_length;
+	if ((CEIL4(xcRB->reply_control_blk_length) <= xcRB->reply_data_length) ?
+		(resp_sumlen < xcRB->reply_data_length) :
+		(resp_sumlen < CEIL4(xcRB->reply_control_blk_length))) {
+		return -EINVAL;
+	}
+
 	/* prepare type6 header */
 	msg->hdr = static_type6_hdrX;
 	memcpy(msg->hdr.agent_id , &(xcRB->agent_ID), sizeof(xcRB->agent_ID));

