Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841Ab3DKXRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:17:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891Ab3DKXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:22 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LWIIR5Ca6dEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Wa4Ca_ta9k0A:10 a=zRKbQ67AAAAA:8 a=fqJWJNsUBNL_Q-EgwOAA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=gifenA44UdVckHGn:21 a=hysIHlfqb8Y6M7Hy:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411231620.618570346@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 19:11:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 5/9 ] sfc: Fix MCDI structure field lookup
References: <20130411231149.302144972@goodmis.org>
Content-Disposition: inline; filename=0005-sfc-Fix-MCDI-structure-field-lookup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 0a6e5008a9df678b48f8d4e57601aa4270df6c14 ]

The least significant bit number (LBN) of a field within an MCDI
structure is counted from the start of the structure, not the
containing dword.  In MCDI_ARRAY_FIELD() we need to mask it rather
than using the usual EFX_DWORD_FIELD() macro.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/mcdi.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 0bdf3e3..96f43d2 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -107,11 +107,13 @@ extern void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
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
-- 
1.7.10.4


