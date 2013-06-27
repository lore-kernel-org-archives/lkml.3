Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3F0IdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:33:05 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55410 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3F0IdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:33:02 -0400
Subject: [PATCH v2 0/3] Nvram-to-pstore: compression support for oops data
To: tony.luck@intel.com, keescook@chromium.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        paulus@samba.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, mahesh@linux.vnet.ibm.com,
        cbouatmailru@gmail.com, anton@samba.org, ccross@android.com
Date: Thu, 27 Jun 2013 14:02:47 +0530
Message-ID: <20130627082941.16749.67023.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062719-3568-0000-0000-000003D705EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
		- Add header size argument in the pstore write callback
		instead of a separate API to return header size.

The patchset takes care of compressing oops messages while writing to NVRAM,
so that more oops data can be captured in the given space.

big_oops_buf (2.22 * oops_data_sz) is allocated for compression.
oops_data_sz is oops header size less of oops partition size.

Pstore will internally call kmsg_dump to capture messages from printk
buffer. While returning the data to nvram it adds is own header.

For compression:
	Register pstore with big_oops_buf. 

In case compression fails, copy header added by pstore and
last oops_data_sz bytes (recent messages) of big_oops_buf to
nvram for which we need to know header size. 
	
patch 01/03 adds an additional argument for header size in pstore_write callback.

pstore read callback of nvram will read the compressed data and return the
decompressed data so that dmesg file (under /dev/pstore) is readable.

In case decompression fails, instead of having the compressed data (junk) in the
dmesg file it will skip and continue reading other partitions. This results in
absence of dmesg file but will still have files relating to other parititons.

---

Aruna Balakrishnaiah (3):
      Pass header size in the pstore write callback
      powerpc/pseries: Re-organise the oops compression code
      powerpc/pseries: Support compression of oops text via pstore


 arch/powerpc/platforms/pseries/nvram.c |  239 +++++++++++++++++++++++---------
 drivers/acpi/apei/erst.c               |    4 -
 drivers/firmware/efi/efi-pstore.c      |    2 
 fs/pstore/platform.c                   |   10 +
 fs/pstore/ram.c                        |    3 
 include/linux/pstore.h                 |    8 +
 6 files changed, 187 insertions(+), 79 deletions(-)

-- 

