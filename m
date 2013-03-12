Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3CLTN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab3CLTN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:13:28 -0400
Date: Tue, 12 Mar 2013 20:11:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Regression with orderly_poweroff()
Message-ID: <20130312191118.GA17439@redhat.com>
References: <1363058712.4534.12.camel@pasglop> <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com> <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com> <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Linus Torvalds wrote:
>
> On Tue, Mar 12, 2013 at 11:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > And how this can help? The real problem is not GFP_KERNEL.
> > call_usermodehelper_exec(UMH_WAIT_EXEC) will block.
>
> Well, it's probably a starting point.
>
> You need to do the argument handling atomically, because you cannot
> delay that in a workqueue (the arguments will be long gone by the time
> the workqueue starts up).

Confused... which arguments? The only argument is poweroff_cmd, it can't
go away and kmalloc(GFP_KERNEL) is fine in work->func() ?

> So I think the fix is a combination of your
> and Lucas' code, where you first do the setup atomically (copying the
> arguments and allocating that space with GFP_ATOMIC) and then you do a
> workqueue to actually do the real work of the usermode helper thing.

OK, whatever I missed we can do this, and the pending patches from Lucas
(split allocation and call_usermodehelper_exec) makes sense anyway.

In fact we can do more. On the top of Lucas's changes we can change
call_usermodehelper_freeinfo() to not call kfree(info) unconditionally,
and then we can avoid even kmalloc(GFP_ATOMIC). Not sure this actually
makes sense though.

So do you agree that orderly_poweroff() can simply use schedule_work() ?




Btw. There is another "strange" user, arch/x86/kernel/cpu/mcheck/mce.c.
It uses mce_trigger_work to call call_usermodehelper(UMH_NO_WAIT).
Why? UMH_NO_WAIT is already atomic. And the !work_pending() check is
confusing, schedule_work(schedule_work) checks it is not pending.

Oleg.

