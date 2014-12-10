Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaLJLuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:50:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59011 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbaLJLuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:50:00 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-f1-54883366aec6
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, akpm@linux-foundation.org, kgene.kim@samsung.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        l.czerwinski@samsung.com, s.nawrocki@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 1/6] serial: samsung: add struct s3c24xx_uart_dma
Date: Wed, 10 Dec 2014 12:49:22 +0100
Message-id: <1418212167-28992-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
References: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd10444Qg3unWCzmrF/DZtG8eD2b
	xeffu1gtehdcZbM42/SG3eLXtElsFpd3zWGzOLO4l91i7ZG77BYPDu9ktzj8pp3VgdvjxIzf
	LB77565h9+jbsorR48yCI+wenzfJBbBGcdmkpOZklqUW6dslcGV8vb2RpeA4X8XGbs0GxpPc
	XYycHBICJhL/p5xjhrDFJC7cW8/WxcjFISQwnVHi19OvYAkhgXYmiW9t8SA2m4COxJbvExhB
	bBEBOYknt/8wgzQwC0xlkth0fRJTFyMHh7CAo8TaZ3EgNSwCqhJfpvxhA7F5BVwl1n06xwSx
	TE7i5LHJrCA2p4CbxKpnK1ghdrlKrL09g20CI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGMGh90x6B+OqBotDjAIcjEo8vAGX20OEWBPLiitzDzFKcDArifC+kewIEeJNSaysSi3K
	jy8qzUktPsQozcGiJM6rZN8WIiSQnliSmp2aWpBaBJNl4uCUamA0e9g/K+9f5HGxsjnWVWVh
	n4tmcmVN8Vxy6955mfgSDgnXaTafNq9eF3o2Wi2RJyT7+9Tj/91cfdj21lk477lc/cHcdsLO
	ypLXH2JLciyvBUadZ1rpxLzRa853+02zG3M/hTcpTNHe0v7DPTVs3Yt0/WYlN98z9yK/HQ6f
	6KfbOfNX7cIJi58psRRnJBpqMRcVJwIAfl0EjTkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This struct contains DMA configuration for each serial port.
It will be used in next commits adding DMA support in driver.

Based on previous work of Sylwester Nawrocki and Lukasz Czerwinski.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index eb071dd..8dc250c 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -12,6 +12,8 @@
  * published by the Free Software Foundation.
 */
 
+#include <linux/dmaengine.h>
+
 struct s3c24xx_uart_info {
 	char			*name;
 	unsigned int		type;
@@ -41,6 +43,40 @@ struct s3c24xx_serial_drv_data {
 	unsigned int			fifosize[CONFIG_SERIAL_SAMSUNG_UARTS];
 };
 
+struct s3c24xx_uart_dma {
+	dma_filter_fn			fn;
+	void				*rx_param;
+	void				*tx_param;
+
+	unsigned int			rx_chan_id;
+	unsigned int			tx_chan_id;
+
+	struct dma_slave_config		rx_conf;
+	struct dma_slave_config		tx_conf;
+
+	struct dma_chan			*rx_chan;
+	struct dma_chan			*tx_chan;
+
+	dma_addr_t			rx_addr;
+	dma_addr_t			tx_addr;
+
+	dma_cookie_t			rx_cookie;
+	dma_cookie_t			tx_cookie;
+
+	char				*rx_buf;
+
+	dma_addr_t			tx_transfer_addr;
+
+	size_t				rx_size;
+	size_t				tx_size;
+
+	struct dma_async_tx_descriptor	*tx_desc;
+	struct dma_async_tx_descriptor	*rx_desc;
+
+	int				tx_bytes_requested;
+	int				rx_bytes_requested;
+};
+
 struct s3c24xx_uart_port {
 	unsigned char			rx_claimed;
 	unsigned char			tx_claimed;
@@ -59,6 +95,8 @@ struct s3c24xx_uart_port {
 	/* reference to platform data */
 	struct s3c2410_uartcfg		*cfg;
 
+	struct s3c24xx_uart_dma		*dma;
+
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block		freq_transition;
 #endif
-- 
1.9.1

