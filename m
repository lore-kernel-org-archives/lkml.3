Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaDPKcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:32:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaDPKcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 01/46] Input: cypress_ps2 - don't report as a button pads
Date: Wed, 16 Apr 2014 11:31:17 +0100
Message-Id: <1397644322-13905-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 6797b39e6f6f34c74177736e146406e894b9482b upstream.

The cypress PS/2 trackpad models supported by the cypress_ps2 driver
emulate BTN_RIGHT events in firmware based on the finger position, as part
of this no motion events are sent when the finger is in the button area.

The INPUT_PROP_BUTTONPAD property is there to indicate to userspace that
BTN_RIGHT events should be emulated in userspace, which is not necessary
in this case.

When INPUT_PROP_BUTTONPAD is advertised userspace will wait for a motion
event before propagating the button event higher up the stack, as it needs
current abs x + y data for its BTN_RIGHT emulation. Since in the
cypress_ps2 pads don't report motion events in the button area, this means
that clicks in the button area end up being ignored, so
INPUT_PROP_BUTTONPAD actually causes problems for these touchpads, and
removing it fixes:

https://bugs.freedesktop.org/show_bug.cgi?id=76341

Reported-by: Adam Williamson <awilliam@redhat.com>
Tested-by: Adam Williamson <awilliam@redhat.com>
Reviewed-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/cypress_ps2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index 888a81a..0aaea7a 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -410,7 +410,6 @@ static int cypress_set_input_params(struct input_dev *input,
 	__clear_bit(REL_X, input->relbit);
 	__clear_bit(REL_Y, input->relbit);
 
-	__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(BTN_LEFT, input->keybit);
 	__set_bit(BTN_RIGHT, input->keybit);
-- 
1.9.1

