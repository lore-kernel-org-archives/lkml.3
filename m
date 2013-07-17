Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3GQFDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:03:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48114 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3GQFDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:03:39 -0400
X-AuditID: 9c930179-b7c49ae000000e68-62-51e625a8c08e
From: =?utf-8?B?6rmA6riw7Jik?= <gioh.kim@lge.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Mark Salter'" <msalter@redhat.com>, <namhyung.kim@lge.com>,
        "Minchan Kim" <minchan.kim@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>,
        "'Jong-Sung Kim'" <neidhard.kim@lge.com>
Subject: [PATCH] [RFC] EHCI: add to memory barrier to updating hw_next
Date: Wed, 17 Jul 2013 14:03:36 +0900
Message-ID: <000001ce82aa$feac9ee0$fc05dca0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac6CqU0swtzs9OEuTpufVVo+uw/DMw==
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a missing urb completion problem on ARMv7 based platform.

I thought the above problem was caused by coherent memory between the
EHCI device and CPU so I tryied to allocates device type memory
for EHCI via dma_declare_coherent_memory at machine initialization step
so that EHCI always allocates from those device type memory.
It seems to solve the issue because I didn't see any problem.

But I am not sure it is acceptable solution. So I applied the patch
https://lkml.org/lkml/2011/8/31/344.
But it could not solve the problem so that I added another wmb()
as my patch, and now my platform works fine.

I am not sure what's the exact problem and what wmb I added could solve
but I just think the problem is related to store buffer flush of hw_next.
Anyway, important thing is that it fixed my problem so I expect
you expert guys could find what I am missing and a right solution.
IMHO, the patch might miss updating hw_next pointer.
Am I correct?

I understand the wmb() is just memory barrier, not write-buffer flush.
But it is true that wmb() can flush write buffer in ARM.
Anyhow I think that memory type, "normal memory, non-cacheable", may
have a problem for some devices that needs device type memory.

I cannot get conclusion from the discussion at
https://lkml.org/lkml/2011/8/31/344.
Which can I do for my platform, wmb() or dma_coherent_write_sync()?

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/usb/host/ehci-q.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index d34b399..779d9e8 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -501,6 +501,7 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
                        last = list_entry (qtd->qtd_list.prev,
                                        struct ehci_qtd, qtd_list);
                        last->hw_next = qtd->hw_next;
+                       wmb();
                }

                /* remove qtd; it's recycled after possible urb completion */
--
1.7.9.5

