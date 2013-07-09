Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3GIN6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:58:04 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:41344 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3GIN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:57:06 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH v3 0/4] Enable async page faults on s390 
Date: Tue,  9 Jul 2013 15:56:43 +0200
Message-Id: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070913-3548-0000-0000-000005E2C3E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb, Paolo, 

based on the work from Martin and Carsten, this implementation enables async page faults.
To the guest it will provide the pfault interface, but internally it uses the
async page fault common code. 

The inital submission and it's discussion can be followed on http://www.mail-archive.com/kvm@vger.kernel.org/msg63359.html . 

There is a slight modification for common code to move from a pull to a push based approch on s390. 
As s390 we don't want to wait till we leave the guest state to queue the notification interrupts.

To use this feature the controlling userspace hase to enable the capability.
With that knob we can later on disable this feature for live migration.

v2 -> v3
 - Reworked the architecture specific parts, to only provide on addtional
   implementation
 - Renamed function to kvm_async_page_present_(sync|async)
 - Fixing KVM_HVA_ERR_BAD handling

v1 -> v2:
 - Adding other architecture backends
 - Adding documentation for the ioctl
 - Improving the overall error handling
 - Reducing the needed modifications on the common code


Dominik Dingel (4):
  PF: Add FAULT_FLAG_RETRY_NOWAIT for guest fault
  PF: Make KVM_HVA_ERR_BAD usable on s390
  PF: Provide additional direct page notification
  PF: Async page fault support on s390

 Documentation/s390/kvm.txt        |  24 +++++++++
 arch/s390/include/asm/kvm_host.h  |  22 ++++++++
 arch/s390/include/asm/pgtable.h   |   2 +
 arch/s390/include/asm/processor.h |   1 +
 arch/s390/include/uapi/asm/kvm.h  |  10 ++++
 arch/s390/kvm/Kconfig             |   2 +
 arch/s390/kvm/Makefile            |   2 +-
 arch/s390/kvm/diag.c              |  57 ++++++++++++++++++++
 arch/s390/kvm/interrupt.c         |  38 ++++++++++---
 arch/s390/kvm/kvm-s390.c          | 111 ++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h          |   4 ++
 arch/s390/kvm/sigp.c              |   2 +
 arch/s390/mm/fault.c              |  26 +++++++--
 arch/x86/kvm/mmu.c                |   2 +-
 include/linux/kvm_host.h          |  16 +++++-
 include/uapi/linux/kvm.h          |   2 +
 virt/kvm/Kconfig                  |   4 ++
 virt/kvm/async_pf.c               |  22 ++++++--
 18 files changed, 330 insertions(+), 17 deletions(-)

-- 
1.8.2.2

