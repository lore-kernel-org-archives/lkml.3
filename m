Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaKQXNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:13:44 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37358 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaKQXNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:13:41 -0500
Date: Mon, 17 Nov 2014 15:13:36 -0800
From: josh@joshtriplett.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W.Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Message-ID: <20141117231336.GA1113@cloud>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <546A3942.5040906@schaufler-ca.com>
 <CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
 <CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
 <9f43a787-165e-4256-a097-f7691204d9d6@email.android.com>
 <CALCETrU2tXM5sKx=L-K6=ARkvqefkcZHW3_RGhsgfc31FuWxJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU2tXM5sKx=L-K6=ARkvqefkcZHW3_RGhsgfc31FuWxJg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:50:10PM -0800, Andy Lutomirski wrote:
> On Mon, Nov 17, 2014 at 2:41 PM, Eric W.Biederman <ebiederm@xmission.com> wrote:
> >
> >
> > On November 17, 2014 1:46:59 PM EST, Andy Lutomirski <luto@amacapital.net> wrote:
> >>On Mon, Nov 17, 2014 at 10:31 AM, Andy Lutomirski <luto@amacapital.net>
> >>wrote:
> >>> On Mon, Nov 17, 2014 at 10:06 AM, Casey Schaufler
> >>> <casey@schaufler-ca.com> wrote:
> >>>> On 11/15/2014 1:01 AM, Josh Triplett wrote:
> >>>>> Currently, unprivileged processes (without CAP_SETGID) cannot call
> >>>>> setgroups at all.  In particular, processes with a set of
> >>supplementary
> >>>>> groups cannot further drop permissions without obtaining elevated
> >>>>> permissions first.
> >>>>
> >>>> Has anyone put any thought into how this will interact with
> >>>> POSIX ACLs? I don't see that anywhere in the discussion.
> >>>
> >>> That means that user namespaces are a problem, too, and we need to
> >>fix
> >>> it.  Or we should add some control to turn unprivileged user
> >>namespace
> >>> creation on and off and document that turning it on defeats POSIX
> >>ACLs
> >>> with a group entry that is more restrictive than the other entry.
> >>>
> >>
> >>This is a significant enough issue that I posted it to oss-security:
> >>
> >>http://www.openwall.com/lists/oss-security/2014/11/17/19
> >>
> >>It's not at all obvious to me how to fix it.  We could disallow userns
> >>creation of any supplementary groups don't match fsuid, or we could
> >>keep negative-only groups around in the userns.
> >>
> >>It may be worth adding a sysctl to change the behavior, too.  IMO it's
> >>absurd to use groups to deny permissions that are otherwise available.
> >
> > There is an obvious user namespace fix.  Don't allow dropping supplemental groups that are not mapped.
> 
> Why exactly does this fix it?  I guess that, if a supplementary group
> is in your subgid list, then we can assume that dropping it is safe?

Considering that one of the fixes I'd like to add is "allow mapping
groups that you have in your supplemental group list", no, that fix
doesn't suffice. :)

> > That will require a little bit of fancy footwork if you want to play with supplemental groups in your unprivileged user namespace.   I would like to get a grip on what hoops would be required before we add the additional restriction.  Possibly something as simple as calling sg.
> 
> The main hoop I can think of is that setgroups would be impossible to
> call if you have an unmapped supplementary group.  This could break
> all kinds of things.

Agreed.

- Josh Triplett
