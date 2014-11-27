Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaK0MIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:08:17 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50023 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaK0MIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:08:15 -0500
Date: Thu, 27 Nov 2014 13:08:03 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141127130803.7cfbe5aa@thinkpad-w530>
In-Reply-To: <20141127120441.GB4390@osiris>
References: <20141126151729.GB9612@redhat.com>
	<20141126152334.GA9648@redhat.com>
	<20141126163207.63810fcb@thinkpad-w530>
	<20141126154717.GB10568@redhat.com>
	<5475FAB1.1000802@de.ibm.com>
	<20141126163216.GB10850@redhat.com>
	<547604FC.4030300@de.ibm.com>
	<20141126170447.GC11202@redhat.com>
	<20141127070919.GA4390@osiris>
	<20141127090301.3ddc3077@thinkpad-w530>
	<20141127120441.GB4390@osiris>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112712-0025-0000-0000-0000029E3F5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 27, 2014 at 09:03:01AM +0100, David Hildenbrand wrote:
> > > Code like
> > > 	spin_lock(&lock);
> > > 	if (copy_to_user(...))
> > > 		rc = ...
> > > 	spin_unlock(&lock);
> > > really *should* generate warnings like it did before.
> > > 
> > > And *only* code like
> > > 	spin_lock(&lock);
> > 
> > Is only code like this valid or also with the spin_lock() dropped?
> > (e.g. the access in patch1 if I remember correctly)
> > 
> > So should page_fault_disable() increment the pagefault counter and the preempt
> > counter or only the first one?
> 
> Given that a sequence like
> 
> 	page_fault_disable();
>  	if (copy_to_user(...))
>  		rc = ...
>  	page_fault_enable();
> 
> is correct code right now I think page_fault_disable() should increase both.
> No need for surprising semantic changes.
> 
> > So we would have pagefault code rely on:
> > 
> > in_disabled_pagefault() ( pagefault_disabled() ... whatever ) instead of
> > in_atomic().
> 
> No, let's be more defensive: the page fault handler should do nothing if
> in_atomic() just like now. But it could have a quick check and emit a one
> time warning if page faults aren't disabled in addition.
> That might help debugging but keeps the system more likely alive.

Sounds sane if we increase both counters!

> 
> might_fault() however should call might_sleep() if page faults aren't
> disabled, but that's what you proposed anyway I think.

Jap, sounds good to me. Will see if I can come up with something.

Thanks!

