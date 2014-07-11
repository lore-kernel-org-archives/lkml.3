Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaGKOF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:05:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26531 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGKOFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:25 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a6-53bfef234ea7
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v4 14/21] v4l2-ctrls: add control for flash strobe signal
 providers
Date: Fri, 11 Jul 2014 16:04:17 +0200
Message-id: <1405087464-13762-15-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV3l9/uDDe69FrXYOGM9q8X8I+dY
	LZb83MVk0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWZ/avZHPg9JjyeyOrx+GvC1k8+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK2PGccuCLRIVC9Y/Z2xgvCvcxcjJISFgInFy0mpmCFtM
	4sK99WxdjFwcQgLTGSW2Np+HctqZJM7dOwVWxSZgKPHzxWsmEFtEoFyi5/0zsCJmgc2MEnfn
	trGAJIQFIiX6ns8HK2IRUJXoft0D1swr4Clx9PlW9i5GDqB1ChJzJtmAhDmBwgf7b7KB2EIC
	HhIP155gn8DIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcHg9k9rBuLLB4hCjAAej
	Eg+vwvp9wUKsiWXFlbmHGCU4mJVEeK++2R8sxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3Wg
	kEB6YklqdmpqQWoRTJaJg1OqgdF1Ucaz98d+t16J2y/2WXmd77yPDTtvWS09OFV7WnEJj7iU
	q0LIUstfFaEtkixL3zCtXlj/wkcnOGLO21sK5528/j1zPL+FI3bbu90pn+0qzOW2Coo3n//j
	EX1wSrH35w07HQ7Mj16+8tFnV4MdO+0t1D8l765uubuT6/w6VzU5waYG07OLvtxRYinOSDTU
	Yi4qTgQAQAkL+SsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add V4L2_CID_STROBE_PROVIDER of type menu, which allows
for enumerating of available external flash strobe signal
providers and setting the active one.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   11 +++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
 include/uapi/linux/v4l2-controls.h           |    2 ++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 47198ee..d9f6c3f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4300,6 +4300,17 @@ interface and may change in the future.</para>
     	    is strobing at the moment or not. This is a read-only
     	    control.</entry>
     	  </row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_PROVIDER</constant></entry>
+            <entry>menu</entry>
+          </row>
+          <row>
+            <entry spanname="descr">Provider of the external strobe signal. If a flash
+            device declares more than one available external strobe signal provider then
+            this control allows to select the active one. &VIDIOC-QUERYCTRL; has to be
+            used to get the list of available strobe providers.
+            </entry>
+          </row>
     	  <row>
     	    <entry spanname="id"><constant>V4L2_CID_FLASH_TIMEOUT</constant></entry>
     	    <entry>integer</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 55c6832..f298f7e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -825,6 +825,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_FAULT:		return "Faults";
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
+	case V4L2_CID_FLASH_STROBE_PROVIDER:	return "Strobe Provider";
 
 	/* JPEG encoder controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -988,6 +989,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
+	case V4L2_CID_FLASH_STROBE_PROVIDER:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2ac5597..1f05c7c 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -822,6 +822,8 @@ enum v4l2_flash_strobe_source {
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
 
+#define V4L2_CID_FLASH_STROBE_PROVIDER		(V4L2_CID_FLASH_CLASS_BASE + 13)
+
 
 /* JPEG-class control IDs */
 
-- 
1.7.9.5

