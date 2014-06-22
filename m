Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaFVIxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:53:04 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62023 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaFVIxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:53:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 39/42] staging: rtl8188eu: Use round_up() instead of RND4()
Date: Sun, 22 Jun 2014 14:21:43 +0530
Message-Id: <1403427107-12744-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_security.c     |    6 +++---
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |    4 ++--
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    2 --
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_security.c b/drivers/staging/rtl8188eu/core/rtw_security.c
index 1b64cb6..d78def5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_security.c
+++ b/drivers/staging/rtl8188eu/core/rtw_security.c
@@ -189,7 +189,7 @@ void rtw_wep_encrypt(struct adapter *padapter, u8 *pxmitframe)
 				arcfour_encrypt(&mycontext, payload+length, crc, 4);
 
 				pframe += pxmitpriv->frag_len;
-				pframe = (u8 *)RND4((size_t)(pframe));
+				pframe = (u8 *) round_up((size_t)(pframe), 4);
 			}
 		}
 	}
@@ -628,7 +628,7 @@ u32	rtw_tkip_encrypt(struct adapter *padapter, u8 *pxmitframe)
 					arcfour_encrypt(&mycontext, payload+length, crc, 4);
 
 					pframe += pxmitpriv->frag_len;
-					pframe = (u8 *)RND4((size_t)(pframe));
+					pframe = (u8 *) round_up((size_t)(pframe), 4);
 				}
 			}
 		} else {
@@ -1242,7 +1242,7 @@ u32	rtw_aes_encrypt(struct adapter *padapter, u8 *pxmitframe)
 
 					aes_cipher(prwskey, pattrib->hdrlen, pframe, length);
 					pframe += pxmitpriv->frag_len;
-					pframe = (u8 *)RND4((size_t)(pframe));
+					pframe = (u8 *) round_up((size_t)(pframe), 8);
 				}
 			}
 		} else{
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 3a40b2a..95c508a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -692,7 +692,7 @@ static s32 xmitframe_addmic(struct adapter *padapter, struct xmit_frame *pxmitfr
 			payload = pframe;
 
 			for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
-				payload = (u8 *)RND4((size_t)(payload));
+				payload = (u8 *) round_up((size_t)(payload), 4);
 				RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_,
 					 ("=== curfragnum=%d, pframe = 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x,!!!\n",
 					 curfragnum, *payload, *(payload+1),
@@ -1099,7 +1099,7 @@ s32 rtw_xmitframe_coalesce(struct adapter *padapter, struct sk_buff *pkt, struct
 
 		addr = (size_t)(pframe);
 
-		mem_start = (unsigned char *)RND4(addr) + hw_hdr_offset;
+		mem_start = (unsigned char *) round_up(addr, 4) + hw_hdr_offset;
 		memcpy(mem_start, pbuf_start + hw_hdr_offset, pattrib->hdrlen);
 	}
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 902bbe0..7004e0b 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -401,7 +401,7 @@ static s32 rtw_dump_xframe(struct adapter *adapt, struct xmit_frame *pxmitframe)
 
 		mem_addr += w_sz;
 
-		mem_addr = (u8 *)RND4(((size_t)(mem_addr)));
+		mem_addr = (u8 *) round_up((size_t)mem_addr, 4);
 	}
 
 	rtw_free_xmitframe(pxmitpriv, pxmitframe);
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index e335471..6c3234b 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -175,8 +175,6 @@ static inline void flush_signals_thread(void)
 		flush_signals(current);
 }
 
-#define RND4(x)	(((x >> 2) + (((x & 3) == 0) ?  0 : 1)) << 2)
-
 struct rtw_netdev_priv_indicator {
 	void *priv;
 	u32 sizeof_priv;
-- 
1.7.10.4

