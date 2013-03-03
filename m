Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3CCRsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 12:48:53 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50211 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3CCRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 12:48:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130303035608.GA2703@austin.hallyn.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com>
	<20130303035608.GA2703@austin.hallyn.com>
Date: Sun, 3 Mar 2013 09:48:50 -0800
Message-ID: <CAGXu5jKphNv9+wYE1GwfXKXDdzeWB_AtiqxT0e2PEzqCXNPkfQ@mail.gmail.com>
Subject: Re: user ns: arbitrary module loading
From: Kees Cook <keescook@google.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 7:56 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Kees Cook (keescook@google.com):
>> On Sat, Mar 2, 2013 at 4:57 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> > Quoting Kees Cook (keescook@google.com):
>> >> The rearranging done for user ns has resulted in allowing arbitrary
>> >> kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
>> >> by what is assumed to be an unprivileged process.
>> >>
>> >> At present, it does look to require at least CAP_SETUID along the way
>> >> to set up the uidmap (but things like the setuid helper newuidmap
>> >> might soon start providing such a thing by default).
>> >>
>> >> It might be worth examining GRKERNSEC_MODHARDEN in grsecurity, which
>> >> examines module symbols to verify that request_module() for a
>> >> filesystem only loads a module that defines "register_filesystem"
>> >> (among other things).
>> >>
>> >> -Kees
>> >>
>> >> [1] https://twitter.com/grsecurity/status/307473816672665600
>> >
>> > So the concern is root in a child user namespace doing
>> >
>> >         mount -t randomfs <...>
>> >
>> > in which case do_new_mount() checks ns_capable(), not capable(),
>> > before trying to load a module for randomfs.
>>
>> Well, not just randomfs. Any module that modprobe in the init ns can find.
>
> right
>
>> > As well as (secondly) the fact that there is no enforcement on
>> > the format of the module names (i.e. fs-*).
>> >
>> > Kees, from what I've seen the GRKERNSEC_MODHARDEN won't be acceptable.
>> > At least Eric Paris is strongly against it.
>>
>> I'd be curious to hear the objections. It seems pretty nice to me to
>
> Wait, sorry, I mis-spoke.  The objection would have been to requiring
> CAP_SYS_MODULE, which is different.  Sorry!
>
>> add a new argument to every request_module() that specifies the
>> "subsystem" it expects a module to load from. Maybe pass
>> "request_module=filesystem" or "...=netdev" to the modprobe call. And
>
> That would be useful for adding to the separation of privileges,
> i.e. helping contain the leaking of posix caps.  It sounds good to
> me.
>
>> then in init_module(), check the userargs for which subsystem was
>> requested and look up in a table for the entry point module symbol for
>> that subsystem to require. e.g. for "request_module=filesystem",
>> require that the module contains the "register_filesystem" symbol,
>> etc.
>>
>> > But how about if we
>> > add a check for 'current_user_ns() == &init_user_ns' at that place
>> > instead?
>>
>> Well, we'd need to mostly revert
>> 57eccb830f1cc93d4b506ba306d8dfa685e0c88f ("mount: consolidate
>> permission checks") since get_fs_type() is being called before
>> may_mount() right now. (And then, as you suggest, we should strengthen
>> the test.) I think this will require either more plumbing into
>> get_fs_type (something like "bool load_module_if_missing") or the
>> subsystem verification stuff in request_module. I think the latter is
>> MUCH nicer as it covers this problem in all places, not just this
>> "mount" case.
>
> My first instinct was to say I'd like to have the kernel 100% belonging
> to the init_user_ns, with child user namespaces having zero ability to
> induce loading of any kernel modules, period.  So a check for current
> being in init_user_ns at request_module itself.
>
> However (thinking more) that seems maybe wrong.  You don't need privs to
> induce the loading of a new binfmt module right?  The host's
> /lib/modules and module blacklists should be set up right by the admin
> (or distro)...  If we require that the host admin manually modprobe
> every module which a task in a child user namespace might need, that
> goes counter to the goal of kernel modules.

Several subsystems already have an implicit subsystem restriction
because they load with aliases. (e.g. binfmt-XXXX, net-pf=NNN,
snd-card-NNN, FOO-iosched, etc). This isn't the case for filesystems
and a few others, unfortunately:

$ git grep 'request_module("%.*s"' | grep -vi prefix
crypto/api.c:           request_module("%s", name);
drivers/mtd/chips/chipreg.c:    if (!drv && !request_module("%s", name))
drivers/mtd/mtdpart.c:          if (!parser && !request_module("%s", *types))
drivers/net/wireless/iwlwifi/iwl-drv.c:         request_module("%s", op->name);
drivers/staging/rtl8192e/rtllib_wx.c:           request_module("%s", tempbuf);
fs/filesystems.c:       if (!fs && (request_module("%.*s", len, name) == 0))
net/core/dev_ioctl.c:           if (!request_module("%s", name))

Several of these come from hardcoded values, though (e.g. crypto, chipreg).

>> > Eric Biederman, do you have any objections to that?
>
> -serge

-Kees

--
Kees Cook
Chrome OS Security
