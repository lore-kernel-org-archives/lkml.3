Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaBRWr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:47:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaBRWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@fedoraproject.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.13 27/40] [media] mxl111sf: Fix unintentional garbage stack read
Date: Tue, 18 Feb 2014 14:47:28 -0800
Message-Id: <20140218224434.101783899@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@fedoraproject.org>

commit 866e8d8a9dc1ebb4f9e67197e264ac2df81f7d4b upstream.

mxl111sf_read_reg takes an address of a variable to write to as an argument.
drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c:mxl111sf_config_pin_mux_modes
passes several uninitialized stack variables to this routine, expecting
them to be filled in.  In the event that something unexpected happens when
reading from the chip, we end up doing a pr_debug of the value passed in,
revealing whatever garbage happened to be on the stack.

Change the pr_debug to match what happens in the 'success' case, where we
assign buf[1] to *data.

Spotted with Coverity (Bugs 731910 through 731917)

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -105,7 +105,7 @@ int mxl111sf_read_reg(struct mxl111sf_st
 		ret = -EINVAL;
 	}
 
-	pr_debug("R: (0x%02x, 0x%02x)\n", addr, *data);
+	pr_debug("R: (0x%02x, 0x%02x)\n", addr, buf[1]);
 fail:
 	return ret;
 }


