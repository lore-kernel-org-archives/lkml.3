Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247AbaFXQk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:40:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbaFXPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 34/52] USB: cdc-acm: fix shutdown and suspend race
Date: Tue, 24 Jun 2014 11:50:49 -0400
Message-Id: <20140624154715.515339967@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
References: <20140624154713.428945460@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ed797074031a37bb9bf4a70952fffc606b77274d upstream.

We should stop I/O unconditionally at suspend rather than rely on the
tty-port initialised flag (which is set prior to stopping I/O during
shutdown) in order to prevent suspend returning with URBs still active.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1470,8 +1470,7 @@ static int acm_suspend(struct usb_interf
 	if (cnt)
 		return 0;
 
-	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags))
-		stop_data_traffic(acm);
+	stop_data_traffic(acm);
 
 	return 0;
 }


