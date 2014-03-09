Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaCIUMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 16:12:16 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63561 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaCIUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 16:12:15 -0400
Message-ID: <531CCB15.6070402@redhat.com>
Date: Sun, 09 Mar 2014 21:12:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, mtosatti@redhat.com, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 4/7] KVM: vmx: Allow the guest to run with dirty debug
 registers
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com> <1394192571-11056-5-git-send-email-pbonzini@redhat.com> <20140309182639.GA10479@potion.redhat.com>
In-Reply-To: <20140309182639.GA10479@potion.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/03/2014 19:26, Radim Krčmář ha scritto:
> > +
> > +		cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
> > +		cpu_based_vm_exec_control &= ~CPU_BASED_MOV_DR_EXITING;
> > +		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
>
> vmcs_clear_bits() covers exactly this use-case.
> (Barring the explicit bit-width.)

Good idea.

> > +
> > +		/*
> > +		 * No more DR vmexits; force a reload of the debug registers
> > +		 * and reenter on this instruction.  The next vmexit will
> > +		 * retrieve the full state of the debug registers.
> > +		 */
> > +		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
> > +		return 1;
> > +	}
> > +
>
> We could make the code slighly uglier and move the functional part of
> this block before the previous one, so it would do both things in one
> exit.

I considered this, but decided that it's unlikely for emulation to be 
faster than hardware---especially on those AMD CPUs that lack decode 
assists (and it's good for VMX and SVM code to look as similar as possible).

> (Exception handler will likely access DR too.)

Which exception handler?

Paolo
