Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaA2QoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:44:23 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:36412
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbaA2QoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:44:21 -0500
X-Forefront-Antispam-Report: CIP:107.0.224.235;KIP:(null);UIP:(null);IPV:NLI;H:hq-edge-01.wardrobe.irobot.com;RD:107-0-224-235-ip-static.hfc.comcastbusiness.net;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zzc85dhde40hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de097hz2dh2a8h839hd25he5bhf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1b0ah1bceh2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1f5fh1fe8h1ff5h209eh20f0h22d0h2336h2438h2461h2487h24d7h2516h250di34h1155h)
Message-ID: <52E93009.1090609@irobot.com>
Date: Wed, 29 Jan 2014 08:44:57 -0800
From: Adam Wozniak <awozniak@irobot.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-arm@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, "Agius, Frank" <fagius@irobot.com>
Subject: high cpu load on omap3 using musb
Content-Type: multipart/mixed;
	boundary="------------060906000108060200050904"
X-OriginalArrivalTime: 29 Jan 2014 16:45:04.0659 (UTC) FILETIME=[75E47630:01CF1D11]
X-OriginatorOrg: irobot.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060906000108060200050904
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

With a USB 2.0 webcam attached to the OTG port on an OMAP3 (applies to 
overo gumstix, beagleboard, probably others) we see a high CPU load in a 
kworker thread.

Between 2.6.33 and 2.6.34 musb_core.c changed.

IRQ handlers changed with the result that a worker in musb_core.c got 
scheduled far more frequently than needed.

I've included a patch below against 3.7, but i think it'll apply against 
mainline.
[I apologize for any whitespace mangling.  I've also attached the patch.]

I'd like more eyeballs to tell me if this is right.  I'd also like to 
know who I need to talk to to get this pushed into mainline.

--Adam

# The MUSB IRQ schedules work on every interrupt.
# This is unnecessary, and causes excessive CPU load.
#
# Here we only schedule work if there is something for
# the worker to do.

Index: git/drivers/usb/musb/musb_core.c
===================================================================
--- git.orig/drivers/usb/musb/musb_core.c
+++ git/drivers/usb/musb/musb_core.c
@@ -925,7 +925,9 @@ b_host:
         }
  #endif

-       schedule_work(&musb->irq_work);
+       if (musb->xceiv->state != musb->xceiv_old_state) {
+               schedule_work(&musb->irq_work);
+       }

         return handled;
  }


--------------060906000108060200050904
Content-Type: text/x-patch; name="musb_smartwork.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="musb_smartwork.patch"
Content-Description: musb_smartwork.patch

# The MUSB IRQ schedules work on every interrupt.
# This is unnecessary, and causes excessive CPU load.
#
# Here we only schedule work if there is something for
# the worker to do.

Index: git/drivers/usb/musb/musb_core.c
===================================================================
--- git.orig/drivers/usb/musb/musb_core.c
+++ git/drivers/usb/musb/musb_core.c
@@ -925,7 +925,9 @@ b_host:
 	}
 #endif
 
-	schedule_work(&musb->irq_work);
+	if (musb->xceiv->state != musb->xceiv_old_state) {
+		schedule_work(&musb->irq_work);
+	}
 
 	return handled;
 }

--------------060906000108060200050904--
