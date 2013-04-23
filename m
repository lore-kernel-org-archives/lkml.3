Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3DWNOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:14:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab3DWNOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:14:48 -0400
Date: Tue, 23 Apr 2013 15:11:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get/set signal-blocked mask
Message-ID: <20130423131151.GA23924@redhat.com>
References: <1366624400-9773-1-git-send-email-avagin@openvz.org> <20130422145704.GA30029@redhat.com> <20130422150710.GA30858@redhat.com> <20130423105917.GA11121@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423105917.GA11121@paralelels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Andrew Vagin wrote:
>
> On Mon, Apr 22, 2013 at 05:07:10PM +0200, Oleg Nesterov wrote:
>
> > >
> > > I don't understand "This method is not suitable for stopped tasks"
>
> For example, a stopped process has a pending signal and this signal is
> not blocked. crtools should dump its state,

Ah, thanks, I thought that you meant restoring doesn't work...

> > > from the changelog, but if you really need PTRACE_SETSIGMASK just
> > > change ->blocked under siglock and do recalc_sigpending_tsk(child).
> >                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > actually this is not necessary, the tracee will do recalc_sigpending()
> > after resume. But perhaps a comment make sense.
>
> __set_task_blocked executes retarget_shared_pending. I think it must be
> called here too or am I wrong?

Yes sure, this is the main reason why set_current_blocked() exists.
We do not want to "delay" a group-wide signal.

But ptrace can delay it anyway? And, assuming that other threads are
stopped too this all doesn't matter at all, every thread does
recalc_sigpending() after resume. In short, if the debugger blocks a
signal, it should know what it does.

IOW, I hope this is not a problem, and I'd like to avoid the usage of
__set_task_blocked outside of signal.c or with tsk != current.

Oleg.

