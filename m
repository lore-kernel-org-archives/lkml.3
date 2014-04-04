Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaDDVNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:13:48 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:61095 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbaDDVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:13:47 -0400
To: bp@alien8.de
Cc: tony.luck@intel.com, hpa@zytor.com, mingo@kernel.org,
        dougthompson@xmission.com, m.chehab@samsung.com,
        mitake@dcl.info.waseda.ac.jp, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1396645124.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 0/3] Add new ie31200_edac driver
Date: Fri,  4 Apr 2014 21:13:45 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Add support for memory errors for the Intel E3-1200 processors.

While testing the driver, I found that doing a readq() on the
memory mapped memory controller hub registers caused a hard lockup
on my x86_64 system. It turns out that a read across a DW boundary
is a no no here.

"
Software must not access B0/D0/F0 32-bit memory-mapped registers with
requests that cross a DW boundary.
"

(http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200-family-vol-2-datasheet.html p. 16)

Thus, I've added a generic lo_hi_[read|write]_q API, to deal with
this issue.

I think longer term the right thing is maybe to simply add these
definitions to include/asm-generic/io.h, as I didn't see any
in tree users of 'io-64-nonatomic-hi-lo.h', and simply remove
io-64-nonatomic-hi-lo.h and io-64-nonatomic-lo-hi.h. But I didn't want to
tie that cleanup to this edac driver submission.

Thanks,

-Jason


Jason Baron (3):
  readq/writeq: Add explicit lo_hi_[read|write]_q and hi_lo_[read|write]_q
  x38_edac: make use of lo_hi_readq()
  ie31200_edac: Add driver

 drivers/edac/Kconfig                        |   7 +
 drivers/edac/Makefile                       |   1 +
 drivers/edac/ie31200_edac.c                 | 540 ++++++++++++++++++++++++++++
 drivers/edac/x38_edac.c                     |  15 +-
 include/asm-generic/io-64-nonatomic-hi-lo.h |  14 +-
 include/asm-generic/io-64-nonatomic-lo-hi.h |  14 +-
 6 files changed, 572 insertions(+), 19 deletions(-)
 create mode 100644 drivers/edac/ie31200_edac.c

-- 
1.8.2.rc2

