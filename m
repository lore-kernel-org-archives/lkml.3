Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab3GEU4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:56:16 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:47714 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3GEU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:56:09 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 0/4] Enable async page faults on s390 
Date: Fri,  5 Jul 2013 22:55:50 +0200
Message-Id: <1373057754-59225-1-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070520-6892-0000-0000-0000059C5AC5
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

v1 -> v2:
 - Adding other architecture backends
 - Adding documentation for the ioctl
 - Improving the overall error handling
 - Reducing the needed modifications on the common code

Dominik Dingel (4):
  PF: Add FAULT_FLAG_RETRY_NOWAIT for guest fault
  PF: Move architecture specifics to the backends
  PF: Provide additional direct page notification
  PF: Async page fault support on s390

 Documentation/s390/kvm.txt          |  24 ++++++++
 arch/arm/include/asm/kvm_host.h     |   8 +++
 arch/ia64/include/asm/kvm_host.h    |   3 +
 arch/mips/include/asm/kvm_host.h    |   6 ++
 arch/powerpc/include/asm/kvm_host.h |   8 +++
 arch/s390/include/asm/kvm_host.h    |  34 +++++++++++
 arch/s390/include/asm/pgtable.h     |   2 +
 arch/s390/include/asm/processor.h   |   1 +
 arch/s390/include/uapi/asm/kvm.h    |  10 ++++
 arch/s390/kvm/Kconfig               |   2 +
 arch/s390/kvm/Makefile              |   2 +-
 arch/s390/kvm/diag.c                |  57 ++++++++++++++++++
 arch/s390/kvm/interrupt.c           |  38 +++++++++---
 arch/s390/kvm/kvm-s390.c            | 111 ++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h            |   4 ++
 arch/s390/kvm/sigp.c                |   2 +
 arch/s390/mm/fault.c                |  26 +++++++--
 arch/x86/include/asm/kvm_host.h     |   8 +++
 arch/x86/kvm/mmu.c                  |   2 +-
 include/linux/kvm_host.h            |  10 +---
 include/uapi/linux/kvm.h            |   2 +
 virt/kvm/Kconfig                    |   4 ++
 virt/kvm/async_pf.c                 |  22 ++++++-
 23 files changed, 361 insertions(+), 25 deletions(-)

-- 
1.8.2.2

