Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3CWRs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:48:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab3CWRsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:48:25 -0400
Date: Sat, 23 Mar 2013 18:46:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 4/7] uretprobes: return probe entry, prepare_uretprobe()
Message-ID: <20130323174605.GA3649@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
> @@ -1513,20 +1596,26 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
>  {
>  	struct uprobe_consumer *uc;
>  	int remove = UPROBE_HANDLER_REMOVE;
> +	bool prep = false; /* prepare return uprobe, when needed */
>  	int rc = 0;
>  
>  	down_read(&uprobe->register_rwsem);
>  	for (uc = uprobe->consumers; uc; uc = uc->next) {
>  		if (uc->handler)
>  			rc = uc->handler(uc, regs);
> -		else
> +		else {
> +			prep |= true;
>  			remove = 0;
> +		}

This looks wrong (see also my reply to 1/7).

What if uc->handler != NULL and uc->ret_handler != NULL ? We need

	if (uc->rer_handler)
		need_prep = true;

Oleg.

