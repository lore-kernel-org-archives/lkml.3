Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaG1MJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:09:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49003 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbaG1MJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:09:47 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] staging: comedi: amplc_pc236: split into separate ISA and PCI drivers
Date: Mon, 28 Jul 2014 13:09:28 +0100
Message-Id: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "amplc_pc236" module is a low-level comedi driver that handles both
ISA boards (Amplicon PC36AT) and PCI boards (Amplicon PCI236).  Since
support for each is controlled by two separate kernel configuration
options, the module needs a small number of CPP conditionals to handle
the three different combinations (not counting the case where neither
option is enabled).

Split the module into three separate modules - "amplc_pci236" for the
Amplicon PCI236, the existing "amplc_pc236" for the PC36AT, and
"amplc_pc236_common" for the common code.

I may rename "amplc_pc236" to "amplc_pc36at" with a module alias to the
old module name, but it's such an old board, it may not be worth it.

1) staging: comedi: amplc_pc236: move static board data
2) staging: comedi: amplc_pc236: don't disable h/w interrupt on detach()
3) staging: comedi: amplc_pc236: add callback to enable/disable
   interrupt
4) staging: comedi: amplc_pc236: combine interrupt enable/disable
   functions
5) staging: comedi: amplc_pc236: add callback to check and clear
   interrupt
6) staging: comedi: amplc_pc236: split into ISA, PCI and common module
7) staging: comedi: amplc_pc236, amplc_pci236: get rid of bustype

I think this warning in PATCH 6 is a false positive:

WARNING: Missing a blank line after declarations
#535: FILE: drivers/staging/comedi/drivers/amplc_pc236.h:33:
+	enum pc236_bustype bustype;
+	void (*intr_update_cb)(struct comedi_device *dev, bool enable);

total: 0 errors, 1 warnings, 856 lines checked

 drivers/staging/comedi/Kconfig                     |   2 +-
 drivers/staging/comedi/drivers/Makefile            |   4 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       | 379 +--------------------
 drivers/staging/comedi/drivers/amplc_pc236.h       |  42 +++
 .../staging/comedi/drivers/amplc_pc236_common.c    | 206 +++++++++++
 drivers/staging/comedi/drivers/amplc_pci236.c      | 161 +++++++++
 6 files changed, 429 insertions(+), 365 deletions(-)
