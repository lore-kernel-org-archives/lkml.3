Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3JRARN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:17:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3JRARM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:17:12 -0400
Date: Thu, 17 Oct 2013 21:04:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, agraf@suse.de,
        chao.zhou@intel.com, magnus@boden.cx, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: fix KVM_SET_XCRS loop
Message-ID: <20131018000421.GA6793@amt.cnet>
References: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
 <1382021447-20216-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382021447-20216-3-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 04:50:47PM +0200, Paolo Bonzini wrote:
> The loop was always using 0 as the index.  This means that
> any rubbish after the first element of the array went undetected.
> It seems reasonable to assume that no KVM userspace did that.

It is not a typo, look at __kvm_set_xcr when setting
guest_xcrs->xcrs[i].value, with i != 0.

The code is not prepared to deal with XCR != 0 (because its not
implemented in hw).

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f4e1391..f91dff2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3062,9 +3062,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>  
>  	for (i = 0; i < guest_xcrs->nr_xcrs; i++)
>  		/* Only support XCR0 currently */
> -		if (guest_xcrs->xcrs[0].xcr == XCR_XFEATURE_ENABLED_MASK) {
> +		if (guest_xcrs->xcrs[i].xcr == XCR_XFEATURE_ENABLED_MASK) {
>  			r = __kvm_set_xcr(vcpu, XCR_XFEATURE_ENABLED_MASK,
> -				guest_xcrs->xcrs[0].value);
> +				guest_xcrs->xcrs[i].value);
>  			break;
>  		}
>  	if (r)
> -- 
> 1.8.3.1
