Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaGNO6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:58:45 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61506 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaGNO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:58:35 -0400
Date: Mon, 14 Jul 2014 17:58:22 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, nadav.amit@gmail.com, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page in
 memory.
Message-ID: <20140714145822.GK4399@minantech.com>
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com>
 <20140712080442.GH4399@minantech.com>
 <53C38D55.2040307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C38D55.2040307@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Jan to check my nested kvm findings below.

On Mon, Jul 14, 2014 at 03:57:09PM +0800, Tang Chen wrote:
> Hi Gleb,
> 
> Thanks for the reply. Please see below.
> 
> On 07/12/2014 04:04 PM, Gleb Natapov wrote:
> >On Tue, Jul 08, 2014 at 09:01:32PM +0800, Tang Chen wrote:
> >>apic access page is pinned in memory. As a result, it cannot be migrated/hot-removed.
> >>Actually, it is not necessary to be pinned.
> >>
> >>The hpa of apic access page is stored in VMCS APIC_ACCESS_ADDR pointer. When
> >>the page is migrated, kvm_mmu_notifier_invalidate_page() will invalidate the
> >>corresponding ept entry. This patch introduces a new vcpu request named
> >>KVM_REQ_APIC_PAGE_RELOAD, and makes this request to all the vcpus at this time,
> >>and force all the vcpus exit guest, and re-enter guest till they updates the VMCS
> >>APIC_ACCESS_ADDR pointer to the new apic access page address, and updates
> >>kvm->arch.apic_access_page to the new page.
> >>
> >By default kvm Linux guest uses x2apic, so APIC_ACCESS_ADDR mechanism
> >is not used since no MMIO access to APIC is ever done. Have you tested
> >this with "-cpu modelname,-x2apic" qemu flag?
> 
> I used the following commandline to test the patches.
> 
> # /usr/libexec/qemu-kvm -m 512M -hda /home/tangchen/xxx.img -enable-kvm -smp
> 2
> 
That most likely uses x2apic.

> And I think the guest used APIC_ACCESS_ADDR mechanism because the previous
> patch-set has some problem which will happen when the apic page is accessed.
> And it did happen.
> 
> I'll test this patch-set with "-cpu modelname,-x2apic" flag.
> 
Replace "modelname" with one of supported model names such as nehalem of course :)

> >
> >>Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> >>---
> >>  arch/x86/include/asm/kvm_host.h |  1 +
> >>  arch/x86/kvm/mmu.c              | 11 +++++++++++
> >>  arch/x86/kvm/svm.c              |  6 ++++++
> >>  arch/x86/kvm/vmx.c              |  8 +++++++-
> >>  arch/x86/kvm/x86.c              | 14 ++++++++++++++
> >>  include/linux/kvm_host.h        |  2 ++
> >>  virt/kvm/kvm_main.c             | 12 ++++++++++++
> >>  7 files changed, 53 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>index 62f973e..9ce6bfd 100644
> >>--- a/arch/x86/include/asm/kvm_host.h
> >>+++ b/arch/x86/include/asm/kvm_host.h
> >>@@ -737,6 +737,7 @@ struct kvm_x86_ops {
> >>  	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
> >>  	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
> >>  	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
> >>+	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
> >>  	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
> >>  	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
> >>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
> >>diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >>index 9314678..551693d 100644
> >>--- a/arch/x86/kvm/mmu.c
> >>+++ b/arch/x86/kvm/mmu.c
> >>@@ -3427,6 +3427,17 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
> >>  			 level, gfn, pfn, prefault);
> >>  	spin_unlock(&vcpu->kvm->mmu_lock);
> >>
> >>+	/*
> >>+	 * apic access page could be migrated. When the guest tries to access
> >>+	 * the apic access page, ept violation will occur, and we can use GUP
> >>+	 * to find the new page.
> >>+	 *
> >>+	 * GUP will wait till the migrate entry be replaced with the new page.
> >>+	 */
> >>+	if (gpa == APIC_DEFAULT_PHYS_BASE)
> >>+		vcpu->kvm->arch.apic_access_page = gfn_to_page_no_pin(vcpu->kvm,
> >>+					APIC_DEFAULT_PHYS_BASE>>  PAGE_SHIFT);
> >Shouldn't you make KVM_REQ_APIC_PAGE_RELOAD request here?
> 
> I don't think we need to make KVM_REQ_APIC_PAGE_RELOAD request here.
> 
> In kvm_mmu_notifier_invalidate_page() I made the request. And the handler
> called
> gfn_to_page_no_pin() to get the new page, which will wait till the migration
> finished. And then updated the VMCS APIC_ACCESS_ADDR pointer. So, when the
> vcpus
> were forced to exit the guest mode, they would wait till the VMCS
> APIC_ACCESS_ADDR
> pointer was updated.
> 
> As a result, we don't need to make the request here.
OK, I do not see what's the purpose of the code here then.

> 
> 
> >
> >>+
> >>  	return r;
> >>
> >>  out_unlock:
> >>diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >>index 576b525..dc76f29 100644
> >>--- a/arch/x86/kvm/svm.c
> >>+++ b/arch/x86/kvm/svm.c
> >>@@ -3612,6 +3612,11 @@ static void svm_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
> >>  	return;
> >>  }
> >>
> >>+static void svm_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
> >>+{
> >>+	return;
> >>+}
> >>+
> >>  static int svm_vm_has_apicv(struct kvm *kvm)
> >>  {
> >>  	return 0;
> >>@@ -4365,6 +4370,7 @@ static struct kvm_x86_ops svm_x86_ops = {
> >>  	.enable_irq_window = enable_irq_window,
> >>  	.update_cr8_intercept = update_cr8_intercept,
> >>  	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
> >>+	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
> >>  	.vm_has_apicv = svm_vm_has_apicv,
> >>  	.load_eoi_exitmap = svm_load_eoi_exitmap,
> >>  	.hwapic_isr_update = svm_hwapic_isr_update,
> >>diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> >>index 5532ac8..f7c6313 100644
> >>--- a/arch/x86/kvm/vmx.c
> >>+++ b/arch/x86/kvm/vmx.c
> >>@@ -3992,7 +3992,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
> >>  	if (r)
> >>  		goto out;
> >>
> >>-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE>>  PAGE_SHIFT);
> >>+	page = gfn_to_page_no_pin(kvm, APIC_DEFAULT_PHYS_BASE>>  PAGE_SHIFT);
> >>  	if (is_error_page(page)) {
> >>  		r = -EFAULT;
> >>  		goto out;
> >>@@ -7073,6 +7073,11 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
> >>  	vmx_set_msr_bitmap(vcpu);
> >>  }
> >>
> >>+static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
> >>+{
> >>+	vmcs_write64(APIC_ACCESS_ADDR, hpa);
> >>+}
> >>+
> >>  static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
> >>  {
> >>  	u16 status;
> >>@@ -8842,6 +8847,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
> >>  	.enable_irq_window = enable_irq_window,
> >>  	.update_cr8_intercept = update_cr8_intercept,
> >>  	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
> >>+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
> >>  	.vm_has_apicv = vmx_vm_has_apicv,
> >>  	.load_eoi_exitmap = vmx_load_eoi_exitmap,
> >>  	.hwapic_irr_update = vmx_hwapic_irr_update,
> >>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>index ffbe557..7080eda 100644
> >>--- a/arch/x86/kvm/x86.c
> >>+++ b/arch/x86/kvm/x86.c
> >>@@ -5929,6 +5929,18 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
> >>  	kvm_apic_update_tmr(vcpu, tmr);
> >>  }
> >>
> >>+static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
> >>+{
> >>+	/*
> >>+	 * When the page is being migrated, GUP will wait till the migrate
> >>+	 * entry is replaced with the new pte entry pointing to the new page.
> >>+	 */
> >>+	struct page *page = gfn_to_page_no_pin(vcpu->kvm,
> >>+					APIC_DEFAULT_PHYS_BASE>>  PAGE_SHIFT);
> >If you do not use kvm->arch.apic_access_page to get current address why not drop it entirely?
> >
> 
> I should also update kvm->arch.apic_access_page here. It is used in other
> places
> in kvm, so I don't think we should drop it. Will update the patch.
What other places? The only other place I see is in nested kvm code and you can call
gfn_to_page_no_pin() there instead of using kvm->arch.apic_access_page directly. But
as far as I see nested kvm code cannot handle change of APIC_ACCESS_ADDR phys address.
If APIC_ACCESS_ADDR changes during nested guest run, non nested vmcs will still have old
physical address. One way to fix that is to set KVM_REQ_APIC_PAGE_RELOAD during nested exit.

--
			Gleb.
