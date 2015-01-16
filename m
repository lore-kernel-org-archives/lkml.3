Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbbAPFte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 00:49:34 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:57813 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbAPFtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 00:49:32 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Fri, 16 Jan 2015 13:49:10 +0800
Message-ID: <CACzj_yVRifkBrMt2q6Vjvr+anXr0n+9J_iERR+UnZVwz95jN5A@mail.gmail.com>
Subject: [PATCH 0/5] KVM: nVMX: Enable nested apicv support.
To: Paolo Bonzini <pbonzini@redhat.com>, gleb@kernel.org,
        yang.z.zhang@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        =?UTF-8?B?6IyD5paH5LiA?= <fanwenyi0529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In nested vmx, the efficiency of interrupt virtualization is
very important, especially in high throughput scenes.

This patch set enables nested apicv support, which makes a
huge improvement in nested interrupt virtualization.

I also have done some simple tests:
L0: Intel Xeon E5-2630 v2
L1: CentOS 6.5 with 3.10.64-1.el6.elrepo.x86_64 kernel
    16 vcpus, 32GB memory.

L2: Windows Server 2008 R2 Datacenter
    8 vcpus, 16GB memory.

 1. Run wprime 32M, 8 threads.

         original                nested apicv

          7.782s                   7.172s

    Improvement: 7.8%

 2. Run iperf -s -w 64k in L1,
    iperf -c 10.1.0.2 -p 5001 -i 1 -t 30 -P 8 -w 64k in L2

         original                nested apicv

        2.12 Gbits/s             3.50 Gbits/s

    Improvement: 65.0%

_________________________________________________________

L2: CentOS 6.5 with 2.6.32-431 kernel
    8 vcpus, 16GB memory.

 1. Run iperf -s -w 64k in L1,
    iperf -c 10.1.0.2 -p 5001 -i 1 -t 30 -P 8 -w 64k in L2

         original                nested apicv

        6.58 Gbits/s             14.2 Gbits/s

    Improvement: 115.8%

Wincy Van (5):
  KVM: nVMX: Make nested control MSRs per-cpu.
  KVM: nVMX: Enable nested virtualize x2apic mode.
  KVM: nVMX: Enable nested apic register virtualization.
  KVM: nVMX: Enable nested virtual interrupt delivery.
  KVM: nVMX: Enable nested posted interrupt processing.

 arch/x86/kvm/vmx.c |  444 +++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 355 insertions(+), 89 deletions(-)
