Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaJ1DZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:25:42 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33474 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaJ1DZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:25:40 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2] CXL: Fix PSL error due to duplicate segment table entries
Date: Tue, 28 Oct 2014 14:25:26 +1100
Message-Id: <1414466730-15591-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102803-0021-0000-0000-0000006A2B18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain circumstances the PSL (Power Service Layer, which provides
translation services for CXL hardware) can send an interrupt for a segment miss
that the kernel has already handled. This can happen if multiple translations
for the same segment are queued in the PSL before the kernel has restarted the
first translation.

The CXL driver does not expect this situation and does not check if a segment
had already been handled. This could cause a duplicate segment table entry
which in turn caused a PSL error taking down the card.

This patch series fixes the issue by checking for existing entries in the
segment table that match the segment it is trying to insert to avoid inserting
duplicate entries.

Some of the code has been refactored to simplify it - the segment table
hash has been moved from cxl_load_segment to find_free_sste where it is
used and we have disabled the secondary hash in the segment table to
reduce the number of entries that need to be tested from 16 to 8. Due to
the large segment sizes we use it is extremely unlikely that the
secondary hash would ever have been used in practice, so this should not
have any negative impacts and may even improve performance.

copro_calculate_slb didn't use the correct ESID mask for 1T vs 256M segments,
which was not a problem as the extra bits were ignored. This series fixes it to
use the correct mask to make debugging easier and so that we can directly
compare the ESID values for duplicates without needing to worry about masking
in the comparison.

- Patch 1 disables the secondary hash in the segment table to simplify the code.

- Patch 2 cleans up and refactors cxl_load_segment and find_free_sste to move
  the hash calculation to where it is actually used.

- Patch 3 fixes the ESID returned by copro_calculate_slb to be properly masked
  based on the segment size.

- Patch 4 prevents duplicate segment table entries from being inserted to fix
  PSL errors resulting from this situation.

Changes since v1:
- Split patch out into separate patches for cleanups and bug fix

