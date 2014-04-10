Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030717AbaDJMyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:54:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030515AbaDJMx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:53:58 -0400
Message-ID: <5346944F.2040709@redhat.com>
Date: Thu, 10 Apr 2014 14:53:35 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140409194434.GA6235@redhat.com>
In-Reply-To: <20140409194434.GA6235@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 09:44 PM, Oleg Nesterov wrote:
> +static void ttt_clear_displacement(struct arch_uprobe *auprobe, struct insn *insn)

Branch instruction's offset isn't called "displacement"
on x86.

How about ttt_clear_branch_offset?

> +{
> +	/*
> +	 * Turn this insn into "call 1f; 1:", this is what we will execute
> +	 * out-of-line if ->emulate() fails.
> +	 *
> +	 * In the likely case this will lead to arch_uprobe_abort_xol(), but
> +	 * see the comment in ->emulate(). So we need to ensure that the new
> +	 * ->ip can't fall into non-canonical area and trigger #GP.
> +	 *
> +	 * We could turn it into (say) "pushf", but then we would need to
> +	 * divorce ->insn[] and ->ixol[]. We need to preserve the 1st byte
> +	 * of ->insn[] for set_orig_insn().
> +	 */
> +	memset(auprobe->insn + insn_offset_immediate(insn),
> +		0, insn->immediate.nbytes);
> +}

