Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbaDWTcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:32:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbaDWTcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:32:42 -0400
Date: Wed, 23 Apr 2014 21:32:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async_pf: kill the unnecessary
	use_mm/unuse_mm async_pf_execute()
Message-ID: <20140423193228.GA3441@redhat.com>
References: <20140421132558.GA13608@redhat.com> <5356CDDF.5000203@de.ibm.com> <5356DA2F.8080606@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356DA2F.8080606@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Christian Borntraeger wrote:
>
> On 22/04/14 22:15, Christian Borntraeger wrote:
> > On 21/04/14 15:25, Oleg Nesterov wrote:
> >> async_pf_execute() has no reasons to adopt apf->mm, gup(current, mm)
> >> should work just fine even if current has another or NULL ->mm.
> >>
> >> Recently kvm_async_page_present_sync() was added insedie the "use_mm"
> >> section, but it seems that it doesn't need current->mm too.
> >>
> >> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > Indeed, use/unuse_mm should only be necessary for copy_to/from_user etc.
> > This is fine for s390, but it seems that x86 kvm_arch_async_page_not_present
> > might call apf_put_user which might call copy_to_user, so this is not ok, I guess.
>
> wanted to say kvm_arch_async_page_not_present, but I have to correct myself.
> x86 does the "page is there" in the cpu loop, not in the worker. The cpu look
> d oes have a valid mm. So this patch should be also ok.

Thanks ;)

Btw, I forgot to mention this in the changelog, but

> >> @@ -80,12 +80,10 @@ static void async_pf_execute(struct work_struct *work)
> >>
> >>  	might_sleep();
> >>
> >> -	use_mm(mm);
> >>  	down_read(&mm->mmap_sem);
> >>  	get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
> >>  	up_read(&mm->mmap_sem);
> >>  	kvm_async_page_present_sync(vcpu, apf);
> >> -	unuse_mm(mm);

it can actually do

	get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);

"task" is only used to increment task_struct->xxx_flt. I don't think
async_pf_execute() actually needs this (current is PF_WQ_WORKER after
all), but I didn't dare to do another change in the code I can hardly
understand.

Oleg.

