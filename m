Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3CXQap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 12:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3CXQao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 12:30:44 -0400
Date: Sun, 24 Mar 2013 17:28:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 5/7] uretprobes: return probe exit, invoke handlers
Message-ID: <20130324162817.GD17037@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-6-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-6-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
> +static void handle_uretprobe(struct xol_area *area, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask;
> +	struct return_instance *ri, *tmp;
> +	unsigned long prev_ret_vaddr;
> +
> +	utask = get_utask();
> +	if (!utask)
> +		return;
> +
> +	ri = utask->return_instances;
> +	if (!ri)
> +		return;

Hmm. I am wondering what should the caller (handle_swbp) do in this
case...

> +
> +	instruction_pointer_set(regs, ri->orig_ret_vaddr);
> +
> +	while (ri) {
> +		if (ri->uprobe->consumers)
> +			handler_uretprobe_chain(ri->uprobe, regs);

I'd suggest to either remove this check or move it into
handler_uretprobe_chain().

> +
> +		put_uprobe(ri->uprobe);
> +		tmp = ri;
> +		prev_ret_vaddr = tmp->orig_ret_vaddr;

For what? It seems that prev_ret_vaddr should be simply killed.

> +		ri = ri->next;
> +		kfree(tmp);

Another case when you do put_uprobe/kfree using the different vars...
Once again, the code is correct but imho a bit confusing.

> +		if (!ri || ri->dirty == false) {
> +			/*
> +			 * This is the first return uprobe (chronologically)
> +			 * pushed for this particular instance of the probed
> +			 * function.
> +			 */
> +			utask->return_instances = ri;
> +			return;
> +		}

Else? we simply return without updating ->return_instances which
points to the freed element(s) ? OK, this must not be possible but
this is not obvious...

And the fact you check "ri != NULL" twice doesn't look very nice.
We already checked ri != NULL before while(ri), we have to do this
anyway for instruction_pointer_set(). Perhaps do/whild or even
for (;;) + break would be more clean. But this is minor.


I am not sure the logic is correct. OK. suppose that
->return_instances = NULL.

The task hits the rp breakoint. After that

	return_instances -> { .dirty = false }

The task hits the same breakoint before return (tail call), now
we have

	return_instances -> { .dirty = true } -> { .dirty = false }

Then it returns and handle_uretprobe() should unwind the whole stack.
But, it seems, the main loop will stop after the 1st iteration?

Ignoring the fact you need put_uprobe/kfree, it seems that we should
do something like this,

	do {
		handler_uretprobe_chain(...);

		if (!ri->dirty)	// not chained
			break;

		ri = ri->next;		
	} while (ri);

	utask->return_instances = ri;

No?

> @@ -1631,11 +1681,19 @@ static void handle_swbp(struct pt_regs *regs)
>  {
>  	struct uprobe *uprobe;
>  	unsigned long bp_vaddr;
> +	struct xol_area *area;
>  	int uninitialized_var(is_swbp);
>  
>  	bp_vaddr = uprobe_get_swbp_addr(regs);
> -	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
> +	area = get_xol_area();

Why?

No, we do not want this heavy and potentially unnecessary get_xol_area(),

> +	if (area) {

Just check uprobes_state.xol_area != NULL instead. If it is NULL
we simply should not call handle_uretprobe().

Or perhaps get_trampoline_vaddr() should simply return -1 if
->xol_area == NULL.

> +		if (bp_vaddr == get_trampoline_vaddr(area)) {

I just noticed get_trampoline_vaddr() takes an argument... It should
not, I think.

Oleg.

