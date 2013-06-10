Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3FJMD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:03:59 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:47395 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3FJMD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:03:56 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/4] Enable async page faults on s390 
Date: Mon, 10 Jun 2013 14:03:44 +0200
Message-Id: <1370865828-2053-1-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061012-4966-0000-0000-000005F9C57D
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

Dominik Dingel (4):
  PF: Add FAULT_FLAG_RETRY_NOWAIT for guest fault
  PF: Move architecture specifics to the backends
  PF: Additional flag for direct page fault inject
  PF: Intial async page fault support on s390x

 arch/s390/include/asm/kvm_host.h  |  34 +++++++++++++
 arch/s390/include/asm/processor.h |   7 +++
 arch/s390/include/uapi/asm/kvm.h  |  10 ++++
 arch/s390/kvm/Kconfig             |   1 +
 arch/s390/kvm/Makefile            |   2 +-
 arch/s390/kvm/diag.c              |  46 +++++++++++++++++
 arch/s390/kvm/interrupt.c         |  40 ++++++++++++---
 arch/s390/kvm/kvm-s390.c          | 101 ++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h          |   4 ++
 arch/s390/mm/fault.c              |  29 +++++++++--
 arch/s390/mm/pgtable.c            |   1 +
 arch/x86/include/asm/kvm_host.h   |   8 +++
 arch/x86/kvm/mmu.c                |   2 +-
 include/linux/kvm_host.h          |  11 +----
 include/uapi/linux/kvm.h          |   2 +
 virt/kvm/async_pf.c               |  33 ++++++++++---
 16 files changed, 303 insertions(+), 28 deletions(-)

-- 
1.8.1.6

