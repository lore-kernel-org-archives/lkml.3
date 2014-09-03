Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaICPFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:05:03 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33266 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaICPFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:05:00 -0400
Date: Wed, 3 Sep 2014 18:04:49 +0300
From: Gleb Natapov <gleb@kernel.org>
To: tangchen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, nadav.amit@gmail.com, jan.kiszka@web.de,
        kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/6] kvm, mem-hotplug: Reload L1' apic access page on
 migration in vcpu_enter_guest().
Message-ID: <20140903150448.GJ18167@minantech.com>
References: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
 <1409134661-27916-5-git-send-email-tangchen@cn.fujitsu.com>
 <20140902160005.GA26540@minantech.com>
 <54067206.7050303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54067206.7050303@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:42:30AM +0800, tangchen wrote:
> Hi Gleb,
> 
> On 09/03/2014 12:00 AM, Gleb Natapov wrote:
> >......
> >+static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
> >+{
> >+	/*
> >+	 * apic access page could be migrated. When the page is being migrated,
> >+	 * GUP will wait till the migrate entry is replaced with the new pte
> >+	 * entry pointing to the new page.
> >+	 */
> >+	vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
> >+				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> >+	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
> >+				page_to_phys(vcpu->kvm->arch.apic_access_page));
> >I am a little bit worried that here all vcpus write to vcpu->kvm->arch.apic_access_page
> >without any locking. It is probably benign since pointer write is atomic on x86. Paolo?
> >
> >Do we even need apic_access_page? Why not call
> >  gfn_to_page(APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT)
> >  put_page()
> >on rare occasions we need to know its address?
> 
> Isn't it a necessary item defined in hardware spec ?
> 
vcpu->kvm->arch.apic_access_page? No. This is internal kvm data structure.

> I didn't read intel spec deeply, but according to the code, the page's
> address is
> written into vmcs. And it made me think that we cannnot remove it.
> 
We cannot remove writing of apic page address into vmcs, but this is not done by
assigning to vcpu->kvm->arch.apic_access_page, but by vmwrite in set_apic_access_page_addr().

--
			Gleb.
