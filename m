Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3CRVyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:54:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3CRVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Novotny <tomas@novotny.cz>, Matt Porter <mporter@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [ 41/75] ARM: davinci: edma: fix dmaengine induced null pointer dereference on da830
Date: Mon, 18 Mar 2013 14:07:04 -0700
Message-Id: <20130318210513.183706082@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Porter <mporter@ti.com>

commit 069552777a121eb39da29de4bc0383483dbe1f7e upstream.

This adds additional error checking to the private edma api implementation
to catch the case where the edma_alloc_slot() has an invalid controller
parameter. The edma dmaengine wrapper driver relies on this condition
being handled in order to avoid setting up a second edma dmaengine
instance on DA830.

Verfied using a DA850 with the second EDMA controller platform instance
removed to simulate a DA830 which only has a single EDMA controller.

Reported-by: Tomas Novotny <tomas@novotny.cz>
Signed-off-by: Matt Porter <mporter@ti.com>
Tested-by: Tomas Novotny <tomas@novotny.cz>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-davinci/dma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/mach-davinci/dma.c
@@ -743,6 +743,9 @@ EXPORT_SYMBOL(edma_free_channel);
  */
 int edma_alloc_slot(unsigned ctlr, int slot)
 {
+	if (!edma_cc[ctlr])
+		return -EINVAL;
+
 	if (slot >= 0)
 		slot = EDMA_CHAN_SLOT(slot);
 


