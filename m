Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab3DIOUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760602Ab3DIOUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:20:52 -0400
Date: Tue, 9 Apr 2013 16:16:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 2/9] uretprobes: Reserve the first slot in xol_vma
	for trampoline
Message-ID: <20130409141615.GB20577@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com> <1365004839-21982-3-git-send-email-anton@redhat.com> <20130407114441.GB2186@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130407114441.GB2186@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07, Srikar Dronamraju wrote:
>
> * Anton Arapov <anton@redhat.com> [2013-04-03 18:00:32]:
>
> > Allocate trampoline page, as the very first one in uprobed
> > task xol area, and fill it with breakpoint opcode.
> >
> > Also introduce get_trampoline_vaddr() helper, to wrap the
> > trampoline address extraction from area->vaddr. That removes
> > confusion and eases the debug experience in case ->vaddr
> > notion will be changed.
> >
> > v1 changes:
> > * rework get_trampoline_vaddr() helper.
> > * init xol_area->slot_count.
> >
> > Signed-off-by: Anton Arapov <anton@redhat.com>
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

> > +static unsigned long get_trampoline_vaddr(void)
> > +{
> > +	struct xol_area *area;
> > +	unsigned long trampoline_vaddr = -1;
> > +
> > +	area = current->mm->uprobes_state.xol_area;
> > +	smp_read_barrier_depends();
>
> check: do we need this barrier?

In theory yes. For example, we do not want the false positive in
handle_swbp() which does

	if (bp_vaddr == get_trampoline_vaddr())
		handler_uretprobe();

In theory we can race with another thread which initializes area
(in particular area->vaddr) and then sets uprobes_state.xol_area = area
in xol_add_vma().

If we see ->xol_area != NULL we must ensure that we read the correct
value of area->vaddr, so we need a barrier.

In short. Please note get_xol_area()->smp_read_barrier_depends(),
get_trampoline_vaddr() needs it for the same reason.

Oleg.

