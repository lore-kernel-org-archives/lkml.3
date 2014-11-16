Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaKPPm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 10:42:56 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:48039 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbaKPPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 10:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <20141116133230.GA32030@thunk.org>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org> <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin> <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org> <87vbmfq1uw.fsf@x220.int.ebiederm.org>
 <20141116133230.GA32030@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 16 Nov 2014 07:42:30 -0800
Message-ID: <CALCETrUPsH_So2Mgk38Fe_pjp5Y+cgjzCUe7fzFcnsFzivHeNA@mail.gmail.com>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 5:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Nov 15, 2014 at 09:08:07PM -0600, Eric W. Biederman wrote:
>>
>> That may be a bug with the user namespace permission check.  Perhaps we
>> shouldn't allow dropping groups that aren't mapped in the user
>> namespace.
>
> I'm not saying that we can't change the behavior of whether or not a
> user can drop a group permission.  I'm just saying that we need to do
> so consciously.  The setgroups()/getgroups() ABI isn't part of
> POSIX/SuSv3 so we wouldn't be breaking POSIX compatibility, for those
> people who care about that.

It may make sense to reach out to some place like oss-security.

FWIW, I think we should ask, at the same time, about:

 - Dropping supplementary groups.
 - Switching gid/egid/sgid to a supplementary group.
 - Denying ptrace of a process with supplementary groups that the
tracer doesn't have.

Also, I much prefer a sysctl to a boot option.  Boot options are nasty
to configure in many distributions.

--Andy

>
> The bigger deal is that it's very different from how BSD 4.x has
> handled things, which means there is two decades of history that we're
> looking at here.  And there are times when taking away permissions in
> an expected fashion can cause security problems.  (As a silly example;
> some architect at Digital wrote a spec that said that setuid must
> return EINVAL for values greater than 32k --- back in the days when
> uid's were a signed short.  The junior programmer who implemented this
> for Ultrix made the check for 32,000 decimal.  Guess what happened
> when /bin/login got a failure with setuid when it wasn't expecting one
> --- since root could never get an error with that system call, right?
> And MIT Project Athena started ran out of lower numbered uid's and
> froshlings started getting assigned uid's > 32,000....)
>
> In this particular case, the change is probably a little less likely
> to cause serious problems, although the fact that sudo does allow
> negative group assignments is an example of another potential
> breakage.
>
> OTOH, I'm aware of how this could cause major problems to the concept
> of allowing an untrusted user to set up their own containers to
> constrain what program with a possibly untrusted provinance might be
> able to do.  I can see times when I might want to run in a container
> where the user didn't have access to groups that I have access to by
> default --- including groups such as disk, sudo, lpadmin, etc.
>
> If we do want to make such a change, my suggestion is to keep things
> *very* simple.  Let it be a boot-time option whether or not users are
> allowed to drop group permissions, and let it affect all possible ways
> that users can drop groups.  And we can create a shell script that
> will search for the obvious ways that a user could get screwed by
> enabling this, which we can encourage distributions to package up for
> their end users.  And then we document the heck out of the fact that
> this option exists, and when/if we want to make it the default, so
> it's perfectly clear and transparent to all what is happening.
>
> One of the things that scare me about the addition of the forced
> capability "setuid" binary was that the feature was just silently slid
> in, and we didn't do a good job reaching out to the tripwire and
> rootkit and other such programs out there, such that several years
> after we enabled capability support, most sysadmins and security
> scanning programs are still apparently obivious to the this very
> convenient feature that we gave to rootkit and malware authors.  Now
> we can say that we're just adding new features, and we owe no debt
> other parts of the ecosystem --- this is the attitude used by upower
> and other freedesktop.org components when they made incompatible
> changes made available by new features provided by systemd[1].
>
> [1] http://m.memegen.com/u7o1tk.jpg
>
> But as kernel developers, who pride ourselves on not breaking
> userspace, I think we should try for a higher standard than this.  And
> perhaps this change with allowing groups to be dropped --- which is
> admittedly a useful thing to be able to allow --- is a good place to
> start trying to model a better way of doing things.  We should try to
> be responsible about how we add new features, and think of all of the
> potential downstream consequences to the _all_ of the ecosystem.
>
>                                          - Ted
>
> P.S.  And we really should try reaching out to the security scanners
> about capabilities, too....



-- 
Andy Lutomirski
AMA Capital Management, LLC
