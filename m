Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935924Ab3DPQ1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:27:54 -0400
Received: from [216.32.180.30] ([216.32.180.30]:54289 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935469Ab3DPQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:27:52 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahz8dhz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kyle Evans <kvans32@gmail.com>
CC: =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after
 fabf85e3ca15d5b94058f391dac8df870cdd427a
Thread-Topic: BUG: Fn keys not working on EliteBook 8460p after
 fabf85e3ca15d5b94058f391dac8df870cdd427a
Thread-Index: AQHON+adNavXer7tn0G8FZnibr/8P5jTXnMAgAC464CAAD66gIAAFbyAgASio4A=
Date: Tue, 16 Apr 2013 16:26:26 +0000
Message-ID: <1366129583.13667.11.camel@x230.lan>
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>
	  <51695169.6090306@gmail.com> <1365870087.13667.7.camel@x230.lan>
	 <51699843.7060905@gmail.com>
In-Reply-To: <51699843.7060905@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D48C6E92C2441246A6B1978FE4EF183A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3GGRvAd003890

Can you try this patch?

diff --git a/drivers/platform/x86/hp-wmi.c
b/drivers/platform/x86/hp-wmi.c
index 45cacf7..91cc5df 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -53,6 +53,7 @@
MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 #define HPWMI_ALS_QUERY 0x3
 #define HPWMI_HARDWARE_QUERY 0x4
 #define HPWMI_WIRELESS_QUERY 0x5
+#define HPWMI_BIOS_QUERY 0x8
 #define HPWMI_HOTKEY_QUERY 0xc
 #define HPWMI_WIRELESS2_QUERY 0x1b
 
@@ -284,6 +285,18 @@ static int hp_wmi_tablet_state(void)
 	return (state & 0x4) ? 1 : 0;
 }
 
+static int hp_wmi_enable_hotkeys()
+{
+	int ret;
+	int query = 1;
+
+	ret = hp_wmi_perform_query(HPWMI_BIOS_QUERY, 1, &query, sizeof(query),
+				   0);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
 static int hp_wmi_set_block(void *data, bool blocked)
 {
 	enum hp_wmi_radio r = (enum hp_wmi_radio) data;
@@ -925,9 +938,7 @@ static int __init hp_wmi_init(void)
 		err = hp_wmi_input_setup();
 		if (err)
 			return err;
-		
-		//Enable magic for hotkeys that run on the SMBus
-		ec_write(0xe6,0x6e);
+		hp_wmi_enable_hotkeys();
 	}
 
 	if (bios_capable) {


-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
