Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaIHVeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:34:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53541 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754306AbaIHVeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:34:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Mon, 08 Sep 2014 23:53:34 +0200
Message-ID: <3827451.ToKxd7Xb2J@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAM_iQpW8XT_ixUTG-9JPoeZ-kqMN1YpkpwvgQtQVDNLDJ5cn8A@mail.gmail.com>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <1534583.H3bxpdPhXK@vostro.rjw.lan> <CAM_iQpW8XT_ixUTG-9JPoeZ-kqMN1YpkpwvgQtQVDNLDJ5cn8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 08, 2014 01:58:30 PM Cong Wang wrote:
> On Mon, Sep 8, 2014 at 1:54 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, September 08, 2014 10:40:17 AM Cong Wang wrote:
> >>
> >> We asked you to comment on either if this patch is safe for PM freeze
> >> if we don't have the cgroup_freezing() check, or if it is not safe why (so that
> >> I can put it in the comment).
> >
> > OK, which version of it?  Anything that has been posted as a complete patch you
> > have a link to?  Or am I supposed to go through the whole thread and figure out
> > how the patch *might* have looked had it been posted and then comment?
> 
> Sorry, I meant this version, the one we are discussing about.
> In case you missed it too, let me show the related code for you:
> 
> +       /* It might not be safe to check TIF_MEMDIE for pm freeze. */
> +       if (cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
> +               return true;
> +
> 
> (return true means it will break the loop of freezing, that is thaw itself.)
> 
> So our question is if we really need the cgroup_freezing() check here?

No, I don't think so.

> IOW, is it safe to check TIF_MEMDIE and then thaw itself even if the
> freeze request is from PM? Hope it is clear now.

Yes, it is clear, thanks.

Why would the cgroup_freezing() test matter here at all?

> >> OK, maybe just one or two sentences. Let me know if the following
> >> comment is okay for you:
> >>
> >> /* OOM killer might decide to kill this process after it is frozen,
> >>   in this case it should thaw and die. */
> >
> > I don't think it's sufficient.  In particular, what does "thaw and die" mean
> > exactly?  It should be thawed immediately and then die or it should die right
> > after it's thawed (at one point in the future)?
> >
> 
> OK, let me try again:
> 
> /* OOM killer may decide to kill this process after it is frozen,
>   in this case SIGKILL can never be handled, so we should check
>  TIF_MEMDIE and if it is set, thaw and let SIGKILL kill it. */
> 
> (Again, more detailed explanation is in the changelog, comment is just
> for a quick reference, this seems what we all agree on.)

OK

I think you can simply add the test_thread_flag(TIF_MEMDIE) check to
__refrigerator() and it should be OK without the comment.

But please tell me this: If TIF_MEMDIE is set and we thaw the process,
can it do *anything* before dying or will it die immediately?

Rafael

