Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaDVSfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:35:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21077 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaDVSfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:35:03 -0400
Date: Tue, 22 Apr 2014 14:34:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@Citrix.com, konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when migrating.
Message-ID: <20140422183443.GA6817@phenom.dumpdata.com>
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
 <1396977950-8789-2-git-send-email-konrad@kernel.org>
 <534529A40200007800007055@nat28.tlf.novell.com>
 <20140409152706.GF5860@phenom.dumpdata.com>
 <5345853502000078000074F8@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5345853502000078000074F8@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 04:36:53PM +0100, Jan Beulich wrote:
> >>> On 09.04.14 at 17:27, <konrad.wilk@oracle.com> wrote:
> > On Wed, Apr 09, 2014 at 10:06:12AM +0100, Jan Beulich wrote:
> >> >>> On 08.04.14 at 19:25, <konrad@kernel.org> wrote:
> >> > --- a/xen/arch/x86/hvm/hvm.c
> >> > +++ b/xen/arch/x86/hvm/hvm.c
> >> > @@ -3470,6 +3470,9 @@ static long hvm_vcpu_op(
> >> >      case VCPUOP_stop_singleshot_timer:
> >> >      case VCPUOP_register_vcpu_info:
> >> >      case VCPUOP_register_vcpu_time_memory_area:
> >> > +    case VCPUOP_down:
> >> > +    case VCPUOP_up:
> >> > +    case VCPUOP_is_up:
> >> 
> >> This, if I checked it properly, leaves only VCPUOP_initialise,
> >> VCPUOP_send_nmi, and VCPUOP_get_physid disallowed for HVM.
> >> None of which look inherently bad to be used by HVM (but
> >> VCPUOP_initialise certainly would need closer checking), so I
> >> wonder whether either the wrapper shouldn't be dropped altogether
> >> or at least be converted from a white list approach to a black list one.
> > 
> > I was being conservative here because I did not want to allow the
> > other ones without at least testing it.
> > 
> > Perhaps that can be done as a seperate patch and this just as
> > a bug-fix?
> 
> I'm clearly not in favor of the patch as is - minimally I'd want it to
> convert the white list to a black list. And once you do this it would
> seem rather natural to not pointlessly add entries.

With this patch:

diff --git a/xen/arch/x86/hvm/hvm.c b/xen/arch/x86/hvm/hvm.c
index b5b92fe..5eee790 100644
--- a/xen/arch/x86/hvm/hvm.c
+++ b/xen/arch/x86/hvm/hvm.c
@@ -3455,34 +3455,6 @@ static long hvm_physdev_op(int cmd, XEN_GUEST_HANDLE_PARAM(void) arg)
     }
 }
 
-static long hvm_vcpu_op(
-    int cmd, int vcpuid, XEN_GUEST_HANDLE_PARAM(void) arg)
-{
-    long rc;
-
-    switch ( cmd )
-    {
-    case VCPUOP_register_runstate_memory_area:
-    case VCPUOP_get_runstate_info:
-    case VCPUOP_set_periodic_timer:
-    case VCPUOP_stop_periodic_timer:
-    case VCPUOP_set_singleshot_timer:
-    case VCPUOP_stop_singleshot_timer:
-    case VCPUOP_register_vcpu_info:
-    case VCPUOP_register_vcpu_time_memory_area:
-    case VCPUOP_down:
-    case VCPUOP_up:
-    case VCPUOP_is_up:
-        rc = do_vcpu_op(cmd, vcpuid, arg);
-        break;
-    default:
-        rc = -ENOSYS;
-        break;
-    }
-
-    return rc;
-}
-
 typedef unsigned long hvm_hypercall_t(
     unsigned long, unsigned long, unsigned long, unsigned long, unsigned long,
     unsigned long);
@@ -3517,30 +3489,6 @@ static long hvm_memory_op_compat32(int cmd, XEN_GUEST_HANDLE_PARAM(void) arg)
     return compat_memory_op(cmd, arg);
 }
 
-static long hvm_vcpu_op_compat32(
-    int cmd, int vcpuid, XEN_GUEST_HANDLE_PARAM(void) arg)
-{
-    long rc;
-
-    switch ( cmd )
-    {
-    case VCPUOP_register_runstate_memory_area:
-    case VCPUOP_get_runstate_info:
-    case VCPUOP_set_periodic_timer:
-    case VCPUOP_stop_periodic_timer:
-    case VCPUOP_set_singleshot_timer:
-    case VCPUOP_stop_singleshot_timer:
-    case VCPUOP_register_vcpu_info:
-    case VCPUOP_register_vcpu_time_memory_area:
-        rc = compat_vcpu_op(cmd, vcpuid, arg);
-        break;
-    default:
-        rc = -ENOSYS;
-        break;
-    }
-
-    return rc;
-}
 
 static long hvm_physdev_op_compat32(
     int cmd, XEN_GUEST_HANDLE_PARAM(void) arg)
@@ -3563,7 +3511,7 @@ static long hvm_physdev_op_compat32(
 static hvm_hypercall_t *const hvm_hypercall64_table[NR_hypercalls] = {
     [ __HYPERVISOR_memory_op ] = (hvm_hypercall_t *)hvm_memory_op,
     [ __HYPERVISOR_grant_table_op ] = (hvm_hypercall_t *)hvm_grant_table_op,
-    [ __HYPERVISOR_vcpu_op ] = (hvm_hypercall_t *)hvm_vcpu_op,
+    HYPERCALL(vcpu_op),
     [ __HYPERVISOR_physdev_op ] = (hvm_hypercall_t *)hvm_physdev_op,
     HYPERCALL(xen_version),
     HYPERCALL(console_io),
@@ -3583,7 +3531,7 @@ static hvm_hypercall_t *const hvm_hypercall64_table[NR_hypercalls] = {
 static hvm_hypercall_t *const hvm_hypercall32_table[NR_hypercalls] = {
     [ __HYPERVISOR_memory_op ] = (hvm_hypercall_t *)hvm_memory_op_compat32,
     [ __HYPERVISOR_grant_table_op ] = (hvm_hypercall_t *)hvm_grant_table_op_compat32,
-    [ __HYPERVISOR_vcpu_op ] = (hvm_hypercall_t *)hvm_vcpu_op_compat32,
+    COMPAT_CALL(vcpu_op),
     [ __HYPERVISOR_physdev_op ] = (hvm_hypercall_t *)hvm_physdev_op_compat32,
     COMPAT_CALL(xen_version),
     HYPERCALL(console_io),


And with an HVM guest poking at the rest of VCPUOPs: VCPUOP_get_physid, 
VCPUOP_initialise, and VCPUOP_send_nmi - either before the CPU is up or
when it is up - work.

That is: the VCPUOP_get_physid would return -EINVAL; VCPUOP_initialise
would return either -EEXIST or 0, and in either case
the content of the ctxt was full of zeros.

The VCPUOP_send_nmi did cause the HVM to get an NMI and it spitted out
'Dazed and confused'. It also noticed corruption:

[    3.611742] Corrupted low memory at c000fffc (fffc phys) = 00029b00
[    2.386785] Corrupted low memory at ffff88000000fff8 (fff8 phys) = 2990000000000

Which is odd because there does not seem to be anything in the path
of hypervisor that would cause this.

> 
> Jan
> 
