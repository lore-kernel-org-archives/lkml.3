Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaDAEHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:07:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaDAEHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:07:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Williamson <awilliam@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 5/9] Input: cypress_ps2 - dont report as a button pads
Date: Mon, 31 Mar 2014 21:08:19 -0700
Message-Id: <20140401040756.009755147@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040754.479538406@linuxfoundation.org>
References: <20140401040754.479538406@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/cypress_ps2.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -410,7 +410,6 @@ static int cypress_set_input_params(stru
 	__clear_bit(REL_X, input->relbit);
 	__clear_bit(REL_Y, input->relbit);
 
-	__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(BTN_LEFT, input->keybit);
 	__set_bit(BTN_RIGHT, input->keybit);


