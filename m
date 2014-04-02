Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbaDBU1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:27:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42828 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758869AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 30/40] Input: cypress_ps2 - don't report as a button pads
Date: Wed,  2 Apr 2014 22:13:16 +0200
Message-Id: <5d71b5db63ccb89a0108c421a7f76c01926bacc9.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/cypress_ps2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index 888a81a7ea3d..0aaea7ad6cee 100644
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

