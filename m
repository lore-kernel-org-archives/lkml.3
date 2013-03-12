Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab3CLOqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:46:45 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:54113 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3CLOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <1363058712.4534.12.camel@pasglop>
References: <1363058712.4534.12.camel@pasglop>
Date: Tue, 12 Mar 2013 07:46:42 -0700
X-Google-Sender-Auth: AMpge1red__MDH47hfN1AQBKo4E
Message-ID: <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
Subject: Re: Regression with orderly_poweroff()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>, Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 8:25 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> A couple of weeks ago, David sent an email that went unanswered about a
> regression concerning orderly_poweroff(). I think the original patch
> causing it should be reverted, here's the actual email with the
> explanation:

Hmm.. You should really have cc'd the people who acked it and were in
the sign-off chain too, because all those people are involved with the
patch as well.

Also, the patch doesn't revert cleanly any more after commit
7ff6764061ec ("usermodehelper: cleanup/fix __orderly_poweroff() &&
argv_free()") which seems to be a real bug-fix for a double free, but
which really doesn't seem to work together with UMH_NO_WAIT.

So before reverting that one too, let's at least get the people who
were involved with the original patch (and the bugfix that relies on
it) in the email thread.

I'm leaving David's quoted report for the new people..

                Linus

---
> Subject: orderly_poweroff() is no longer safe in atomic context
>
> Commit 6c0c0d4d1080840eabb3d055d2fd81911111c5fd "poweroff: fix bug in
> orderly_poweroff()" apparently fixes one bug in orderly_poweroff(),
> but introduces another.  The comments on orderly_poweroff() claim it
> can be called from any context - and indeed we call it from interrupt
> context in arch/powerpc/platforms/pseries/ras.c for example.  But
> since that commit this is no longer safe, since
> call_usermodehelper_fns() is not safe in interrupt context without the
> UMH_NO_WAIT option.
>
> I'm having trouble understanding the commit message to see what the
> original bug being fixed was.  Specifically I can't make sense of:
>
>   |  The bug here is, step 1 is always successful with param
>   |  UMH_NO_WAIT, which obey the design goal of orderly_poweroff.
>
> And without understanding the original bug, I'm not sure what the
> correct fix is.
