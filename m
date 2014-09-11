Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaIKW5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:57:15 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34513 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaIKW4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:56:55 -0400
Date: Thu, 11 Sep 2014 15:56:54 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org,
        jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com,
        marc.zyngier@arm.com, bp@suse.de, pbonzini@redhat.com,
        Gleb Natapov <gleb@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: document KVM_SET_GUEST_DEBUG api
Message-ID: <20140911225654.GT5535@lvm>
References: <1410280039-2823-1-git-send-email-alex.bennee@linaro.org>
 <1410280039-2823-2-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410280039-2823-2-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:27:18PM +0100, Alex Bennée wrote:
> In preparation for working on the ARM implementation I noticed the debug
> interface was missing from the API document. I've pieced together the
> expected behaviour from the code and commit messages written it up as
> best I can.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index d3dde61..723d3f3 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2575,6 +2575,50 @@ associated with the service will be forgotten, and subsequent RTAS
>  calls by the guest for that service will be passed to userspace to be
>  handled.
>  
> +4.87 KVM_SET_GUEST_DEBUG
> +
> +Capability: KVM_CAP_SET_GUEST_DEBUG
> +Architectures: x86, s390, ppc
> +Type: vcpu ioctl
> +Parameters: struct kvm_guest_debug (in)
> +Returns: 0 on success; -1 on error

Any specific error codes that need explaining here?

> +
> +struct kvm_guest_debug {
> +       __u32 control;
> +       __u32 pad;
> +       struct kvm_guest_debug_arch arch;
> +};
> +
> +Set up the processor specific debug registers and configure vcpu for

configure *the* vcpu?

> +handling guest debug events. There are two parts to the structure, the

handling guest debug events> does this mean whatever user space needs to
configure so that the guest can deug things or is this for userspace to
debug the guest execution, we could probably be more specific.

> +first a control bitfield indicates the type of debug events to handle
> +when running. Common control bits are:

'when running'? 'when running the vcpu'?

> +
> +  - KVM_GUESTDBG_ENABLE:        guest debugging is enabled
> +  - KVM_GUESTDBG_SINGLESTEP:    the next run should single-step
> +
> +The top 16 bits of the control field are architecture specific control
> +flags which can include the following:
> +
> +  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86]
> +  - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s390]
> +  - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
> +  - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
> +  - KVM_GUESTDBG_EXIT_PENDING:  trigger an immediate guest exit [s390]
> +
> +For example KVM_GUESTDBG_USE_SW_BP indicates that software breakpoints
> +are enabled in memory so we need to ensure breakpoint exceptions are
> +correctly trapped and the KVM run loop exits at the breakpoint and not
> +running off into the normal guest vector. For KVM_GUESTDBG_USE_HW_BP

I didn't quite understand this bit, can you clarify slightly?  For
example, I don't know what it means that a software breakpoint is
'enabled in memory' and I'm not quite sure what the goal you are arguing
for here is; is this about if this ioctl is used to set a specific
breakpoint then we want to make sure that the breakpoint exception goes
to KVM and not to the guest?

also, are you not missing a 'that' before 'the KVM run loop...'

> +we need to ensure the guest vCPUs architecture specific registers are

please be consistent about the use of vcpu, VCPUs, vCPUs, etc.  The
document seems to prefer lowercase vcpus most places.

> +updated to the correct (supplied) values.
> +
> +The second part of the structure is architecture specific and
> +typically contains a set of debug registers.
> +
> +When debug events exit the main run loop with the reason

I think you should just talk about then the VCPU exits the guest and not
be specific about whether we have a main run loop or not.

> +KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
> +structure containing architecture specific debug information.

I feel like this sentence leaves me hanging; When they exit with the
debug information, then what?  Or did you mean to say that when they
exit, then the arch struct is filled with the debug info?

>  
>  5. The kvm_run structure
>  ------------------------
> -- 
> 2.1.0
> 

Thanks for taking care of this!
-Christoffer
