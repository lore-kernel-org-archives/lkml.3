Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaKOT3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 14:29:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60916 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbaKOT3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 14:29:33 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 15 Nov 2014 11:29:25 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Message-ID: <20141115192924.GB19060@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d28osceg.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 09:37:27AM -0600, Eric W. Biederman wrote:
> Josh Triplett <josh@joshtriplett.org> writes:
> 
> > Currently, unprivileged processes (without CAP_SETGID) cannot call
> > setgroups at all.  In particular, processes with a set of supplementary
> > groups cannot further drop permissions without obtaining elevated
> > permissions first.
> >
> > Allow unprivileged processes to call setgroups with a subset of their
> > current groups; only require CAP_SETGID to add a group the process does
> > not currently have.
> 
> A couple of questions.
> - Is there precedence in other unix flavors for this?

I found a few references to now-nonexistent pages at MIT about a system
with this property, but other than that no.

I've also found more than a few references to people wanting this
functionality.

> - What motiviates this change?

I have a series of patches planned to add more ways to drop elevated
privileges without requiring a transition through root to do so.  That
would improve the ability for unprivileged users to run programs
sandboxed with even *less* privileges.  (Among other things, that would
also allow programs running with no_new_privs to further *reduce* their
privileges, which they can't currently do in this case.)

> - Have you looked to see if anything might for bug compatibilty
>   require applications not to be able to drop supplementary groups?

I haven't found any such case; that doesn't mean such a case does not
exist.  Feedback welcome.

The only case I can think of (and I don't know of any examples of such a
system): some kind of quota system that limits the members of a group to
a certain amount of storage, but places no such limit on non-members.

However, the idea of *holding* a credential (a supplementary group ID)
giving *less* privileges, and *dropping* a credential giving *more*
privileges, would completely invert normal security models.  (The sane
way to design such a system would be to have a privileged group for
"users who can exceed the quota".)

If it turns out that a real case exists that people care about, I could
easily make this configurable, either at compile time or via a sysctl.

- Josh Triplett
