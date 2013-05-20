Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab3ETXbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:31:14 -0400
Received: from mout.gmx.net ([212.227.17.22]:65394 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384Ab3ETXbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:31:13 -0400
X-Authenticated: #885997
X-Provags-ID: V01U2FsdGVkX18NnXVOanINfS+AteAEhKh6XZKDSrQmaQlF6VVvJq
	4hW/QmECpDDtBf
From: Christian Ohm <chr.ohm@gmx.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Holtek gaming mouse driver, and the necessity for it instead of increasing HID_MAX_USAGES
Date: Tue, 21 May 2013 01:31:07 +0200
Message-Id: <cover.1369083628.git.chr.ohm@gmx.net>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,


Since I have a Sharkoon Drakonia which by default doesn't work with Linux, I
did some research into making it work. A solution isn't hard to find, the usual
suggestion is to increase HID_MAX_USAGES to at least 32k, e.g. in
http://askubuntu.com/questions/232564/sharkoon-drakonia-gaming-mouse-doesnt-work-at-all
Searching for HID_MAX_USAGES turns up
http://www.spinics.net/lists/linux-input/msg09832.html and
http://www.spinics.net/lists/linux-input/msg22479.html, both of which ask about
increasing it in the mainline kernel (which would make all such devices work
without the need for a custom driver for each of them), but both didn't get any
reaction.

Is there any reason why HID_MAX_USAGES shouldn't be more than 12288?  Digging
through the kernel history it started out as 256 in 2.3.36pre6, then was
quickly increased to 512 in 2.3.47pre4 and 1024 in 2.3.49pre2. Then it stayed
that way for ~7 years, until b55fd23ccdf32f969a7b4180c6e52d62d8e99972 changed
it to 8192 in 2007 and 5f1ab74f650b392ebcaa7cf3283e56d8dc6c7e56 to its current
value of 12288 in 2008. To me every change looks like "we found hardware that
needed a higher value, so we increased it". Now it seems to be "the hardware
surely reports a wrong value". Investigating if there is a limit for usages, I
only found http://www.usb.org/developers/devclass_docs/Hut1_12v2.pdf which says
on page 15 that "Usage ID values are limited to 16 bits".


But in case there is a reason why HID_MAX_USAGES should stay at 12288 that I
just didn't find, I've written a little driver for some of the mice that then
need their report descriptors adjusted.

The first patch adds a driver for USB ID 04d9:a067 (aka Sharkoon Drakonia or
Perixx MX-2000). The only thing it does is adjust the usage maximum and logical
maximum, like hid-holtek-kbd.c does. I'm not sure why that one also changes the
logical maximum, and the driver works without that here as well.

The second patch adds support for USB ID 04d9:a04a (aka Tracer Sniper TRM-503,
NOVA Gaming Slider X200 or Zalman ZM-GM1). I don't have that one, but found a
full report descriptor for it in
https://bugzilla.novell.com/show_bug.cgi?id=774676, compared it to mine, and
the only relevant difference seems to be that this report is nine bytes
shorter, and misses a portion before the usages maximum, so I adjusted all
offsets by -9.

There's also 04d9:a078
(http://forums.opensuse.org/english/get-technical-help-here/hardware/473200-usb-gaming-mouse-04d9-a078-not-working-linux-plus-workaround.html)
for which I didn't find a full report descriptor, but the relevant part seems
to have the same length as that of 04d9:a04a. I guess it wouldn't hurt to add
the a078 id to the a04a case, since either the values check out, then it works,
or they don't, then nothing happens. But that is even more speculative than the
second patch, so no third patch for that.


Best regards,
Christian Ohm

---

Christian Ohm (2):
  HID: Add driver for Holtek gaming mouse 04d9:a067
  HID: Add support for Holtek gaming mouse 04d9:a04a

 drivers/hid/Kconfig            |    3 ++
 drivers/hid/Makefile           |    1 +
 drivers/hid/hid-holtek-mouse.c |   88 ++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ids.h          |    2 +
 4 files changed, 94 insertions(+)
 create mode 100644 drivers/hid/hid-holtek-mouse.c

-- 
1.7.10.4

