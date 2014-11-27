Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaK0IDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:03:14 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:34030 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaK0IDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:03:12 -0500
Date: Thu, 27 Nov 2014 09:03:01 +0100
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
Message-ID: <20141127090301.3ddc3077@thinkpad-w530>
In-Reply-To: <20141127070919.GA4390@osiris>
References: <20141126070258.GA25523@redhat.com>
	<20141126110504.511b733a@thinkpad-w530>
	<20141126151729.GB9612@redhat.com>
	<20141126152334.GA9648@redhat.com>
	<20141126163207.63810fcb@thinkpad-w530>
	<20141126154717.GB10568@redhat.com>
	<5475FAB1.1000802@de.ibm.com>
	<20141126163216.GB10850@redhat.com>
	<547604FC.4030300@de.ibm.com>
	<20141126170447.GC11202@redhat.com>
	<20141127070919.GA4390@osiris>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112708-0005-0000-0000-0000023E85BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Code like
> 	spin_lock(&lock);
> 	if (copy_to_user(...))
> 		rc = ...
> 	spin_unlock(&lock);
> really *should* generate warnings like it did before.
> 
> And *only* code like
> 	spin_lock(&lock);

Is only code like this valid or also with the spin_lock() dropped?
(e.g. the access in patch1 if I remember correctly)


So should page_fault_disable() increment the pagefault counter and the preempt
counter or only the first one?

> 	page_fault_disable();
> 	if (copy_to_user(...))
> 		rc = ...
> 	page_fault_enable();
> 	spin_unlock(&lock);
> should not generate warnings, since the author hopefully knew what he did.
> 
> We could achieve that by e.g. adding a couple of pagefault disabled bits
> within current_thread_info()->preempt_count, which would allow
> pagefault_disable() and pagefault_enable() to modify a different part of
> preempt_count than it does now, so there is a way to tell if pagefaults have
> been explicitly disabled or are just a side effect of preemption being
> disabled.
> This would allow might_fault() to restore its old sane behaviour for the
> !page_fault_disabled() case.

So we would have pagefault code rely on:

in_disabled_pagefault() ( pagefault_disabled() ... whatever ) instead of
in_atomic().

I agree with this approach, as this is basically what I suggested in one of my
previous mails.

