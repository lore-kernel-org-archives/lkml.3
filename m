Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3CCBSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:18:23 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54230 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3CCBSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:18:21 -0500
MIME-Version: 1.0
In-Reply-To: <20130303005700.GA32213@austin.hallyn.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
Date: Sat, 2 Mar 2013 17:18:17 -0800
Message-ID: <CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com>
Subject: Re: user ns: arbitrary module loading
From: Kees Cook <keescook@google.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 4:57 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Kees Cook (keescook@google.com):
>> The rearranging done for user ns has resulted in allowing arbitrary
>> kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
>> by what is assumed to be an unprivileged process.
>>
>> At present, it does look to require at least CAP_SETUID along the way
>> to set up the uidmap (but things like the setuid helper newuidmap
>> might soon start providing such a thing by default).
>>
>> It might be worth examining GRKERNSEC_MODHARDEN in grsecurity, which
>> examines module symbols to verify that request_module() for a
>> filesystem only loads a module that defines "register_filesystem"
>> (among other things).
>>
>> -Kees
>>
>> [1] https://twitter.com/grsecurity/status/307473816672665600
>
> So the concern is root in a child user namespace doing
>
>         mount -t randomfs <...>
>
> in which case do_new_mount() checks ns_capable(), not capable(),
> before trying to load a module for randomfs.

Well, not just randomfs. Any module that modprobe in the init ns can find.

> As well as (secondly) the fact that there is no enforcement on
> the format of the module names (i.e. fs-*).
>
> Kees, from what I've seen the GRKERNSEC_MODHARDEN won't be acceptable.
> At least Eric Paris is strongly against it.

I'd be curious to hear the objections. It seems pretty nice to me to
add a new argument to every request_module() that specifies the
"subsystem" it expects a module to load from. Maybe pass
"request_module=filesystem" or "...=netdev" to the modprobe call. And
then in init_module(), check the userargs for which subsystem was
requested and look up in a table for the entry point module symbol for
that subsystem to require. e.g. for "request_module=filesystem",
require that the module contains the "register_filesystem" symbol,
etc.

> But how about if we
> add a check for 'current_user_ns() == &init_user_ns' at that place
> instead?

Well, we'd need to mostly revert
57eccb830f1cc93d4b506ba306d8dfa685e0c88f ("mount: consolidate
permission checks") since get_fs_type() is being called before
may_mount() right now. (And then, as you suggest, we should strengthen
the test.) I think this will require either more plumbing into
get_fs_type (something like "bool load_module_if_missing") or the
subsystem verification stuff in request_module. I think the latter is
MUCH nicer as it covers this problem in all places, not just this
"mount" case.

> Eric Biederman, do you have any objections to that?
>
> thanks,
> -serge

-Kees

--
Kees Cook
Chrome OS Security
