Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaKWSoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:44:32 -0500
Received: from mout.web.de ([212.227.15.3]:56644 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaKWSoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:44:30 -0500
Message-ID: <54722AF8.3000609@users.sourceforge.net>
Date: Sun, 23 Nov 2014 19:44:08 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/2] staging: android: ion: One function call less in ion_buffer_create()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54722893.6020301@users.sourceforge.net>
In-Reply-To: <54722893.6020301@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:bs4RqOxZUkuABk2s+mKl1sWh1BT+ZNuv8qmeUYbsVyHGh4FZ6Hu
 5Kk4uQHamXmXC2uJLTrgswuWAw8kYaMYGfK/6SM6SOZsQucjil+M74NMOpx2n4RvNSyUsPe
 lxCaUZQpaMkkG6ws4kySg90+DXJF5+xjxtk30MsISdZcOzesCX45c6pTQBmCvapSLhu2I8l
 SyPEC7l/awCssS2VFOvEA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 19:12:29 +0100

The jump label "err1" was used by the ion_buffer_create() function in case of
a memory allocation failure just to pass a null pointer to a vfree() function
call by a data structure element.
This implementation detail could be improved by the deletion of this
inappropriate jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/android/ion/ion.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index df12cc3..7a26b85 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -226,7 +226,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		buffer->pages = vmalloc(sizeof(struct page *) * num_pages);
 		if (!buffer->pages) {
 			ret = -ENOMEM;
-			goto err1;
+			goto err2;
 		}
 
 		for_each_sg(table->sgl, sg, table->nents, i) {
@@ -262,7 +262,6 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 err:
 	heap->ops->unmap_dma(heap, buffer);
 	heap->ops->free(buffer);
-err1:
 	vfree(buffer->pages);
 err2:
 	kfree(buffer);
-- 
2.1.3

