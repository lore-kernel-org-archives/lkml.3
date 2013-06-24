Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3FXGXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:23:04 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55847 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FXGXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:23:02 -0400
Subject: [RESEND PATCH 0/3] Nvram-to-pstore: compression support for oops
 data 
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 24 Jun 2013 11:52:46 +0530
Message-ID: <20130624061936.12963.72529.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062406-1396-0000-0000-000003292847
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
	
patch 01/03 will add a function in pstore to return the header size.

pstore read callback of nvram will read the compressed data and return the
decompressed data so that dmesg file (under /dev/pstore) is readable.

In case decompression fails, instead of having the compressed data (junk) in the
dmesg file it will skip and continue reading other partitions. This results in
absence of dmesg file but will still have files relating to other parititons.

---

Aruna Balakrishnaiah (3):
      Retreive header size from pstore
      powerpc/pseries: Re-organise the oops compression code
      powerpc/pseries: Support compression of oops text via pstore


 arch/powerpc/platforms/pseries/nvram.c |  236 +++++++++++++++++++++++---------
 fs/pstore/platform.c                   |    7 +
 include/linux/pstore.h                 |    6 +
 3 files changed, 182 insertions(+), 67 deletions(-)

-- 

