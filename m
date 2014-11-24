Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaKXG5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:57:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28301 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaKXG47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:56:59 -0500
X-AuditID: cbfee61a-f79c06d000004e71-06-5472d6b948d3
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3/4] serial: samsung: prefer to use fifosize from driver data
Date: Mon, 24 Nov 2014 07:56:23 +0100
Message-id: <1416812184-4496-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1416812184-4496-1-git-send-email-r.baldyga@samsung.com>
References: <1416812184-4496-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t9jAd2d14pCDHbfEbGYs34Nm0Xz4vVs
	Fp9/72K1uLxrDpvFmcW97BZrj9xlt3hweCe7A7vHiRm/WTz2z13D7tG3ZRWjx5kFR9g9Pm+S
	C2CN4rJJSc3JLEst0rdL4Mp49/8cc8EKzorpb2exNzB+YO9i5OSQEDCR2DltNROELSZx4d56
	ti5GLg4hgUWMEu9ubmeGcNqZJC4+XMsGUsUmoCOx5fsERhBbREBO4sntP2BFzALrGSVe3F8B
	NlZYwFfiyqzPrCA2i4CqRM+sI2ANvAIuEo//P4JaLSdx8thksBpOAVeJ5zengi0QAqr5tGIC
	+wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggPrmdQOxpUNFocYBTgYlXh4P2ws
	ChFiTSwrrsw9xCjBwawkwnv2X2GIEG9KYmVValF+fFFpTmrxIUZpDhYlcd4bN3NDhATSE0tS
	s1NTC1KLYLJMHJxSDYzprxT2Wors/NIWE7jJ6sJ8K3GWELbn15PMmpKDshp9bQv6d0krxjRt
	slCY33SV9QiDTnq5QbaUmInmgca5UQc25sRl3Jtyd63k6r0fhYpNnfueWTda7XEvYQ4svB12
	cu29KrM7W6M4ZB+3L1keEmUmnct57vde7dxd/9Yf9Ba+zFD21WOLtBJLcUaioRZzUXEiAKD9
	wq4oAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have fifosize set in driver data we prefer to use it instead of default
fifosize value (which is always 16). If there is defined fifosize for particular
serial we prefer to use it, otherwise we use value from info, which is
common for all serials on given platform.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index d05c32c..8808490 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1310,11 +1310,10 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
 		of_property_read_u32(np,
 			"samsung,uart-fifosize", &ourport->port.fifosize);
 
-	if (!ourport->port.fifosize) {
-		ourport->port.fifosize = (ourport->info->fifosize) ?
-			ourport->info->fifosize :
-			ourport->drv_data->fifosize[index];
-	}
+	if (ourport->drv_data->fifosize[index])
+		ourport->port.fifosize = ourport->drv_data->fifosize[index];
+	else if (ourport->info->fifosize)
+		ourport->port.fifosize = ourport->info->fifosize;
 
 	probe_index++;
 
-- 
1.9.1

