Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaA0SLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:11:42 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:59818 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaA0SLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:11:40 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        mtosatti@redhat.com
Subject: [PATCH 0/2] x86, kvm: fix detection of KVM features when KVM and Hyper-V coexist
Date: Mon, 27 Jan 2014 19:11:28 +0100
Message-Id: <1390846290-26844-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When KVM also presents Hyper-V features (which is useful because Windows
behaves better), Linux guests prefer KVM because emulated leaves are at
0x40000000 and the native ones are at 0x40000100.

However, Linux is then not accounting for the offset when reading the
available hypervisor features from CPUID.  Instead of looking at
0x40000101, it will always look at 0x40000001.

This series makes sure that features such as async page faults or steal
time are available even if, for whatever reason, Hyper-V features are
enabled.

As a side effect, patch 1 makes a bunch of code non inline, which also
makes sense since it should only be called during initialization.  As 
a result, vmlinux .text size decreases by 96 bytes.

Please review!

Paolo Bonzini (2):
  x86, kvm: cache the base of the KVM cpuid leaves
  x86, kvm: correctly access the KVM_CPUID_FEATURES leaf at 0x40000101

 arch/x86/include/asm/kvm_para.h | 33 ++++++++++++---------------------
 arch/x86/kernel/kvm.c           | 31 +++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 21 deletions(-)

-- 
1.8.3.1

