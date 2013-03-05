Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3CEN2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 08:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3CEN2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:28:23 -0500
Date: Tue, 5 Mar 2013 14:28:05 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v4 5/6] uretprobes: invoke return probe handlers
Message-ID: <20130305132805.GC24229@bandura.brq.redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
 <1362407893-32505-6-git-send-email-anton@redhat.com>
 <20130304165120.GB3328@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304165120.GB3328@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 05:51:20PM +0100, Oleg Nesterov wrote:
> On 03/04, Anton Arapov wrote:
> >
> > +static void handle_uretprobe(struct xol_area *area, struct pt_regs *regs)
> > +{
> > +	struct hlist_head *head;
> > +	struct hlist_node *tmp;
> > +	struct return_uprobe_i *ri;
> > +	struct uprobe_task *utask;
> > +	unsigned long orig_ret_vaddr;
> > +
> > +	/* TODO: uretprobe bypass logic */
> > +
> > +	utask = get_utask();
> > +	if (!utask) {
> > +		/* TODO:RFC task is not probed, do we want printk here? */
> > +		return;
> > +	}
> > +	head = &utask->return_uprobes;
> > +	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
> > +		if (ri->uprobe->consumers) {
> > +			instruction_pointer_set(regs, ri->orig_ret_vaddr);
> This doesn't look right if ri->orig_ret_vaddr == area->vaddr. We should
> splice the list and find orig_ret_vaddr in advance.
True, this cycle is buggy. I will rework handle_uretprobe().

> > @@ -1589,8 +1639,11 @@ static void handle_swbp(struct pt_regs *regs)
> >
> >  	if (!uprobe) {
> >  		if (is_swbp > 0) {
> > -			/* No matching uprobe; signal SIGTRAP. */
> > -			send_sig(SIGTRAP, current, 0);
> > +			area = get_xol_area();
> > +			if (area && bp_vaddr == area->vaddr)
> > +				handle_uretprobe(area, regs);
> > +			else
> > +				send_sig(SIGTRAP, current, 0);
> 
> Why? We can check bp_vaddr at the start, before find_active_uprobe().
For some reason, I was thinking it is better to hide this logic under
if (!uprobe). Will correct this chunk.

> And I'd suggest to not use area->vaddr directly, imho a trivial helper
> makes sense.
I see the idea behind, with this change it will be more clear and
fragile in case someone change the underneath logic. Will do this.

thank you very much!
Anton.
