Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162091Ab3DEQmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:42:52 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:36407 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162001Ab3DEQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:42:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmom7gNBhyuBgg9YkCLRohR6eE-JfBYYtxfFeTkSiGhgHyw@mail.gmail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
	<CAJ-Vmom7gNBhyuBgg9YkCLRohR6eE-JfBYYtxfFeTkSiGhgHyw@mail.gmail.com>
Date: Fri, 5 Apr 2013 18:42:49 +0200
Message-ID: <CAFSJ42Y7-MVAbGx__A52KNfACmZZpXvMzyqiDHOOVziCm49nFg@mail.gmail.com>
Subject: Re: Version number policy!
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

This is the patch with new wmi command to support build number. Please
let me know if it's ok so i can send it as pull request:

>From 2591efa83bd24a807e3d93c4c8e1bf5c570737e1 Mon Sep 17 00:00:00 2001
From: Eugene Krasnikov <k.eugene.e@gmail.com>
Date: Fri, 5 Apr 2013 18:37:26 +0200
Subject: [PATCH] Add WMI_GET_BUILD_NUMBER

New command WMI_GET_BUILD_NUMBER has
following fields:
major
minor
tag

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 target_firmware/wlan/if_ath.c                  |   14 ++++++++++++++
 target_firmware/wlan/include/k2/wlan_cfg.h     |    5 ++++-
 target_firmware/wlan/include/magpie/wlan_cfg.h |    3 +++
 target_firmware/wlan/include/wlan_hdr.h        |    6 ++++++
 target_firmware/wlan/include/wmi.h             |    1 +
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/target_firmware/wlan/if_ath.c b/target_firmware/wlan/if_ath.c
index 409aecf..034b8ea 100755
--- a/target_firmware/wlan/if_ath.c
+++ b/target_firmware/wlan/if_ath.c
@@ -1729,6 +1729,19 @@ static void ath_rc_mask_tgt(void *Context,
A_UINT16 Command,
     wmi_cmd_rsp(sc->tgt_wmi_handle, Command, SeqNo, NULL, 0);
 }

+static void ath_get_build_number_tgt(void *Context,A_UINT16 Command,
A_UINT16 SeqNo,
+                A_UINT8 *data, a_int32_t datalen)
+{
+    struct ath_softc_tgt *sc = (struct ath_softc_tgt *)Context;
+    struct wmi_build_number bld_num;
+
+    bld_num.major = ATH_BUILD_NUMBER_MAJOR;
+    bld_num.minor = ATH_BUILD_NUMBER_MINOR;
+    bld_num.tag = ATH_BUILD_NUMBER_TAG;
+
+    wmi_cmd_rsp(sc->tgt_wmi_handle, Command, SeqNo, &bld_num, sizeof(bld_num));
+}
+
 static WMI_DISPATCH_ENTRY Magpie_Sys_DispatchEntries[] =
 {
     {handle_echo_command,         WMI_ECHO_CMDID,               0},
@@ -1762,6 +1775,7 @@ static WMI_DISPATCH_ENTRY Magpie_Sys_DispatchEntries[] =
     {ath_tx_stats_tgt,            WMI_TX_STATS_CMDID,           0},
     {ath_rx_stats_tgt,            WMI_RX_STATS_CMDID,           0},
     {ath_rc_mask_tgt,             WMI_BITRATE_MASK_CMDID,       0},
+    {ath_get_build_number_tgt,    WMI_GET_BUILD_NUMBER,         0}
 };

 /*****************/
diff --git a/target_firmware/wlan/include/k2/wlan_cfg.h
b/target_firmware/wlan/include/k2/wlan_cfg.h
index ce42d2c..5ad7d0a 100755
--- a/target_firmware/wlan/include/k2/wlan_cfg.h
+++ b/target_firmware/wlan/include/k2/wlan_cfg.h
@@ -82,7 +82,10 @@

 #define ATH_VERSION_MAJOR 1
 #define ATH_VERSION_MINOR 4
-
+
+#define ATH_BUILD_NUMBER_MAJOR 1
+#define ATH_BUILD_NUMBER_MINOR 1
+#define ATH_BUILD_NUMBER_TAG   1
 /************************** HAL configurations **************************/

 #define HAL_DESC_OPTIMIZATION
diff --git a/target_firmware/wlan/include/magpie/wlan_cfg.h
b/target_firmware/wlan/include/magpie/wlan_cfg.h
index 2590e9f..c66bf06 100755
--- a/target_firmware/wlan/include/magpie/wlan_cfg.h
+++ b/target_firmware/wlan/include/magpie/wlan_cfg.h
@@ -68,6 +68,9 @@
 #define ATH_VERSION_MAJOR 1
 #define ATH_VERSION_MINOR 4

+#define ATH_BUILD_NUMBER_MAJOR 1
+#define ATH_BUILD_NUMBER_MINOR 1
+#define ATH_BUILD_NUMBER_TAG   1
 /************************** HAL configurations **************************/

 #define HAL_DESC_OPTIMIZATION
diff --git a/target_firmware/wlan/include/wlan_hdr.h
b/target_firmware/wlan/include/wlan_hdr.h
index cfcfa0a..838f2bf 100755
--- a/target_firmware/wlan/include/wlan_hdr.h
+++ b/target_firmware/wlan/include/wlan_hdr.h
@@ -221,6 +221,12 @@ struct ath_aggr_info {
     a_uint8_t padding;
 };

+struct wmi_build_number {
+    a_uint16_t major;
+    a_uint16_t minor;
+    a_uint16_t tag;
+};
+
 struct wmi_data_delba {
     a_uint8_t  ni_nodeindex;
     a_uint8_t  tidno;
diff --git a/target_firmware/wlan/include/wmi.h
b/target_firmware/wlan/include/wmi.h
index 47bf4a7..9c577a6 100755
--- a/target_firmware/wlan/include/wmi.h
+++ b/target_firmware/wlan/include/wmi.h
@@ -162,6 +162,7 @@ typedef enum {
     WMI_TX_STATS_CMDID,
     WMI_RX_STATS_CMDID,
     WMI_BITRATE_MASK_CMDID,
+    WMI_GET_BUILD_NUMBER
 } WMI_COMMAND_ID;

 /*
--
1.7.9.5

2013/4/5 Adrian Chadd <adrian@freebsd.org>:
> On 5 April 2013 01:19, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
>
>> This is better than anything we had drafted before for 802.11 open
>> firmware design rules. Cc'ing a few lists for wider review given that
>> what we had written before for rules was for 802.11 and Bluetooth [0]
>> and it was very Linux specific. We are striving for open firmware here
>> for the community, for BSD / Linux. Christian would have dealt with
>> more of the support on open firmware design so far due to carl9170.fw
>> [1] so curious if he has any input.
>>
>
> I'm treating it like shared libraries should be treated - minor
> versions shouldn't break existing stuff, just add new calls. Major
> versions are incompatible.
>
> We'll see how well this scales after people hack at it for a while.
>
>
>
> Adrian
>
> _______________________________________________
> Ath9k_htc_fw mailing list
> Ath9k_htc_fw@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath9k_htc_fw



-- 
Best regards,
Eugene
