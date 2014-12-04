Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaLDO21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:28:27 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34041 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaLDO20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:28:26 -0500
Message-ID: <54806F82.5090806@redhat.com>
Date: Thu, 04 Dec 2014 15:28:18 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Nadav Amit <nadav.amit@gmail.com>, rkrcmar@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] kvm: vmx: fix VMfailValid when write vmcs02/vmcs01
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com> <1417691470-5221-4-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1417691470-5221-4-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/2014 12:11, Wanpeng Li wrote:
> SDM 30.3 VMWRITE
> 
> ELSIF secondary source operand does not correspond to any VMCS field
>    THEN VMfailValid(VMREAD/VMWRITE from/to unsupported VMCS component);
> 
> We can't suppose L1 VMM expose MPX to L2 just if L0 support MPX. There
> will be VMfailValid if L0 doesn't support MPX and L1 expose MPX to L2
> when L0 writes vmcs02/vmcs01, in addition, there is no need to read
> GUEST_BNDCFGS if L1 VMM doesn't expose it to L2. This patch fix it by
> both check L0 support xsaves and L1 expose MPX to L2.

Did you have a reproducer for this?  It should not be needed, because
the bndcfgs entry/exit controls are hidden from
nested_vmx_exit_ctls_high and nested_vmx_entry_ctls_high if
!vmx_mpx_supported().

This hunk is also not correct:

> -	if (vmx_mpx_supported())
> +	if (vmx_mpx_supported() &&
> +		(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
>  	if (nested_cpu_has_xsaves(vmcs12))
>  		vmcs12->xss_exit_bitmap = vmcs_read64(XSS_EXIT_BITMAP);

because there is no "save BNDCFGS" exit control; the guest BNDCFGS is
saved unconditionally into the vmcs.

Paolo
