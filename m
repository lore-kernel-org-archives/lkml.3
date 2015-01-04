Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbbADSln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 13:41:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbbADSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 13:41:42 -0500
Date: Sun, 4 Jan 2015 19:40:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pratyush Anand <panand@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com
Subject: Re: [RFC 8/8] ARM64: Add uprobe support
Message-ID: <20150104184012.GA12614@redhat.com>
References: <cover.1420038188.git.panand@redhat.com> <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com> <20150102172333.GA6264@redhat.com> <54A944ED.5010408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A944ED.5010408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Pratyush Anand wrote:
>
> On Friday 02 January 2015 10:53 PM, Oleg Nesterov wrote:
>> But the main question is: why do we need add/find_ss_context ?? Please
>> explain.
>>
>
> See arch/arm64/kernel/debug-monitors.c: call_step_hook
>
> Unlike breakpoint exception, there is no ESR info check for step
> exception. So, it is the responsibility of step handler
> (uprobe_single_step_handler) to make sure that exception was generated
> for it.

Yes, yes, this is clear. My point was, we can (I think) rely on
uprobe_post_sstep_notifier() which checks ->active_uprobe != NULL.

And I guess you understood what I meant, but since I wasn't clear let
me repeat to ensure we really understand each other.

Can't

	uprobe_single_step_handler(regs, esr)
	{
		if (user_mode(regs) && uprobe_post_sstep_notifier(regs))
			return HANDLED;
		return ERROR;
	}

work without this step_ctx logic?

If everything is correct, the probed task can execute a single (xol) insn
in user-mode before the trap. If ->active_uprobe is set we know that we
expect the ss trap in user-mode, and nothing else except this xol insn can
generate it?

Perhaps arm64 needs additional checks, I dunno... If you think that the
->active_uprobe check is not enough you can probably also verify that
"utask->state = UTASK_SSTEP" and/or "regs->pc - 4 == utask->xol_vaddr",
but so far it seems to me that these additional checks can only make sense
under WARN_ON().

Oleg.

