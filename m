Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3ASBeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:34:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:56369 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab3ASBR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [ 15/33] usb: chipidea: Allow disabling streaming not only in udc mode
Date: Fri, 18 Jan 2013 17:16:40 -0800
Message-Id: <20130119010351.180251837@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 929473ea05db455ad88cdc081f2adc556b8dc48f upstream.

When running a scp transfer using a USB/Ethernet adapter the following crash
happens:

$ scp test.tar.gz fabio@192.168.1.100:/home/fabio
fabio@192.168.1.100's password:
test.tar.gz                                      0%    0     0.0KB/s   --:-- ETA
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x2cc/0x2f0()
NETDEV WATCHDOG: eth0 (asix): transmit queue 0 timed out
Modules linked in:
Backtrace:
[<80011c94>] (dump_backtrace+0x0/0x10c) from [<804d3a5c>] (dump_stack+0x18/0x1c)
 r6:000000ff r5:80412388 r4:80685dc0 r3:80696cc0
[<804d3a44>] (dump_stack+0x0/0x1c) from [<80021868>]
(warn_slowpath_common+0x54/0x6c)
[<80021814>] (warn_slowpath_common+0x0/0x6c) from [<80021924>]
(warn_slowpath_fmt+0x38/0x40)
...

Setting SDIS (Stream Disable Mode- bit 4 of USBMODE register) fixes the problem.

However, in current code CI13XXX_DISABLE_STREAMING flag is only set in udc mode,
so allow disabling streaming also in host mode.

Tested on a mx6qsabrelite board.

Suggested-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Reviewed-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/host.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -129,6 +129,9 @@ static int host_start(struct ci13xxx *ci
 	else
 		ci->hcd = hcd;
 
+	if (ci->platdata->flags & CI13XXX_DISABLE_STREAMING)
+		hw_write(ci, OP_USBMODE, USBMODE_CI_SDIS, USBMODE_CI_SDIS);
+
 	return ret;
 }
 


