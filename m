Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393Ab3B0Q4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab3B0Q4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:56:22 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] HID: multitouch: support of hybrid finger/pen devices
Date: Wed, 27 Feb 2013 17:55:20 +0100
Message-Id: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Here is the support of hybrid devices presenting pen and touch at the same time.
I don't think it's possible to split the handling of the different reports by
several hid drivers unless deepest changes in the HID core subsystem.
The main problem is the control of the underlaying transport layer of the hid
device. For instance, if two drivers (let's say hid-multitouch and hid-generic)
handle the same device, and one of them is removed, then we should not call
hid_hw_stop at this point, but only when the second is also removed.

The other big problem lies with hid drivers that fix the hid report descriptors.
We can not split the hid device before we get the fix, so those drivers should
have a special behavior.

To sum up, I think does not make sense to do such deep changes, and to take such
a risk of breaking existing devices.

So the solution consists in relying inconditionaly to the quirk MULTI_INPUT for
hid-multitouch. Before registering the input device in hid-input, we can test if
it has been populated, and if not, then we simply don't register it. In order to
prevent a regression for drivers that do not fill the input device, we need to
add an other quirk.

Cheers,
Benjamin

Benjamin Tissoires (7):
  HID: input: don't register unmapped input devices
  HID: multitouch: breaks out touch handling in specific functions
  HID: multitouch: do not map usage from non used reports
  HID: multitouch: add handling for pen in dual-sensors device
  HID: multitouch: manually send sync event for pen input report
  HID: multitouch: append " Pen" to the name of the stylus input
  HID: multitouch: force BTN_STYLUS for pen devices

 drivers/hid/hid-input.c      |  77 ++++++++++++++++++++++
 drivers/hid/hid-multitouch.c | 151 ++++++++++++++++++++++++++++++++++++-------
 include/linux/hid.h          |   1 +
 3 files changed, 207 insertions(+), 22 deletions(-)

-- 
1.8.1.2

