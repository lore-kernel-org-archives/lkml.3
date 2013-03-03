Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3CCEMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 23:12:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54015 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3CCEMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 23:12:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kees Cook <keescook@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
Date: Sat, 02 Mar 2013 20:12:22 -0800
In-Reply-To: <20130303005700.GA32213@austin.hallyn.com> (Serge E. Hallyn's
	message of "Sat, 2 Mar 2013 18:57:00 -0600")
Message-ID: <874ngtxgt5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1957SBX3RoQvsQZDe55BSnoFQZrZYX1Fdo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: user ns: arbitrary module loading
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Kees Cook (keescook@google.com):
>> The rearranging done for user ns has resulted in allowing arbitrary
>> kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
>> by what is assumed to be an unprivileged process.
>> 
>> At present, it does look to require at least CAP_SETUID along the way
>> to set up the uidmap (but things like the setuid helper newuidmap
>> might soon start providing such a thing by default).

CAP_SETUID is not needed.

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
> 	mount -t randomfs <...>
>
> in which case do_new_mount() checks ns_capable(), not capable(),
> before trying to load a module for randomfs.
>
> As well as (secondly) the fact that there is no enforcement on
> the format of the module names (i.e. fs-*).
>
> Kees, from what I've seen the GRKERNSEC_MODHARDEN won't be acceptable.
> At least Eric Paris is strongly against it.

What is wrong with GRKERNSEC_MODHARDEN?  It took a quick look and the
code is far from clean.  But that would not be a fundamental objection
from keeping code like that out of the kernel.

It is also entertaining to read security code that won't even build with
CONFIG_UIDGID_STRICT_TYPE_CHECKS enabled.

> But how about if we
> add a check for 'current_user_ns() == &init_user_ns' at that place
> instead?
>
> Eric Biederman, do you have any objections to that?

The obvious solution here is to test for CAP_SYS_ADMIN rather than
current_user_ns == &init_user_ns before we request the module here.  As
that is what was previously required on this path.

Reading the comments the concerns are.
- Non-root users are allowed to load obscure and possibly kernel
  modules.
- get_fs_type can trigger the load of any kernel module.

At a practical level I don't see adding a capalbe(CAP_SYS_ADMIN) check
as having much effect for the functionality currently present in user
namespaces today as the filesystems that an legal to mount in a user
namespace (ramfs, tmpfs, mqueuefs, sysfs, proc, devpts) are so common
most of them can not even be built as modules and even if they are
modules the modules will already be loaded.  So I will see about adding
a capable(CAP_SYS_ADMIN) check to shore things up for the short term.

In the longer term I very much would like to get loopback devices
and mounts of filesystems on those loopback devices working, and being
able to mount filesystems from usb sticks that people commonly plug in,
and remove the need for privileged daemons to do that work.  At that
point manually having to do something that was automatic before will
either mean a regression in functionality or bugs as people manually
load things.


So I am wondering what I a good policy should be.  Should we trust
kernel modules to not be buggy (especially if they were signed as part
of the build process)?  Do we add some defense in depth and add
filesystem registration magic?  Thinking...

We can limit the request_module in get_fs_type to just filesystems
fairly easily.

In include/linux/fs.h:

	#define MODULE_ALIAS_FS(type) MODULE_ALIAS("fs-" __stringify(type))

In fs/filesystems.c:

	if (request_moudle("fs-%.*s", len, name) == 0)

Then just add the appropriate MODULE_ALIAS_FS lines in all of the
filesystems.  This also allows user space to say set the module loading
policy for filesystems using the blacklist and the alias keywords
in /etc/modprobe.d/*.conf.

That seems a whole lot simpler, more powerful and more maintainable than
what little I saw in GRKERNSEC_MODHARDEN to prevent loading of
non-filesystem modules from get_fs_type.

Eric

p.s.  This is the patch I am looking at pushing to Linus in the near
future.

diff --git a/fs/filesystems.c b/fs/filesystems.c
index da165f6..5b0644d 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -273,7 +273,8 @@ struct file_system_type *get_fs_type(const char *name)
        int len = dot ? dot - name : strlen(name);
 
        fs = __get_fs_type(name, len);
-       if (!fs && (request_module("%.*s", len, name) == 0))
+       if (!fs && capable(CAP_SYS_ADMIN) &&
+           (request_module("%.*s", len, name) == 0))
                fs = __get_fs_type(name, len);
 
        if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {



