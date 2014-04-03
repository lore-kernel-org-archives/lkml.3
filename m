Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaDCQcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:32:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55451 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaDCQc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:32:27 -0400
Date: Thu, 3 Apr 2014 22:02:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Kill UPROBE_SKIP_SSTEP and can_skip_sstep()
Message-ID: <20140403163219.GA4882@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140331194337.GA9257@redhat.com>
 <20140331194355.GA9275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140331194355.GA9275@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040316-0260-0000-0000-000004A3A997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> UPROBE_COPY_INSN, UPROBE_SKIP_SSTEP, and uprobe->flags must die. This
> patch kills UPROBE_SKIP_SSTEP. I never understood why it was added;
> not only it doesn't help, it harms.
> 
> It can only help to avoid arch_uprobe_skip_sstep() if it was already
> called before and failed. But this is ugly, if we want to know whether
> we can emulate this instruction or not we should do this analysis in
> arch_uprobe_analyze_insn(), not when we hit this probe for the first
> time.
> 
> And in fact this logic is simply wrong. arch_uprobe_skip_sstep() can
> fail or not depending on the task/register state, if this insn can be
> emulated but, say, put_user() fails we need to xol it this time, but
> this doesn't mean we shouldn't try to emulate it when this or another
> thread hist this bp next time.
> 
> And this is the actual reason for this change. We need to emulate the
> "call" insn, but push(return-address) can obviously fail.
> 
> Per-arch notes:
> 
> 	x86: __skip_sstep() can only emulate "rep;nop". With this
> 	     change it will be called every time and most probably
> 	     for no reason.
> 
> 	     This will be fixed by the next changes. We need to
> 	     change this suboptimal code anyway.
> 
> 	arm: Should not be affected. It has its own "bool simulate"
> 	     flag checked in arch_uprobe_skip_sstep().
> 
> 	ppc: Looks like, it can emulate almost everything. Does it
> 	     actually needs to record the fact that emulate_step()
> 	     failed? Hopefully not. But if yes, it can add the ppc-
> 	     specific flag into arch_uprobe.
> 
> TODO: rename arch_uprobe_skip_sstep() to arch_uprobe_emulate_insn(),
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

