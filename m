Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3LJSsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:48:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab3LJSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:48:30 -0500
Subject: [PATCH 0/3] pci: virtual channel save/restore support
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: ddutile@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 10 Dec 2013 11:48:27 -0700
Message-ID: <20131210183339.26294.14581.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out that even though we don't do much with virtual channel, we
still need to save/restore it around reset.  The case where this comes
into play currently is a card with a switch and multiple devices, all
supporting VC (Nvidia GRID).  On some platforms the system firmware
will leave all the virtual channel capabilities in their default
state, where the VC0 TC/VC map is 0xff (TC0-7 enabled over VC0).
Other systems decide to restrict the available traffic classes and
configure 0x01 (only TC0 over VC0).  At handoff, everything works, but
as soon as we do a device reset, especially if done via bus reset, the
endpoint can be returned to the spec defined default rather than the
platform default.  If such a device is then assigned to a guest, the
guest driver sees multiple TCs enabled, attempts to use them, and it
fails.  The failure mode depends on the platform, ranging from the
driver in the guest failing to work to host panic from an unsupported
transaction.

This series attempts to implement full save/restore support for all
types of virtual channel (VC, MFVC, and VC9).  The buffer sizing code
will execute for any device with these capabilities, but of couse the
actual save/restore is only done if a reset is requested for the
device, which typically means assignment to a VM.  Thanks,

Alex

---

Alex Williamson (3):
      pci: Generalize wait loop
      pci: Add support for save/restore of extended capabilities
      pci: Add Virtual Channel to save/restore support


 drivers/pci/pci.c   |  488 ++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/pci.h |    3 
 2 files changed, 459 insertions(+), 32 deletions(-)
