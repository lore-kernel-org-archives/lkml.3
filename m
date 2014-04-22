Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaDVUPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:15:50 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53839 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbaDVUPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:34 -0400
Message-ID: <5356CDDF.5000203@de.ibm.com>
Date: Tue, 22 Apr 2014 22:15:27 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: Dominik Dingel <dingel@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async_pf: kill the unnecessary use_mm/unuse_mm
 async_pf_execute()
References: <20140421132558.GA13608@redhat.com>
In-Reply-To: <20140421132558.GA13608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042220-4966-0000-0000-00000925F455
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/14 15:25, Oleg Nesterov wrote:
> async_pf_execute() has no reasons to adopt apf->mm, gup(current, mm)
> should work just fine even if current has another or NULL ->mm.
> 
> Recently kvm_async_page_present_sync() was added insedie the "use_mm"
> section, but it seems that it doesn't need current->mm too.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Indeed, use/unuse_mm should only be necessary for copy_to/from_user etc.
This is fine for s390, but it seems that x86 kvm_arch_async_page_not_present
might call apf_put_user which might call copy_to_user, so this is not ok, I guess.


> ---
>  virt/kvm/async_pf.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 10df100..0ced4f3 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -80,12 +80,10 @@ static void async_pf_execute(struct work_struct *work)
> 
>  	might_sleep();
> 
> -	use_mm(mm);
>  	down_read(&mm->mmap_sem);
>  	get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
>  	up_read(&mm->mmap_sem);
>  	kvm_async_page_present_sync(vcpu, apf);
> -	unuse_mm(mm);
> 
>  	spin_lock(&vcpu->async_pf.lock);
>  	list_add_tail(&apf->link, &vcpu->async_pf.done);
> 

