Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaBRJSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:18:34 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34811 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaBRJSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:18:31 -0500
Message-ID: <5303255D.8000501@redhat.com>
Date: Tue, 18 Feb 2014 10:18:21 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, joro@8bytes.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix NMI window after iret
References: <1389988362-15260-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1389988362-15260-1-git-send-email-rkrcmar@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/01/2014 20:52, Radim Krčmář ha scritto:
> We should open NMI window right after an iret, but SVM exits before it.
> We wanted to single step using the trap flag and then open it.
> (or we could emulate the iret instead)
> We don't do it since commit 3842d135ff2 (likely), because the iret exit
> handler does not request an event, so NMI window remains closed until
> the next exit.
>
> Fix this by making KVM_REQ_EVENT request in the iret handler.
>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  (btw. kvm-unit-tests weren't executed on SVM since Nov 2010, at least)
>
>  arch/x86/kvm/svm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c7168a5..b5a735b 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2829,6 +2829,7 @@ static int iret_interception(struct vcpu_svm *svm)
>  	clr_intercept(svm, INTERCEPT_IRET);
>  	svm->vcpu.arch.hflags |= HF_IRET_MASK;
>  	svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
> +	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>  	return 1;
>  }
>
>

Applying to kvm/queue, thanks.

Paolo
