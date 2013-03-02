Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab3CBSLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:11:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab3CBSLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:11:40 -0500
Date: Sat, 2 Mar 2013 19:09:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v3 5/6] uretprobes: invoke return probe handlers
Message-ID: <20130302180939.GA32596@redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com> <1362049215-5780-6-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362049215-5780-6-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Anton Arapov wrote:
>
> @@ -1576,8 +1622,8 @@ static void handle_swbp(struct pt_regs *regs)
>  
>  	if (!uprobe) {
>  		if (is_swbp > 0) {
> -			/* No matching uprobe; signal SIGTRAP. */
> -			send_sig(SIGTRAP, current, 0);
> +			/* No matching uprobe; Try with uretprobe */
> +			handle_uretprobe(regs);

Hmm. at least this looks certainly wrong.

You shifted send_sig(SIGSEGV) into handle_uretprobe(), but if nothing
else printk(KERN_ERR "uprobe: no instance found!") doesn't look nice
if we hit the regular breakoint.

In fact everything handle_uretprobe() does in this case looks wrong.
Including the fact that get_xol_area/get_utask can fail. And unwinding
looks bogus...

I think you need

	if (bp_vaddr == rp_trampoline_vaddr)
		handle_uretprobe()

like the previous version did.

Oleg.

