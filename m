Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbaDHRYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:24:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:40356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaDHRYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:24:47 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@Citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org, keir@xen.org,
        jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when migrating.
Date: Tue,  8 Apr 2014 13:25:49 -0400
Message-Id: <1396977950-8789-2-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1396977950-8789-1-git-send-email-konrad@kernel.org>
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

When we migrate an HVM guest, by default our shared_info can
only hold up to 32 CPUs. As such the hypercall
VCPUOP_register_vcpu_info was introduced which allowed us to
setup per-page areas for VCPUs. This means we can boot PVHVM
guest with more than 32 VCPUs. During migration the per-cpu
structure is allocated fresh by the hypervisor (vcpu_info_mfn
is set to INVALID_MFN) so that the newly migrated guest
can do make the VCPUOP_register_vcpu_info hypercall.

Unfortunatly we end up triggering this condition:
/* Run this command on yourself or on other offline VCPUS. */
 if ( (v != current) && !test_bit(_VPF_down, &v->pause_flags) )

which means we are unable to setup the per-cpu VCPU structures
for running vCPUS. The Linux PV code paths make this work by
iterating over every vCPU with:

 1) is target CPU up (VCPUOP_is_up hypercall?)
 2) if yes, then VCPUOP_down to pause it.
 3) VCPUOP_register_vcpu_info
 4) if it was down, then VCPUOP_up to bring it back up

But since VCPUOP_down, VCPUOP_is_up, and VCPUOP_up are
not allowed on HVM guests we can't do this. This patch
enables this.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 xen/arch/x86/hvm/hvm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/xen/arch/x86/hvm/hvm.c b/xen/arch/x86/hvm/hvm.c
index 38c491e..b5b92fe 100644
--- a/xen/arch/x86/hvm/hvm.c
+++ b/xen/arch/x86/hvm/hvm.c
@@ -3470,6 +3470,9 @@ static long hvm_vcpu_op(
     case VCPUOP_stop_singleshot_timer:
     case VCPUOP_register_vcpu_info:
     case VCPUOP_register_vcpu_time_memory_area:
+    case VCPUOP_down:
+    case VCPUOP_up:
+    case VCPUOP_is_up:
         rc = do_vcpu_op(cmd, vcpuid, arg);
         break;
     default:
-- 
1.7.7.6

