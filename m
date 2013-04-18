Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936474Ab3DRTEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3DRTEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:04:41 -0400
Date: Thu, 18 Apr 2013 21:01:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ptrace/x86: introduce ptrace_register_breakpoint()
Message-ID: <20130418190148.GA4685@redhat.com>
References: <20130418184350.GA4407@redhat.com> <20130418184417.GA4439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184417.GA4439@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18, Oleg Nesterov wrote:
>
> No functional changes, preparation.
>
> Extract the "register breakpoint" code from ptrace_get_debugreg()
> into the new/generic helper, ptrace_register_breakpoint(). It will
> have more users.
>
> The patch also adds another simple helper, ptrace_fill_bp_fields(),
> to factor out the arch_bp_generic_fields() logic in register/modify.

This patch is hardly readable. To simplify the review, I attached the
new/modified code below.

Oleg.

static int ptrace_fill_bp_fields(struct perf_event_attr *attr,
					int len, int type, bool disabled)
{
	int err, bp_len, bp_type;

	err = arch_bp_generic_fields(len, type, &bp_len, &bp_type);
	if (!err) {
		attr->bp_len = bp_len;
		attr->bp_type = bp_type;
		attr->disabled = disabled;
	}

	return err;
}

static struct perf_event *
ptrace_register_breakpoint(struct task_struct *tsk, int len, int type,
				unsigned long addr, bool disabled)
{
	struct perf_event_attr attr;
	int err;

	ptrace_breakpoint_init(&attr);
	attr.bp_addr = addr;

	err = ptrace_fill_bp_fields(&attr, len, type, disabled);
	if (err)
		return ERR_PTR(err);

	return register_user_hw_breakpoint(&attr, ptrace_triggered,
						 NULL, tsk);
}

static int ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
					int disabled)
{
	struct perf_event_attr attr = bp->attr;
	int err;

	err = ptrace_fill_bp_fields(&attr, len, type, disabled);
	if (err)
		return err;

	return modify_user_hw_breakpoint(bp, &attr);
}

static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
				      unsigned long addr)
{
	struct thread_struct *t = &tsk->thread;
	struct perf_event *bp = t->ptrace_bps[nr];
	int err = 0;

	if (!bp) {
		/*
		 * Put stub len and type to create an inactive but correct bp.
		 *
		 * CHECKME: the previous code returned -EIO if the addr wasn't
		 * a valid task virtual addr. The new one will return -EINVAL in
		 *  this case.
		 * -EINVAL may be what we want for in-kernel breakpoints users,
		 * but -EIO looks better for ptrace, since we refuse a register
		 * writing for the user. And anyway this is the previous
		 * behaviour.
		 */
		bp = ptrace_register_breakpoint(tsk,
				X86_BREAKPOINT_LEN_1, X86_BREAKPOINT_WRITE,
				addr, true);
		if (IS_ERR(bp))
			err = PTR_ERR(bp);
		else
			t->ptrace_bps[nr] = bp;
	} else {
		struct perf_event_attr attr = bp->attr;

		attr.bp_addr = addr;
		err = modify_user_hw_breakpoint(bp, &attr);
	}

	return err;
}

