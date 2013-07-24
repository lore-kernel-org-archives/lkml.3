Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3GXSeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:34:04 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:32872 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3GXSeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:34:01 -0400
Message-ID: <51F01E06.6090800@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 13:33:42 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        isimatu.yasuaki@jp.fujitsu.com
Subject: [PATCH 0/8] Correct memory hot add/remove for powerpc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072418-1396-0000-0000-0000034F6D1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of memory hot add and remove for powerpc is broken.
This patch set both corrects this issue and updates the memory hot add and
remove code for powerpc so that it can be done properly in the kernel.

The first two patches update the powerpc hot add and remove code to work with
all of the updates that have gone in to enable memory remove with sparse
vmemmap enabled. With these two patches applied the powerpc code is back to
working, but not working properly.

The remaining patches update the powerpc memory add and remove code so the
work can be done in the kernel and all while holding the memory hotplug lock.
The current powerpc implementation does some of the work in the kernel and
some of the work in userspace. While this code did work at one time, it has
a problem in that it does part of the work to add and remove memory without
holding the memory hotplug lock. In this scheme memory could be added and
removed fast enough to cause the system to crash. This was a result of
doing part of the add or remove without holding the lock.

In order to do memory hot remove in the kernel, this patch set introduces
a sysfs release file (/sys/device/system/memory/release) which one
can write the physical address of the memory to be removed to. Additionally
there is a new set of flags defined for the memory notification chain to
indicate that memory is being hot added or hot removed. This allows any work
that may need to be done prior to or after memory is hot added or removed
to be performed.

The remaining patches in the patch set update the powerpc to properly do
memory hot add and remove in the kernel.

Nathan Fontenot
---
 Documentation/memory-hotplug.txt                      |   26 ++++
 arch/powerpc/mm/mem.c                                 |   35 +++++-
 arch/powerpc/platforms/pseries/hotplug-memory.c       |   95 +---------------
 drivers/base/memory.c                                 |   81 ++++++++++++--
 linux/Documentation/memory-hotplug.txt                |   34 ++++-
 linux/arch/powerpc/Kconfig                            |    2 
 linux/arch/powerpc/mm/init_64.c                       |    6 +
 linux/arch/powerpc/mm/mem.c                           |    9 +
 linux/arch/powerpc/platforms/pseries/dlpar.c          |  103 ++++++++++++++++++
 linux/arch/powerpc/platforms/pseries/hotplug-memory.c |   60 +---------
 linux/arch/x86/Kconfig                                |    2 
 linux/drivers/base/memory.c                           |   20 +--
 linux/include/linux/memory.h                          |    6 +
 linux/mm/Kconfig                                      |    2 
 linux/mm/memory_hotplug.c                             |   25 +++-
 15 files changed, 322 insertions(+), 184 deletions(-)

