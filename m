Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3DADv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:51:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62038 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3DADvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:51:25 -0400
X-Spam-Score: -100.8
Message-ID: <5159041F.7020608@asianux.com>
Date: Mon, 01 Apr 2013 11:50:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: jhovold@gmail.com, Jiri Slaby <jslaby@suse.cz>, mferrell@uplogix.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/usb/serial: looping issue: avoid the return value
 overriden by looping
References: <5158F689.5040406@asianux.com> <20130401030555.GA21113@kroah.com>
In-Reply-To: <20130401030555.GA21113@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  inside the 'for' looping:
    the return value 'rv' may override if not have a check in time.

  next checking, outside the 'for' looping:
    can not find failure which generated during the 'for' looping

  so need let outside know about the failure.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/usb/serial/mos7840.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index a0d5ea5..13aae1e 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -651,7 +651,9 @@ static void mos7840_interrupt_callback(struct urb *urb)
 					wreg = MODEM_STATUS_REGISTER;
 					break;
 				}
-				rv = mos7840_get_reg(mos7840_port, wval, wreg, &Data);
+				if (mos7840_get_reg(mos7840_port, wval,
+				    wreg, &Data) < 0)
+					rv = -1;
 			}
 		}
 	}
-- 
1.7.7.6
