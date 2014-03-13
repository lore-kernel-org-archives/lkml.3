Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaCMNwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:52:13 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61968 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaCMNwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:52:11 -0400
Date: Thu, 13 Mar 2014 15:52:06 +0200
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix cr8 intercept window
Message-ID: <20140313135206.GB30596@minantech.com>
References: <1394561478-8815-1-git-send-email-rkrcmar@redhat.com>
 <20140312010513.GA8131@amt.cnet>
 <20140312104047.GA7488@potion.brq.redhat.com>
 <53209741.3060204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53209741.3060204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 06:20:01PM +0100, Paolo Bonzini wrote:
> Il 12/03/2014 11:40, Radim Krčmář ha scritto:
> >2014-03-11 22:05-0300, Marcelo Tosatti:
> >>On Tue, Mar 11, 2014 at 07:11:18PM +0100, Radim Krčmář wrote:
> >>>We always disable cr8 intercept in its handler, but only re-enable it
> >>>if handling KVM_REQ_EVENT, so there can be a window where we do not
> >>>intercept cr8 writes, which allows an interrupt to disrupt a higher
> >>>priority task.
> >>>
> >>>Fix this by disabling intercepts in the same function that re-enables
> >>>them when needed. This fixes BSOD in Windows 2008.
> >>>
> >>>Cc: <stable@vger.kernel.org>
> >>>Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> >>>---
> >>> arch/x86/kvm/svm.c | 6 +++---
> >>> 1 file changed, 3 insertions(+), 3 deletions(-)
> >>>
> >>>diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >>>index 64d9bb9..f676c18 100644
> >>>--- a/arch/x86/kvm/svm.c
> >>>+++ b/arch/x86/kvm/svm.c
> >>>@@ -3003,10 +3003,8 @@ static int cr8_write_interception(struct vcpu_svm *svm)
> >>> 	u8 cr8_prev = kvm_get_cr8(&svm->vcpu);
> >>> 	/* instruction emulation calls kvm_set_cr8() */
> >>> 	r = cr_interception(svm);
> >>>-	if (irqchip_in_kernel(svm->vcpu.kvm)) {
> >>>-		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
> >>>+	if (irqchip_in_kernel(svm->vcpu.kvm))
> >>> 		return r;
> >>>-	}
> 
> I think that the old code here makes little sense, and for two reasons:
> 
I agree that old code is wrong and the patch looks correct, but I only
see how the bug may cause pending IRR to not be delivered in time,
not how interrupt can disrupt a higher priority task.

--
			Gleb.
