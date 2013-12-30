Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3L3P4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:56:54 -0500
Received: from smtp206.alice.it ([82.57.200.102]:37657 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab3L3P4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:56:52 -0500
Date: Mon, 30 Dec 2013 16:56:25 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: hdegoede@redhat.com, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: question about drivers/media/usb/gspca/kinect.c
Message-Id: <20131230165625.814796d9e041d2261e1d078a@studenti.unina.it>
In-Reply-To: <alpine.DEB.2.02.1312251956490.2020@localhost6.localdomain6>
References: <alpine.DEB.2.02.1312251956490.2020@localhost6.localdomain6>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Dec 2013 20:00:34 +0100 (CET)
Julia Lawall <julia.lawall@lip6.fr> wrote:

> The following code, in the function send_cmd, looks too concise:
> 
>         do {
>                 actual_len = kinect_read(udev, ibuf, 0x200);
>         } while (actual_len == 0);
>         PDEBUG(D_USBO, "Control reply: %d", res);
>         if (actual_len < sizeof(*rhdr)) {
>                 pr_err("send_cmd: Input control transfer failed (%d)\n", res);
>                 return res;
>         }
> 
> It seems that actual_len might be less than sizeof(*rhdr) either because 
> an error code is returned by the call to kinect_read or because a shorter 
> length is returned than the desired one.  In the error code case, I would 
> guess that one would want to return the error code, but I don't know what 
> on would want to return in the other case.  In any case, res is not 
> defined by this code, so what is returned is whatever the result of the 
> previous call to kinect_write happened to be.
> 
> How should the code be changed?
>

Thanks Julia,

some other drivers return -EIO when the actual transfer length does not
match the requested one[1], and from Documentation/usb/error-codes.txt
[2] it looks like -EREMOTEIO is also used to represent partial
transfers in some cases. So I'd say either one of the two is OK.

The interested code is almost the same used in libfreenect[3], so I'd
stay with a minimal change here:

diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 3773a8a..48084736 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -158,7 +158,7 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
        PDEBUG(D_USBO, "Control reply: %d", res);
        if (actual_len < sizeof(*rhdr)) {
                pr_err("send_cmd: Input control transfer failed (%d)\n", res);
-               return res;
+               return actual_len < 0 ? actual_len : -EREMOTEIO;
        }
        actual_len -= sizeof(*rhdr);

Proper patches on their way, to libfreenect too.

Thanks again,
   Antonio

[1]
http://lxr.linux.no/#linux+v3.12.6/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c#L37
[2]
http://lxr.linux.no/#linux+v3.12.6/Documentation/usb/error-codes.txt#L134
[3]
https://github.com/OpenKinect/libfreenect/blob/master/src/flags.c#L87

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
