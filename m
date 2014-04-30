Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbaD3LwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509AbaD3LwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:52:07 -0400
Date: Wed, 30 Apr 2014 13:51:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] ptrace: Fix fork event messages across pid
	namespaces
Message-ID: <20140430115155.GA6077@redhat.com>
References: <1398802858-13624-1-git-send-email-mdempsky@chromium.org> <1398818077-25107-1-git-send-email-mdempsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398818077-25107-1-git-send-email-mdempsky@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Matthew Dempsky wrote:
>
> On Tue, Apr 29, 2014 at 3:11 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > More Oleg review would be nice, please ;)
>
> FWIW, Oleg "acked" v4 earlier in the thread.  Are you asking for
> further review from him beyond that?

Yes, still/again

Acked-by: Oleg Nesterov <oleg@redhat.com>



> > Well that's a scary comment.  If we're going to leave the code in this
> > state then please carefully describe (within this comment) the
> > *consequences* of the race.  Does the kernel crash?  Give away your ssh
> > keys?  If not then what.
>
> Sorry, I can see how that comment could be scary without proper
> context.  I added another sentence explaining the consequences are
> limited to the ptracer receiving a bogus pid_t value from
> PTRACE_GETEVENTMSG.
>
> > And how would userspace recognize and/or recover from the race?
>
> If the ptracer attaches via PTRACE_ATTACH, then there shouldn't be a
> race: the ptracer can't use PTRACE_SETOPTIONS to request fork events
> until after the child has already stopped.  So any SIGTRAP fork events
> that it receives before using PTRACE_SETOPTIONS it should disregard,
> because it hasn't asked the kernel to send them yet.
>
> If the ptracer attaches via PTRACE_SEIZE and also requests fork events
> at the same time, then it would need to discard the first SIGTRAP it
> receives for the child if:
>
>   1. it's a fork event;
>   2. the ptracer can't otherwise prove the fork happened after the
>      PTRACE_SEIZE rather than concurrently; and
>   3. the ptracer is concerned a ptracer from a different pid namespace
>      may have just detached.

And I think we should just ignore this very unlikely and harmless race.

We do not see a simple way to close it and in fact this ptrace_event() is
inherently racy anyway. Even without namespaces, if we race with DETACH +
ATTACH, the new tracer gets the correct child's pid, but the child can be
already untraced.

_Perhaps_ we can do something better later (to remind, we can setup
->ptrace_message beforehand and change ATTACH to clear it), but this is
more subtle and needs more changes.

This patch is straightforward, and it fixes the old/known problem: currently
this pid_t is always wrong unless the tracer is from the root namespace.

Oleg.

