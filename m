Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935479AbaBDXGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:06:07 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:45487 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231AbaBDXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:06:03 -0500
Message-ID: <52F17257.8020303@lwfinger.net>
Date: Tue, 04 Feb 2014 17:05:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: andrea.merello@gmail.com
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Subject: Re: rtl8821ae.
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail> <20140202160512.GA4946@redhat.com> <201402021807.37772.s.L-H@gmx.de> <52EFCC66.9020304@lwfinger.net> <20140203201228.GE26722@mwanda> <CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com> <CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com> <20140204092836.GG26776@mwanda> <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com> <52F12A10.3020600@lwfinger.net> <CAN8YU5PzKE-6Y_651hSwwx1p2i682qi3TYibL5Bu0rBFOJv4cw@mail.gmail.com>
In-Reply-To: <CAN8YU5PzKE-6Y_651hSwwx1p2i682qi3TYibL5Bu0rBFOJv4cw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040001080705060609020706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040001080705060609020706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/04/2014 01:57 PM, Andrea Merello wrote:
> Sorry, my fault.. you had already reported me the iowrite16 vs
> iowrite8 for anaparam3 issue, but I forgot to fix it :(
>
> If you are reasonably sure that a 16bits-wide write is OK on the
> rtl8187b hardware (In reference code I have here only 8bits are
> written), then I agree applying your fix, and I will leave unchanged
> my modifications.
> Otherwise, if you are unsure, I will revert thing in the common
> rtl818x struct (switching back to 8bit type) and I simply make a cast
> on rtl8187se, or I will use an union if possible, so the rtl8187b
> driver remains unchanged.
>
> On the other hand, for the remaining issues with changed names for
> bitfield (the XXXX_SHIFT), I wil vote to fix the rtl8187 driver:
> That names IMHO are wrong (misleading) and while fixing them should
> help avoid future confusion, the fix is trivial enough that I'm really
> confident not to broke anything.
>
> I had already sent a patch for it:

Somehow I missed this patch. Do you know if John Linville picked it up?

I'm not sure if the ANAPARAM3 register could handle a 16-bit write on an 
RTL8187B. To be cautious, I wrote and have tested the attached patch using a 
union. The patch includes a fix for an undefined symbol 
(RTL818X_TX_CONF_HW_SEQNUM). With this patch my RTL8187SE and RTL8187B devices 
both work.

Larry


--------------040001080705060609020706
Content-Type: text/plain; charset=UTF-8;
 name="fix_anaparam3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix_anaparam3"

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -592,7 +592,7 @@ static void rtl8187_set_anaparam(struct
 	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, anaparam);
 	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, anaparam2);
 	if (priv->is_rtl8187b)
-		rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, anaparam3);
+		rtl818x_iowrite8(priv, &priv->map->ANAPARAM3A, anaparam3);
 	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
@@ -949,7 +949,7 @@ static int rtl8187_start(struct ieee8021
 		rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
 
 		rtl818x_iowrite32(priv, &priv->map->TX_CONF,
-				  RTL818X_TX_CONF_HW_SEQNUM |
+				  RTL818X_TX_CONF_SW_SEQNUM |
 				  RTL818X_TX_CONF_DISREQQSIZE |
 				  (RETRY_COUNT << 8  /* short retry limit */) |
 				  (RETRY_COUNT << 0  /* long retry limit */) |
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl818x.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl818x.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl818x.h
@@ -309,7 +309,10 @@ struct rtl818x_csr {
 	__le32	RDSAR; /* 0xe4 */
 	__le16	TID_AC_MAP; /* 0xe8 */
 	u8	reserved_20[4];
-	__le16	ANAPARAM3; /* 0xee */
+	union {
+		__le16	ANAPARAM3; /* 0xee */
+		u8	ANAPARAM3A; /* for rtl8187 */
+	};
 
 #define AC_PARAM_TXOP_LIMIT_SHIFT	16
 #define AC_PARAM_ECW_MAX_SHIFT		12

--------------040001080705060609020706--
