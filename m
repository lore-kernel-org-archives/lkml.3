Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3CDSF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:05:58 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:38216 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab3CDSFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:05:54 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Date: Mon, 04 Mar 2013 23:32:27 +0530
Message-Id: <20130304180227.31281.96284.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
References: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC 2/2] kvm: Iterate over only vcpus that are preempted
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030418-3864-0000-0000-000007157B3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

This helps in filtering out the eligible candidates further and 
thus potentially helps in quickly allowing preempted lockholders to run.
Note that if a vcpu was spinning during preemption we filter them
by checking whether they are preempted due to pause loop exit.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 83a804c..60114e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1790,6 +1790,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				continue;
 			} else if (pass && i > last_boosted_vcpu)
 				break;
+			if (!ACCESS_ONCE(vcpu->preempted))
+				continue;
 			if (vcpu == me)
 				continue;
 			if (waitqueue_active(&vcpu->wq))

