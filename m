Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646Ab3GPRIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:08:35 -0400
Received: from mail-bn1lp0156.outbound.protection.outlook.com ([207.46.163.156]:58501
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933296Ab3GPRIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:08:20 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Igor Gnatenko <i.gnatenko.brain@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Update][PATCH] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Topic: [Update][PATCH] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Index: AQHOf2EOf9xYEw7JIEmM0Xd7JOJCBJlnUxkAgAA8Q4A=
Date: Tue, 16 Jul 2013 17:08:16 +0000
Message-ID: <1373994495.9314.1.camel@x230>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <12270512.1rshgKaUug@vostro.rjw.lan> <51DA7190.6080208@gmail.com>
	 <1683364.CdnoW81WLH@vostro.rjw.lan>
	 <1373981554.1956.5.camel@ThinkPad-X230.localdomain>
In-Reply-To: <1373981554.1956.5.camel@ThinkPad-X230.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-prvs: 09090B6B69
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(377424004)(199002)(189002)(76482001)(76786001)(50986001)(56776001)(16406001)(81342001)(69226001)(54356001)(83072001)(31966008)(74876001)(47446002)(33716001)(46102001)(63696002)(80022001)(56816003)(79102001)(47976001)(74366001)(77982001)(74706001)(54316002)(59766001)(49866001)(65816001)(51856001)(81542001)(33646001)(47736001)(77096001)(74502001)(74662001)(53806001)(76796001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:10.255.84.4;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DB627994CA01C41BF352B8A36AB0F73@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6GH8hrc019451

On Tue, 2013-07-16 at 17:32 +0400, Igor Gnatenko wrote:
> Hmm. I found regression in user-space. In GNOME (maybe and other DEs) we no longer see switch status of backlight.

Yeah, I can duplicate that. Rafael, we have to call
acpi_video_init_brightness() even if we're not going to initialise the
backlight - Thinkpads seem to use this as the trigger for enabling ACPI
notifications rather than handling it in firmware. This seems to do the
job:

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 01b1a25..71865f7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -900,6 +900,9 @@ static void acpi_video_device_find_cap(struct
acpi_video_device *device)
 		device->cap._DDC = 1;
 	}
 
+	if (acpi_video_init_brightness(device))
+		return;
+
 	if (acpi_video_verify_backlight_support()) {
 		struct backlight_properties props;
 		struct pci_dev *pdev;
@@ -909,9 +912,6 @@ static void acpi_video_device_find_cap(struct
acpi_video_device *device)
 		static int count = 0;
 		char *name;
 
-		result = acpi_video_init_brightness(device);
-		if (result)
-			return;
 		name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
 		if (!name)
 			return;


-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
