Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3DVPKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab3DVPKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:10:17 -0400
Date: Mon, 22 Apr 2013 17:07:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get/set signal-blocked mask
Message-ID: <20130422150710.GA30858@redhat.com>
References: <1366624400-9773-1-git-send-email-avagin@openvz.org> <20130422145704.GA30029@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422145704.GA30029@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Oleg Nesterov wrote:
>
> On 04/22, Andrey Vagin wrote:
> >
> > +	case PTRACE_SETSIGMASK:
> > +	{
> > +		sigset_t new_set;
> > +
> > +		if (addr != sizeof(sigset_t)) {
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		if (copy_from_user(&new_set, datavp, sizeof(sigset_t))) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
> > +
> > +		spin_lock_irq(&child->sighand->siglock);
> > +		__set_task_blocked(child, &new_set);
> > +		spin_unlock_irq(&child->sighand->siglock);
>
> No, please don't...
>
> set_current_blocked/__set_task_blocked assume that tsk == current.
> If nothing else, note recalc_sigpending() in __set_task_blocked().
>
> I don't understand "This method is not suitable for stopped tasks"
> from the changelog, but if you really need PTRACE_SETSIGMASK just
> change ->blocked under siglock and do recalc_sigpending_tsk(child).
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

actually this is not necessary, the tracee will do recalc_sigpending()
after resume. But perhaps a comment make sense.

Oleg.

