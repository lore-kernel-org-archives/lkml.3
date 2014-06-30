Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaF3PCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:02:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33088 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaF3PB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:01:59 -0400
Message-ID: <53B17BDD.5030301@redhat.com>
Date: Mon, 30 Jun 2014 17:01:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Gleb Natapov <gleb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org,
        =?ISO-8859-1?Q?J=F6rg_R=F6?= =?ISO-8859-1?Q?del?= 
	<joro@8bytes.org>
Subject: Re: [PATCH] KVM: SVM: Fix CPL export via SS.DPL
References: <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com> <53AFF192.7020801@web.de> <20140629115143.GA4362@pd.tnic> <53B0050B.90104@web.de> <20140629131443.GA5199@pd.tnic> <20140629134247.GG18167@minantech.com> <20140629140104.GB12528@pd.tnic> <20140629142722.GH18167@minantech.com> <53B02395.8030505@web.de> <53B027E0.7040003@web.de> <53B02CEB.7010607@web.de>
In-Reply-To: <53B02CEB.7010607@web.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/06/2014 17:12, Jan Kiszka ha scritto:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> We import the CPL via SS.DPL since ae9fedc793. However, we fail to
> export it this way so far. This caused spurious guest crashes, e.g. of
> Linux when accessing the vmport from guest user space which triggered
> register saving/restoring to/from host user space.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>
> Just in time for the next match :D
>
>  arch/x86/kvm/svm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ec8366c..b5e994a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1462,6 +1462,7 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
>  		 */
>  		if (var->unusable)
>  			var->db = 0;
> +		var->dpl = to_svm(vcpu)->vmcb->save.cpl;
>  		break;
>  	}
>  }
>

Thanks.  In theory this is not necessary, the SS.DPL should be the same 
as the CPL according to the manuals (the manual say that the SS.DPL 
"should match" the CPL, and that's the only reason why I included the 
import in ae9fedc793).  But apparently this is not the case.

Paolo
