Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3AXDcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:32:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3AXDcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:32:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 73/74] usb: chipidea: Allow disabling streaming not only in udc mode
Date: Thu, 24 Jan 2013 01:27:25 -0200
Message-Id: <1358998046-613-74-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: ci->platdata->flags is ci->udc_driver->flags on 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/chipidea/host.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index 9eacd21..2400d18 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -128,6 +128,9 @@ static int host_start(struct ci13xxx *ci)
 	else
 		ci->hcd = hcd;
 
+	if (ci->udc_driver->flags & CI13XXX_DISABLE_STREAMING)
+		hw_write(ci, OP_USBMODE, USBMODE_CI_SDIS, USBMODE_CI_SDIS);
+
 	return ret;
 }
 
-- 
1.7.9.5

