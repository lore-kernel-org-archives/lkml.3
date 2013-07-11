Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3GKHl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:41:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab3GKHl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:41:58 -0400
Date: Thu, 11 Jul 2013 10:41:53 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: reset arch memslot info on memslot creation
Message-ID: <20130711074153.GB5895@redhat.com>
References: <20130710082439.GA1482@redhat.com>
 <20130710224956.b7a44f39c151148afa5a47ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710224956.b7a44f39c151148afa5a47ba@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:49:56PM +0900, Takuya Yoshikawa wrote:
> On Wed, 10 Jul 2013 11:24:39 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On x86, kvm_arch_create_memslot assumes that rmap/lpage_info for the
> > slot are zeroed out: if they weren't, error handling code after out_free
> > label will free memory which wasn't allocated here.
> > This always happens to be the case because on KVM_MR_DELETE we clear the
> > whole arch structure.  So there's no bug, but it's cleaner not to rely
> > on this here.
> 
> Yes, the assumption is that the function is called only with zero-sized slots.
> Since changing the size is not allowed, DELETE-CREATE is the only case we
> care about.
> 
> But isn't it possible to make it explicit that zero-sized slots have always
> zero-cleared contents instead?  Otherwise, there would be many troubles.
> 
Do you have something in mind?

> 	Takuya
> 
> > 
> > Make the code more robust by clearing the rmap/lpage_info explicitly.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e8ba99c..96e6eb4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6922,6 +6922,10 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
> >  {
> >  	int i;
> >  
> > +	/* Reset in case slot had some rmap/lpage_info. */
> > +	memset(&slot->arch.rmap, 0, sizeof slot->arch.rmap);
> > +	memset(&slot->arch.lpage_info, 0, sizeof slot->arch.lpage_info);
> > +
> >  	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> >  		unsigned long ugfn;
> >  		int lpages;
> > -- 
> > MST
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> Takuya Yoshikawa <takuya.yoshikawa@gmail.com>

--
			Gleb.
