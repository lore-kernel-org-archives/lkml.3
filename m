Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab3GLCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:09:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48177 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab3GLCJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:09:56 -0400
Date: Fri, 12 Jul 2013 11:09:51 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: reset arch memslot info on memslot creation
Message-Id: <20130712110951.2b9ffb0e0e3fdeb537db132a@gmail.com>
In-Reply-To: <20130711074153.GB5895@redhat.com>
References: <20130710082439.GA1482@redhat.com>
	<20130710224956.b7a44f39c151148afa5a47ba@gmail.com>
	<20130711074153.GB5895@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013 10:41:53 +0300
Gleb Natapov <gleb@redhat.com> wrote:

> On Wed, Jul 10, 2013 at 10:49:56PM +0900, Takuya Yoshikawa wrote:
> > On Wed, 10 Jul 2013 11:24:39 +0300
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > On x86, kvm_arch_create_memslot assumes that rmap/lpage_info for the
> > > slot are zeroed out: if they weren't, error handling code after out_free
> > > label will free memory which wasn't allocated here.
> > > This always happens to be the case because on KVM_MR_DELETE we clear the
> > > whole arch structure.  So there's no bug, but it's cleaner not to rely
> > > on this here.
> > 
> > Yes, the assumption is that the function is called only with zero-sized slots.
> > Since changing the size is not allowed, DELETE-CREATE is the only case we
> > care about.
> > 
> > But isn't it possible to make it explicit that zero-sized slots have always
> > zero-cleared contents instead?  Otherwise, there would be many troubles.
> > 
> Do you have something in mind?
> 

I remember that I once wrote code that assumed flags field was cleared before
creating a new slot and was pointed out that such assumptions might be dangerous:
actually, it's cleared separately but not so easy to notice.

So, I want to make it clear what differentiate DELETE'ed slots from others.

If we only assume (npages == 0), CREATE should properly set everything,
having out_free troubles in mind like this patch.  If we also assume the other
fields are zero, then DELETE is responsible for that assumption, some comment
in code may be helpful.

Actually, (rmap==NULL) was once used to check if we needed to allocate memory
for a new slot, meaning that we assumed the latter.  I felt uneasy and changed
that to (npages == 0).

Let's make it clear the underlying assumptions now.

	Takuya
