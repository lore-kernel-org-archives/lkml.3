Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab3EGOG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:06:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32772 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab3EGOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:06:27 -0400
Date: Tue, 7 May 2013 10:06:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 2/4] xen/vcpu: Document the xen_vcpu_info and
 xen_vcpu
Message-ID: <20130507140616.GC414@phenom.dumpdata.com>
References: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com>
 <1367845498-14290-3-git-send-email-konrad.wilk@oracle.com>
 <1367919047.26321.47.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367919047.26321.47.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 10:30:47AM +0100, Ian Campbell wrote:
> On Mon, 2013-05-06 at 14:04 +0100, Konrad Rzeszutek Wilk wrote:
> > They are important structures and it is not clear at first
> > look what they are for.
> > 
> > The xen_vcpu is a pointer. By default it points to the shared_info
> > structure (at the CPU offset location). However if the
> > VCPUOP_register_vcpu_info hypercall is implemented we can make the
> > xen_vcpu pointer point to a per-CPU location.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/enlighten.c | 21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 94a81f4..9b34475 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -85,7 +85,21 @@
> >  
> >  EXPORT_SYMBOL_GPL(hypercall_page);
> >  
> > +/*
> > + * Pointer to the xen_vcpu_info structure or
> > + * &HYPERVISOR_shared_info->vcpu_info[cpu]. See xen_hvm_init_shared_info
> > + * and xen_vcpu_setup for details. By default it points to share_info->vcpu_info
> > + * but if the hypervisor supports VCPUOP_register_vcpu_info then it can point
> > + * to xen_vcpu_info. The pointer is used in __xen_evtchn_do_upcall to
> > + * acknowledge pending events.
> 
> Also more subtly it is used by the patched version of irq enable/disable
> e.g. xen_irq_enable_direct and xen_iret.
> 
> The desire to be able to do those mask/unmask operations as a single
> instruction by using the per-cpu offset held in %gs is the real reason
> vcpu info is in a per-cpu pointer and for the whole register_vcpu_info
> thing IIRC.

>From a520996ae2e2792e1f90b74e67c974120c8a3b83 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sun, 5 May 2013 08:51:47 -0400
Subject: [PATCH] xen/vcpu: Document the xen_vcpu_info and xen_vcpu

They are important structures and it is not clear at first
look what they are for.

The xen_vcpu is a pointer. By default it points to the shared_info
structure (at the CPU offset location). However if the
VCPUOP_register_vcpu_info hypercall is implemented we can make the
xen_vcpu pointer point to a per-CPU location.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
[v1: Added comments from Ian Campbell]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 94a81f4..a2babdb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -85,7 +85,29 @@
 
 EXPORT_SYMBOL_GPL(hypercall_page);
 
+/*
+ * Pointer to the xen_vcpu_info structure or
+ * &HYPERVISOR_shared_info->vcpu_info[cpu]. See xen_hvm_init_shared_info
+ * and xen_vcpu_setup for details. By default it points to share_info->vcpu_info
+ * but if the hypervisor supports VCPUOP_register_vcpu_info then it can point
+ * to xen_vcpu_info. The pointer is used in __xen_evtchn_do_upcall to
+ * acknowledge pending events.
+ * Also more subtly it is used by the patched version of irq enable/disable
+ * e.g. xen_irq_enable_direct and xen_iret in PV mode.
+ *
+ * The desire to be able to do those mask/unmask operations as a single
+ * instruction by using the per-cpu offset held in %gs is the real reason
+ * vcpu info is in a per-cpu pointer and the original reason for this
+ * hypercall.
+ *
+ */
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
+
+/*
+ * Per CPU pages used if hypervisor supports VCPUOP_register_vcpu_info
+ * hypercall. This can be used both in PV and PVHVM mode. The structure
+ * overrides the default per_cpu(xen_vcpu, cpu) value.
+ */
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 
 enum xen_domain_type xen_domain_type = XEN_NATIVE;
@@ -187,7 +209,12 @@ static void xen_vcpu_setup(int cpu)
 
 	/* Check to see if the hypervisor will put the vcpu_info
 	   structure where we want it, which allows direct access via
-	   a percpu-variable. */
+	   a percpu-variable.
+	   N.B. This hypercall can _only_ be called once per CPU. Subsequent
+	   calls will error out with -EINVAL. This is due to the fact that
+	   hypervisor has no unregister variant and this hypercall does not
+	   allow to over-write info.mfn and info.offset.
+	 */
 	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, cpu, &info);
 
 	if (err) {
-- 
1.8.1.4

