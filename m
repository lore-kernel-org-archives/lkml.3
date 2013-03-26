Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3CZXWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:22:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3CZWwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 18/72] sfc: Fix MCDI structure field lookup
Date: Tue, 26 Mar 2013 15:51:01 -0700
Message-Id: <20130326224921.604959825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 0a6e5008a9df678b48f8d4e57601aa4270df6c14 ]

The least significant bit number (LBN) of a field within an MCDI
structure is counted from the start of the structure, not the
containing dword.  In MCDI_ARRAY_FIELD() we need to mask it rather
than using the usual EFX_DWORD_FIELD() macro.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/mcdi.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -107,11 +107,13 @@ extern void efx_mcdi_sensor_event(struct
 #define MCDI_EVENT_FIELD(_ev, _field)			\
 	EFX_QWORD_FIELD(_ev, MCDI_EVENT_ ## _field)
 #define MCDI_ARRAY_FIELD(_buf, _field1, _type, _index, _field2)		\
-	EFX_DWORD_FIELD(						\
+	EFX_EXTRACT_DWORD(						\
 		*((efx_dword_t *)					\
 		  (MCDI_ARRAY_PTR(_buf, _field1, _type, _index) +	\
 		   (MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _OFST & ~3))), \
-		MC_CMD_ ## _type ## _TYPEDEF_ ## _field2)
+		MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _LBN & 0x1f, \
+		(MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _LBN & 0x1f) + \
+		MC_CMD_ ## _type ## _TYPEDEF_ ## _field2 ## _WIDTH - 1)
 
 extern void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len);
 extern int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,


