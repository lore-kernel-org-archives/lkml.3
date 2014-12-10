Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaLJLuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:50:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43629 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbaLJLuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:50:09 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-01-54883370bd71
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, akpm@linux-foundation.org, kgene.kim@samsung.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        l.czerwinski@samsung.com, s.nawrocki@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/6] serial: samsung: alloc dma stucture in ourport
Date: Wed, 10 Dec 2014 12:49:23 +0100
Message-id: <1418212167-28992-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
References: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd0C444Qg8PPOSzmrF/DZtG8eD2b
	xeffu1gtehdcZbM42/SG3eLXtElsFpd3zWGzOLO4l91i7ZG77BYPDu9ktzj8pp3VgdvjxIzf
	LB77565h9+jbsorR48yCI+wenzfJBbBGcdmkpOZklqUW6dslcGWs7V/EVjCVs+Lz2h8sDYxb
	2LsYOTkkBEwk+p7tZYWwxSQu3FvP1sXIxSEkMJ1RYmrrfCYIp51J4tnbjYwgVWwCOhJbvk8A
	s0UE5CSe3P7DDFLELDCVSWLT9UlMIAlhAWeJoxubwGwWAVWJe19mgq3gFXCV+DrhOiPEOjmJ
	k8cmg8U5BdwkVj1bAWYLAdWsvT2DbQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsY
	wQH4THoH46oGi0OMAhyMSjy8AZfbQ4RYE8uKK3MPMUpwMCuJ8L6R7AgR4k1JrKxKLcqPLyrN
	SS0+xCjNwaIkzqtk3xYiJJCeWJKanZpakFoEk2Xi4JRqYFx+hf2KVKJMHMOXcq8NRu3uRgsf
	rz5v7Nh+7cIS7+UJszPPa5ufc9qw2/Zpmbl4U2y92ZP9oqbrXykcWL4hNNRrU0b4ucgFN4Ib
	vbJ01n6tTz/1cL66VriT2eyYvZfEt8Ve2nr++J5Mqwi/xTyb/kUXVN43TXKdsYQ79xv3heK8
	Ii1nl5mrTimxFGckGmoxFxUnAgCUcUOgPAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have "dmas" property in serial node in device-tree, we do
memory alocation for dma structure which will be used in DMA handling
code.

Based on previous work of Sylwester Nawrocki and Lukasz Czerwinski.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 19273e3..7196a3e 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1209,6 +1209,18 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 	ret = platform_get_irq(platdev, 1);
 	if (ret > 0)
 		ourport->tx_irq = ret;
+	/*
+	 * DMA is currently supported only on DT platforms, if DMA properties
+	 * are specified.
+	 */
+	if (platdev->dev.of_node && of_find_property(platdev->dev.of_node,
+						     "dmas", NULL)) {
+		ourport->dma = devm_kzalloc(port->dev,
+					    sizeof(*ourport->dma),
+					    GFP_KERNEL);
+		if (!ourport->dma)
+			return -ENOMEM;
+	}
 
 	ourport->clk	= clk_get(&platdev->dev, "uart");
 	if (IS_ERR(ourport->clk)) {
-- 
1.9.1

