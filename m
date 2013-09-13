Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3IMIHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:07:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3IMIH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:07:26 -0400
Date: Fri, 13 Sep 2013 11:07:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] staging: line6: add bounds check in snd_toneport_source_put()
Message-ID: <20130913080713.GI19211@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"source" comes from the user in snd_ctl_elem_write() so it needs to be
checked.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index 2f44d56..776d363 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -244,13 +244,17 @@ static int snd_toneport_source_put(struct snd_kcontrol *kcontrol,
 	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
 	struct usb_line6_toneport *toneport =
 	    (struct usb_line6_toneport *)line6pcm->line6;
+	unsigned int source;
 
-	if (ucontrol->value.enumerated.item[0] == toneport->source)
+	source = ucontrol->value.enumerated.item[0];
+	if (source >= ARRAY_SIZE(toneport_source_info))
+		return -EINVAL;
+	if (source == toneport->source)
 		return 0;
 
-	toneport->source = ucontrol->value.enumerated.item[0];
+	toneport->source = source;
 	toneport_send_cmd(toneport->line6.usbdev,
-			  toneport_source_info[toneport->source].code, 0x0000);
+			  toneport_source_info[source].code, 0x0000);
 	return 1;
 }
 
