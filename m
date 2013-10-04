Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3JDVXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:23:10 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47718 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3JDVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:23:06 -0400
MIME-Version: 1.0
In-Reply-To: <1eefe8cfff2f1edef0c3b5550af3a887@countercultured.net>
References: <20130921225959.GA20388@www.outflux.net>
	<20131003205629.GG5729@outflux.net>
	<1eefe8cfff2f1edef0c3b5550af3a887@countercultured.net>
Date: Fri, 4 Oct 2013 14:23:05 -0700
X-Google-Sender-Auth: d-tDNrU17tOEtbGA6pzltj_RbzQ
Message-ID: <CAGXu5j+ZAsp8tBcxNg4N-wF3New7BrTBGqU_pv3PywPy4j8VuQ@mail.gmail.com>
Subject: Re: [PATCH] LSM: MntRestrict blocks mounts on symlink targets
From: Kees Cook <keescook@chromium.org>
To: David Quigley <dpquigl@davequigley.com>
Cc: Kees Cook <kees@outflux.net>, LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Tyler Hicks <tyhicks@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-security-module-owner@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 9:02 AM, David Quigley <dpquigl@davequigley.com> wrote:
> Why is this an LSM and not something further up in the VFS? Why not make a
> sysctl for this and place it further up in the VFS? Has it already been
> rejected from there? If so why not include it in the things covered by Yama?
> From a code perspective I can't find anything wrong code wise but it seems
> odd to make a security module for something which is clearly a change to VFS
> semantics not really a security module.

There is this proposal:

http://marc.info/?l=linux-fsdevel&m=137876254501993&w=2

But we're looking for a way to disable it across the entire system.
Using the LSM hook proved extremely effective.

-Kees

>
>
> On 10/03/2013 16:56, Kees Cook wrote:
>>
>> Pinging on this too. Any feedback?
>>
>> -Kees
>>
>> On Sat, Sep 21, 2013 at 03:59:59PM -0700, Kees Cook wrote:
>>>
>>> On systems where certain filesystem contents cannot be entirely trusted,
>>> it is beneficial to block mounts on symlinks. This makes sure that
>>> malicious filesystem contents cannot trigger the over-mounting of trusted
>>> filesystems. (For example, a bind-mounted subdirectory of /var cannot be
>>> redirected to mount on /etc via a symlink: a daemon cannot elevate privs
>>> to uid-0.)
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  security/Kconfig                   |    6 ++++
>>>  security/Makefile                  |    2 ++
>>>  security/mntrestrict/Kconfig       |   13 ++++++++
>>>  security/mntrestrict/Makefile      |    1 +
>>>  security/mntrestrict/mntrestrict.c |   63
>>> ++++++++++++++++++++++++++++++++++++
>>>  5 files changed, 85 insertions(+)
>>>  create mode 100644 security/mntrestrict/Kconfig
>>>  create mode 100644 security/mntrestrict/Makefile
>>>  create mode 100644 security/mntrestrict/mntrestrict.c
>>>
>>> diff --git a/security/Kconfig b/security/Kconfig
>>> index e9c6ac7..84d41f4 100644
>>> --- a/security/Kconfig
>>> +++ b/security/Kconfig
>>> @@ -121,6 +121,7 @@ source security/selinux/Kconfig
>>>  source security/smack/Kconfig
>>>  source security/tomoyo/Kconfig
>>>  source security/apparmor/Kconfig
>>> +source security/mntrestrict/Kconfig
>>>  source security/yama/Kconfig
>>>
>>>  source security/integrity/Kconfig
>>> @@ -131,6 +132,7 @@ choice
>>>         default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
>>>         default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
>>>         default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
>>> +       default DEFAULT_SECURITY_MNTRESTRICT if SECURITY_MNTRESTRICT
>>>         default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
>>>         default DEFAULT_SECURITY_DAC
>>>
>>> @@ -150,6 +152,9 @@ choice
>>>         config DEFAULT_SECURITY_APPARMOR
>>>                 bool "AppArmor" if SECURITY_APPARMOR=y
>>>
>>> +       config DEFAULT_SECURITY_MNTRESTRICT
>>> +               bool "MntRestrict" if SECURITY_MNTRESTRICT=y
>>> +
>>>         config DEFAULT_SECURITY_YAMA
>>>                 bool "Yama" if SECURITY_YAMA=y
>>>
>>> @@ -164,6 +169,7 @@ config DEFAULT_SECURITY
>>>         default "smack" if DEFAULT_SECURITY_SMACK
>>>         default "tomoyo" if DEFAULT_SECURITY_TOMOYO
>>>         default "apparmor" if DEFAULT_SECURITY_APPARMOR
>>> +       default "mntrestrict" if DEFAULT_SECURITY_MNTRESTRICT
>>>         default "yama" if DEFAULT_SECURITY_YAMA
>>>         default "" if DEFAULT_SECURITY_DAC
>>>
>>> diff --git a/security/Makefile b/security/Makefile
>>> index c26c81e..33f38b1 100644
>>> --- a/security/Makefile
>>> +++ b/security/Makefile
>>> @@ -7,6 +7,7 @@ subdir-$(CONFIG_SECURITY_SELINUX)       += selinux
>>>  subdir-$(CONFIG_SECURITY_SMACK)                += smack
>>>  subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
>>>  subdir-$(CONFIG_SECURITY_APPARMOR)     += apparmor
>>> +subdir-$(CONFIG_SECURITY_MNTRESTRICT)  += mntrestrict
>>>  subdir-$(CONFIG_SECURITY_YAMA)         += yama
>>>
>>>  # always enable default capabilities
>>> @@ -22,6 +23,7 @@ obj-$(CONFIG_SECURITY_SMACK)          +=
>>> smack/built-in.o
>>>  obj-$(CONFIG_AUDIT)                    += lsm_audit.o
>>>  obj-$(CONFIG_SECURITY_TOMOYO)          += tomoyo/built-in.o
>>>  obj-$(CONFIG_SECURITY_APPARMOR)                += apparmor/built-in.o
>>> +obj-$(CONFIG_SECURITY_MNTRESTRICT)     += mntrestrict/built-in.o
>>>  obj-$(CONFIG_SECURITY_YAMA)            += yama/built-in.o
>>>  obj-$(CONFIG_CGROUP_DEVICE)            += device_cgroup.o
>>>
>>> diff --git a/security/mntrestrict/Kconfig b/security/mntrestrict/Kconfig
>>> new file mode 100644
>>> index 0000000..9a7310d
>>> --- /dev/null
>>> +++ b/security/mntrestrict/Kconfig
>>> @@ -0,0 +1,13 @@
>>> +config SECURITY_MNTRESTRICT
>>> +       bool "Restrict mounts on symlinks system-wide"
>>> +       depends on SECURITY
>>> +       help
>>> +         Enforces that rule that symlinks cannot be used as mount
>>> +         destinations across the entire system. This is to make sure
>>> +         it is never possible to redirect locations using symlinks
>>> +         when the process doing the mount may not be able to strictly
>>> +         trust the contents of the filesystem where it is happening. For
>>> +         example, making sure a bind mounted subdirectory in /var is not
>>> +         redirected into /etc: stops a daemon without full privileges
>>> +         from elevating to uid-0 by tricking the system init filesystem
>>> +         mounting infrastructure.
>>> diff --git a/security/mntrestrict/Makefile
>>> b/security/mntrestrict/Makefile
>>> new file mode 100644
>>> index 0000000..340be1f
>>> --- /dev/null
>>> +++ b/security/mntrestrict/Makefile
>>> @@ -0,0 +1 @@
>>> +obj-$(CONFIG_SECURITY_MNTRESTRICT) += mntrestrict.o
>>> diff --git a/security/mntrestrict/mntrestrict.c
>>> b/security/mntrestrict/mntrestrict.c
>>> new file mode 100644
>>> index 0000000..257ae69
>>> --- /dev/null
>>> +++ b/security/mntrestrict/mntrestrict.c
>>> @@ -0,0 +1,63 @@
>>> +/*
>>> + * Mount Restriction Security Module
>>> + *
>>> + * Copyright 2011-2013 Google Inc.
>>> + *
>>> + * Authors:
>>> + *      Stephan Uphoff  <ups@google.com>
>>> + *      Kees Cook       <keescook@chromium.org>
>>> + *
>>> + * This software is licensed under the terms of the GNU General Public
>>> + * License version 2, as published by the Free Software Foundation, and
>>> + * may be copied, distributed, and modified under those terms.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#define pr_fmt(fmt) "MntRestrict LSM: " fmt
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/security.h>
>>> +#include <linux/sched.h>
>>> +#include <linux/fs.h>
>>> +#include <linux/fs_struct.h>
>>> +#include <linux/mount.h>
>>> +#include <linux/path.h>
>>> +#include <linux/root_dev.h>
>>> +
>>> +static int mntrestrict_sb_mount(const char *dev_name, struct path *path,
>>> +                               const char *type, unsigned long flags,
>>> +                               void *data)
>>> +{
>>> +       int error = current->total_link_count ? -ELOOP : 0;
>>> +
>>> +       if (error) {
>>> +               pr_notice("Mount path with symlinks prohibited -
>>> pid=%d\n",
>>> +                       task_pid_nr(current));
>>> +       }
>>> +
>>> +       return error;
>>> +}
>>> +
>>> +static struct security_operations mntrestrict_ops = {
>>> +       .name   = "mntrestrict",
>>> +       .sb_mount = mntrestrict_sb_mount,
>>> +};
>>> +
>>> +static int __init mntrestrict_init(void)
>>> +{
>>> +       int error;
>>> +
>>> +       error = register_security(&mntrestrict_ops);
>>> +
>>> +       if (error)
>>> +               panic("Could not register MntRestrict security module");
>>> +
>>> +       pr_info("symlink destinations will be blocked.\n");
>>> +
>>> +       return error;
>>> +}
>>> +security_initcall(mntrestrict_init);
>>> --
>>> 1.7.9.5
>>>
>>>
>>> --
>>> Kees Cook
>>> Chrome OS Security
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-security-module" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Kees Cook
Chrome OS Security
