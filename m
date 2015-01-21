Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbbAUG61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:58:27 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:56697 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbAUG60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:58:26 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0L6vx9n016016, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        "micky_ching@realsil.com.cn" <micky_ching@realsil.com.cn>
Subject: Re: [PATCH 1/2] mfd: rtsx_usb: Fix runtime PM deadlock
Thread-Topic: [PATCH 1/2] mfd: rtsx_usb: Fix runtime PM deadlock
Thread-Index: AQHQMJKIzZskAMeueEymq4iTfOtBcJzGsguAgAKDRbGAAHN8AA==
Date: Wed, 21 Jan 2015 06:58:00 +0000
Message-ID: <1421823666.13666.15.camel@debian-rtk5880>
References: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
	 <1421306085-32254-2-git-send-email-rogerable@realtek.com>
	 <20150119094525.GK21886@x1> <1421752080.10290.5.camel@debian-rtk5880>
	 <20150120160736.GM13701@x1>
In-Reply-To: <20150120160736.GM13701@x1>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.81.121]
Content-Type: text/plain; charset="utf-8"
Content-ID: <199D25594586B64292F9B218288D61D8@realtek.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0L6wV2b017944

On Tue, 2015-01-20 at 16:07 +0000, Lee Jones wrote:
> On Tue, 20 Jan 2015, Roger Tseng wrote:
> 
> > On Mon, 2015-01-19 at 09:45 +0000, Lee Jones wrote:
> > > On Thu, 15 Jan 2015, Roger Tseng wrote:
> > > 
> > > > sd_set_power_mode() in derived module drivers/mmc/host/rtsx_usb_sdmmc.c
> > > > acquires dev_mutex and then calls pm_runtime_get_sync() to make sure the
> > > > device is awake while initializing a newly inserted card. Once it is
> > > > called during suspending state and explicitly before rtsx_usb_suspend()
> > > > acquires the same dev_mutex, both routine deadlock and further hang the
> > > > driver because pm_runtime_get_sync() waits the pending PM operations.
> > > > 
> > > > Fix this by using an empty suspend method. mmc_core always turns the
> > > > LED off after a request is done and thus it is ok to remove the only
> > > > rtsx_usb_turn_off_led() here.
> > > > 
> > > > Cc: <stable@vger.kernel.org> # v3.16+
> > > > Fixes: 730876be2566 ("mfd: Add realtek USB card reader driver")
> > > > Signed-off-by: Roger Tseng <rogerable@realtek.com>
> > > > ---
> > > >  drivers/mfd/rtsx_usb.c | 9 ---------
> > > >  1 file changed, 9 deletions(-)
> > > 
> > > Applied, thanks.
> > > 
> > I'm sorry but build bot from Intel just reported me that I forgot to
> > delete an unused variable "ucr" between two commits. My bad.
> > 
> > Do I have a chance to send v2?
> 
> You're lucky I'm in a good mood. ;)
> 
> I fixed it already.
> 
That's great, thanks! And thus patch 2/2 also needs to be changed
accordingly.

By the way, the build bot reported again about an undefined variable
build error in 2/2(I'm sorry for this again). I put the overall updated
content of 2/2 here for you if you're going to fix it, or I can also
re-send it individually.

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 210d1f85679e..ede50244f265 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -681,9 +681,27 @@ static void rtsx_usb_disconnect(struct
usb_interface *intf)
 #ifdef CONFIG_PM
 static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t
message)
 {
+	struct rtsx_ucr *ucr =
+		(struct rtsx_ucr *)usb_get_intfdata(intf);
+	u16 val = 0;
+
 	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
 			__func__, message.event);
 
+	if (PMSG_IS_AUTO(message)) {
+		if (mutex_trylock(&ucr->dev_mutex)) {
+			rtsx_usb_get_card_status(ucr, &val);
+			mutex_unlock(&ucr->dev_mutex);
+
+			/* Defer the autosuspend if card exists */
+			if (val & (SD_CD | MS_CD))
+				return -EAGAIN;
+		} else {
+			/* There is an ongoing operation*/
+			return -EAGAIN;
+		}
+	}
+
 	return 0;
 }



> > > > diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> > > > index dbdd0faeb6ce..076694126e5d 100644
> > > > --- a/drivers/mfd/rtsx_usb.c
> > > > +++ b/drivers/mfd/rtsx_usb.c
> > > > @@ -687,15 +687,6 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
> > > >  	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
> > > >  			__func__, message.event);
> > > >  
> > > > -	/*
> > > > -	 * Call to make sure LED is off during suspend to save more power.
> > > > -	 * It is NOT a permanent state and could be turned on anytime later.
> > > > -	 * Thus no need to call turn_on when resunming.
> > > > -	 */
> > > > -	mutex_lock(&ucr->dev_mutex);
> > > > -	rtsx_usb_turn_off_led(ucr);
> > > > -	mutex_unlock(&ucr->dev_mutex);
> > > > -
> > > >  	return 0;
> > > >  }
> > > >  
> > > 
> > 
> 

-- 
Best regards,
Roger Tseng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
