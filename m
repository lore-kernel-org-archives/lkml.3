Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585AbbA1EZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:42 -0500
Received: from mail.kernel.org ([198.145.29.136]:41165 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965246AbbA1EZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:37 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 155/177] Input: alps - allow up to 2 invalid packets without resetting device
Date: Wed, 28 Jan 2015 12:10:13 +0800
Message-Id: <1422418236-12852-246-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 9d720b34c0a432639252f63012e18b0507f5b432 upstream.

On some Dell Latitude laptops ALPS device or Dell EC send one invalid byte
in 6 bytes ALPS packet. In this case psmouse driver enter out of sync
state. It looks like that all other bytes in packets are valid and also
device working properly. So there is no need to do full device reset, just
need to wait for byte which match condition for first byte (start of
packet). Because ALPS packets are bigger (6 or 8 bytes) default limit is
small.

This patch increase number of invalid bytes to size of 2 ALPS packets which
psmouse driver can drop before do full reset.

Resetting ALPS devices take some time and when doing reset on some Dell
laptops touchpad, trackstick and also keyboard do not respond. So it is
better to do it only if really necessary.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/input/mouse/alps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index e03a0ae..9854a1f 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1625,6 +1625,9 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now */
 	psmouse->resync_time = 0;
 
+	/* Allow 2 invalid packets without resetting device */
+	psmouse->resetafter = psmouse->pktsize * 2;
+
 	return 0;
 
 init_fail:
-- 
1.9.1

