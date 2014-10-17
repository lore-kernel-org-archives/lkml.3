Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaJQVRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaJQVRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:17:30 -0400
Date: Fri, 17 Oct 2014 17:17:16 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: intel-gfx@lists.freedesktop.org, joro@8bytes.org
Subject: dmar messages caused by graphics.
Message-ID: <20141017211716.GA9149@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org, joro@8bytes.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this while fuzz-testing, (curiously, no graphics
related stuff was happening, X isn't even loaded on that box).

dmar: DRHD: handling fault status reg 2
dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr 7ffffff000
DMAR:[fault reason 05] PTE Write access is not set


00:02:0 is..

00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v3/4th
Gen Core Processor Integrated Graphics Controller (rev 06) (prog-if 00
		[VGA controller])

00: 86 80 12 04 07 04 90 00 06 00 00 03 00 00 00 00
10: 04 00 00 c0 00 00 00 00 0c 00 00 b0 00 00 00 00
20: 01 30 00 00 00 00 00 00 00 00 00 00 86 80 12 22
30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00


So then I rebooted, and noticed it spewed the exact same message on boot up too.

I power cycled, and this time got

[    0.576231] dmar: Host address width 39
[    0.576336] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.576491] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.576659] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.576793] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
[    0.576961] dmar: RMRR base: 0x000000a2a1f000 end: 0x000000a2a32fff
[    0.577075] dmar: RMRR base: 0x000000ad800000 end: 0x000000af9fffff
[    6.715745] DMAR: No ATSR found
[    8.081845] [drm] DMAR active, disabling use of stolen memory
[    9.927343] dmar: DRHD: handling fault status reg 2
[    9.928335] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr 3c11284000 
DMAR:[fault reason 05] PTE Write access is not set
[   11.916211] dmar: DRHD: handling fault status reg 2
[   11.917105] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr 3c11284000 
DMAR:[fault reason 05] PTE Write access is not set


Same thing, different fault address.  It seems to change every time I boot.


Looking in the logs, this started happening on the 15th. The first instance
was this during boot..

[    9.917240] dmar: DRHD: handling fault status reg 2
[    9.918150] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr 7300000000 
[    9.918150] DMAR:[fault reason 05] PTE Write access is not set
[    9.919582] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr 7ffffff000 
[    9.919582] DMAR:[fault reason 05] PTE Write access is not set
[   10.157240] dmar: DRHD: handling fault status reg 3
[   10.158017] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr 3579736000 
[   10.158017] DMAR:[fault reason 05] PTE Write access is not set
[   11.926114] dmar: DRHD: handling fault status reg 3
[   11.927117] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr 7300000000 
[   11.927117] DMAR:[fault reason 05] PTE Write access is not set

That time, the 'reg 3' showed up.

Dying hardware ? Or bug ?

	Dave

