Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbaDHQey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:34:54 -0400
Received: from mail1.start.ca ([64.140.120.57]:48680 "EHLO mail1.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbaDHQex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:34:53 -0400
Message-ID: <5344251D.7040805@pobox.com>
Date: Tue, 08 Apr 2014 12:34:37 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, yinghai@kernel.org, tytso@mit.edu
Subject: driver skip pci_set_master, fix it?  No.
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working a couple of drivers for chips that perform extensive bus-mastering ops.
These including full SRIOV support, and allow assigning virtual functions to virtual machines, etc.

One thing the driver (still in development) does for safety,
is defer the call to pci_set_master() until *after* it has mapped
the MMIO space of the chips, so it can reset/flush the DMA engines
before giving them permission to scribble over host RAM.

But a recent patch to the kernel has removed this from the driver's control.
The core PCI now does pci_set_master() immediately on pci_enable_device().

This could be catastrophic in some situations, depending upon the state
of the DMA engines in the device.  If they have "leftovers" from a previous "life"
(or a previous VM assignment), then they'll immediately resume accessing host RAM
as soon as the driver calls pci_enable_device(), courtesy of the embedded call
to pci_set_master().

This isn't good, and these may not be the only devices affected in this way.

Can we perhaps not do that, or provide some other way to return control of bus-mastering
to the device driver ?
--
mlord@pobox.com
Mark Lord
