Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab3CVPFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:05:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab3CVPFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:05:30 -0400
Date: Fri, 22 Mar 2013 16:02:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 4/7] uretprobes: return probe entry, prepare_uretprobe()
Message-ID: <20130322150252.GA17934@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try to read this series later. Just one note...

On 03/22, Anton Arapov wrote:
>
>    IOW, we must ensure that uprobe_pre_sstep_notifier() can't return 0.

Yes, but I do not see this change?

> +static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
> +{
> +	struct return_instance *ri;
> +	struct uprobe_task *utask;
> +	struct xol_area *area;
> +	unsigned long trampoline_vaddr;
> +	unsigned long prev_ret_vaddr, ret_vaddr;
> +
> +	area = get_xol_area();
> +	if (!area)
> +		return;
> +
> +	utask = get_utask();
> +	if (!utask)
> +		return;
> +
> +	prev_ret_vaddr = -1;
> +	if (utask->return_instances)
> +		prev_ret_vaddr = utask->return_instances->orig_ret_vaddr;
> +
> +	ri = kzalloc(sizeof(struct return_instance), GFP_KERNEL);
> +	if (!ri)
> +		return;
> +
> +	ri->dirty = false;
> +	trampoline_vaddr = get_trampoline_vaddr(area);
> +	ret_vaddr = arch_uretprobe_hijack_return_addr(trampoline_vaddr, regs);

OK, but you need to ensure that this code can be compiled on poweprc.

Oleg.

