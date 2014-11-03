Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaKCDIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:08:23 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:41703 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKCDIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:08:21 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 00/10] Create separate header for ehci-dbgp driver
Date: Sun,  2 Nov 2014 21:07:47 -0600
Message-Id: <1414984077-9750-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more attempt at getting some feedback.

Original:

The FUSBH200 and FOTG210 are not EHCI-compatible and require standalone
drivers.  See discussion at:

  http://comments.gmane.org/gmane.linux.usb.general/84169

But these controllers do implement an EHCI-compatible debug port and
therefore leverage the ehci-dbgp driver.  Rather than pulling in the
necessary declarations from <linux/usb/ehci_def.h>, each driver copies
this code into their own header.  The goal of this series is to pull the
ehci-dbgp related code into its own header to remove the need for this
redundancy.

I have done only minimal testing on this, and I don't use either of
these controller so my ability to test the changes is limited.  But I
thought I'd push it out for comment to see if there was interest.

The only actual change should be when CONFIG_EARLY_PRINTK_DBGP is
disabled and CONFIG_XEN_DOM0 is enabled.  Currently each of these does
not notify Xen of reset events under this configuration.  Since these
events are propagated when CONFIG_EARLY_PRINTK_DBGP and CONFIG_XEN_DOM0
are both enabled, though, it seems that is not a problem (and maybe not
sending them in the former case is a bug?)  Regardless, the motivation
for this change is for consistancy as a step towrads consolidation.  As
I said above, I am not able to actually test these changes on either
controller.

First time submission, so I look forward to any feedback.  If this is of
any interest I will work on testing the various configations and boot
parameters.

Regards,

Chris Rorvick

Chris Rorvick (10):
  usb: Create separate header for ehci-dbgp
  fusbh200: Make Xen notificaiton consistent with EHCI
  fusbh200: Remove superfluous macro definitions
  fusbh200: Remove duplicate ehci-dbgp declarations
  fusbh200: Use ehci_dbg_port struct
  fotg210: Make Xen notificaiton consistent with EHCI
  fotg210: Remove superfluous macro definitions
  fotg210: Remove duplicate ehci-dbgp declarations
  fotg210: Use ehci_dbg_port struct
  usb: Remove __init from early_dbgp_init() prototype

 drivers/usb/host/fotg210.h    | 62 ++------------------------------
 drivers/usb/host/fusbh200.h   | 62 ++------------------------------
 include/linux/usb/ehci-dbgp.h | 83 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/ehci_def.h  | 65 ++-------------------------------
 4 files changed, 91 insertions(+), 181 deletions(-)
 create mode 100644 include/linux/usb/ehci-dbgp.h

-- 
1.9.3

