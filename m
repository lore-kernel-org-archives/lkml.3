Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaKBGuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 01:50:37 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62864 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaKBGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 01:50:35 -0500
Message-ID: <5455D435.5050405@redhat.com>
Date: Sun, 02 Nov 2014 07:50:29 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wanpeng Li <kernellwp@gmail.com>, "Chen, Tiejun" <tiejun.chen@intel.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix access memslots w/o hold srcu read lock
References: <1414730012-7278-1-git-send-email-wanpeng.li@linux.intel.com> <54531E7B.1040006@intel.com> <5453663B.90500@redhat.com> <54544A45.1000505@gmail.com>
In-Reply-To: <54544A45.1000505@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/2014 03:49, Wanpeng Li wrote:
> 
> This is also not enough. I see the warning in the below path during the
> test:
> 
> kvm_arch_vcpu_ioctl_run
> -> kvm_apic_accept_events
> -> kvm_vcpu_reset

Hmm, better bypass the problem altogether:

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a0f78dbaabee..3e556c68351b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4579,7 +4579,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write32(TPR_THRESHOLD, 0);
 	}
 
-	kvm_vcpu_reload_apic_access_page(vcpu);
+	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	if (vmx_vm_has_apicv(vcpu->kvm))
 		memset(&vmx->pi_desc, 0, sizeof(struct pi_desc));

(untested)

Paolo
