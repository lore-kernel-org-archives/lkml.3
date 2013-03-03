Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3CCDz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 22:55:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3CCDz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 22:55:28 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=e0MqpSAjzYYA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=5vcxqjp_onUA:10 a=1XWaLZrsAAAA:8 a=JqEG_dyiAAAA:8 a=NEEs1hzLSURUDejK5wwA:9 a=CjuIK1q_8ugA:10 a=UTB_XpHje0EA:10 a=4gZ4WExUoD4A:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Sat, 2 Mar 2013 21:56:08 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <keescook@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: user ns: arbitrary module loading
Message-ID: <20130303035608.GA2703@austin.hallyn.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
 <20130303005700.GA32213@austin.hallyn.com>
 <CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@google.com):
> On Sat, Mar 2, 2013 at 4:57 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Kees Cook (keescook@google.com):
> >> The rearranging done for user ns has resulted in allowing arbitrary
> >> kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
> >> by what is assumed to be an unprivileged process.
> >>
> >> At present, it does look to require at least CAP_SETUID along the way
> >> to set up the uidmap (but things like the setuid helper newuidmap
> >> might soon start providing such a thing by default).
> >>
> >> It might be worth examining GRKERNSEC_MODHARDEN in grsecurity, which
> >> examines module symbols to verify that request_module() for a
> >> filesystem only loads a module that defines "register_filesystem"
> >> (among other things).
> >>
> >> -Kees
> >>
> >> [1] https://twitter.com/grsecurity/status/307473816672665600
> >
> > So the concern is root in a child user namespace doing
> >
> >         mount -t randomfs <...>
> >
> > in which case do_new_mount() checks ns_capable(), not capable(),
> > before trying to load a module for randomfs.
> 
> Well, not just randomfs. Any module that modprobe in the init ns can find.

right

> > As well as (secondly) the fact that there is no enforcement on
> > the format of the module names (i.e. fs-*).
> >
> > Kees, from what I've seen the GRKERNSEC_MODHARDEN won't be acceptable.
> > At least Eric Paris is strongly against it.
> 
> I'd be curious to hear the objections. It seems pretty nice to me to

Wait, sorry, I mis-spoke.  The objection would have been to requiring
CAP_SYS_MODULE, which is different.  Sorry!

> add a new argument to every request_module() that specifies the
> "subsystem" it expects a module to load from. Maybe pass
> "request_module=filesystem" or "...=netdev" to the modprobe call. And

That would be useful for adding to the separation of privileges,
i.e. helping contain the leaking of posix caps.  It sounds good to
me.

> then in init_module(), check the userargs for which subsystem was
> requested and look up in a table for the entry point module symbol for
> that subsystem to require. e.g. for "request_module=filesystem",
> require that the module contains the "register_filesystem" symbol,
> etc.
> 
> > But how about if we
> > add a check for 'current_user_ns() == &init_user_ns' at that place
> > instead?
> 
> Well, we'd need to mostly revert
> 57eccb830f1cc93d4b506ba306d8dfa685e0c88f ("mount: consolidate
> permission checks") since get_fs_type() is being called before
> may_mount() right now. (And then, as you suggest, we should strengthen
> the test.) I think this will require either more plumbing into
> get_fs_type (something like "bool load_module_if_missing") or the
> subsystem verification stuff in request_module. I think the latter is
> MUCH nicer as it covers this problem in all places, not just this
> "mount" case.

My first instinct was to say I'd like to have the kernel 100% belonging
to the init_user_ns, with child user namespaces having zero ability to
induce loading of any kernel modules, period.  So a check for current
being in init_user_ns at request_module itself.

However (thinking more) that seems maybe wrong.  You don't need privs to
induce the loading of a new binfmt module right?  The host's
/lib/modules and module blacklists should be set up right by the admin
(or distro)...  If we require that the host admin manually modprobe
every module which a task in a child user namespace might need, that
goes counter to the goal of kernel modules.

> > Eric Biederman, do you have any objections to that?

-serge
