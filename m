Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab3BNRlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:41:50 -0500
Received: from canardo.mork.no ([148.122.252.1]:41490 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934487Ab3BNRlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:41:40 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Alex Courbot <acourbot@nvidia.com>
Cc: USB list <linux-usb@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: usb_wwan_write() called while device still being resumed
Organization: m
References: <511CBCE8.9070204@nvidia.com>
Date: Thu, 14 Feb 2013 18:41:27 +0100
In-Reply-To: <511CBCE8.9070204@nvidia.com> (Alex Courbot's message of "Thu, 14
	Feb 2013 19:31:04 +0900")
Message-ID: <87ehgivlmg.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Courbot <acourbot@nvidia.com> writes:

> The board features a USB GSM modem using the usb_wwan module. Once in
> a while, when the system resumes from LP0, a NET_RX softirq will be
> triggered while the modem is still being resumed, calling
> usb_wwan_write(). This will cause usb_autopm_get_interface_async()
> inside usb_wwan_write() to fail because the runtime PM disable_depth
> is still equal to 1 since device_resume() has not completed yet. As a
> result, the modem just stops working.

I believe the usb_autopm_get_interface_async() failing is OK in this
case, but that should not cause the modem to stop working.

Wonder if this patch solves the problem? :

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Date: Thu, 14 Feb 2013 18:34:48 +0100
Subject: [PATCH] USB: usb_wwan: clear port busy state on error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reported-by: Alex Courbot <acourbot@nvidia.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/usb/serial/usb_wwan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 01c94aa..44e106d 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -230,8 +230,10 @@ int usb_wwan_write(struct tty_struct *tty, struct usb_serial_port *port,
 			usb_pipeendpoint(this_urb->pipe), i);
 
 		err = usb_autopm_get_interface_async(port->serial->interface);
-		if (err < 0)
+		if (err < 0) {
+			clear_bit(i, &portdata->out_busy);
 			break;
+		}
 
 		/* send the data */
 		memcpy(this_urb->transfer_buffer, buf, todo);
-- 
1.7.10.4

