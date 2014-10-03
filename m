Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaJCWyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:54:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaJCWYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ed Butler <ressy66@ausics.net>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 043/143] USB: option: reduce interrupt-urb logging verbosity
Date: Fri,  3 Oct 2014 14:33:58 -0700
Message-Id: <20141003213315.774172458@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit f0e4cba2534cd88476dff920727c81350130f3c5 upstream.

Do not log normal interrupt-urb shutdowns as errors.

The option driver has always been logging any nonzero interrupt-urb
status as an error, including when the urb is killed during normal
operation.

Commit 9096f1fbba91 ("USB: usb_wwan: fix potential NULL-deref at
resume") moved the interrupt urb submission from port probe and release
to open and close, thus potentially increasing the number of these
false-positive error messages dramatically.

Reported-by: Ed Butler <ressy66@ausics.net>
Tested-by: Ed Butler <ressy66@ausics.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1917,6 +1917,8 @@ static void option_instat_callback(struc
 			dev_dbg(dev, "%s: type %x req %x\n", __func__,
 				req_pkt->bRequestType, req_pkt->bRequest);
 		}
+	} else if (status == -ENOENT || status == -ESHUTDOWN) {
+		dev_dbg(dev, "%s: urb stopped: %d\n", __func__, status);
 	} else
 		dev_err(dev, "%s: error %d\n", __func__, status);
 


