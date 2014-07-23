Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbaGWVAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:00:19 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37415 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933324AbaGWVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <1406148599.3596.3.camel@redhat.com>
References: <1406144186-23002-1-git-send-email-eparis@redhat.com>
	<53D01F2D.8090301@amacapital.net>
	<1406148599.3596.3.camel@redhat.com>
Date: Wed, 23 Jul 2014 14:00:14 -0700
X-Google-Sender-Auth: uXZ1rGI-DtRcrVsopf0zxB7d59k
Message-ID: <CAGXu5jLT2LvKZndT7RaatKcqLrLCDQf4CVr1HUhtHMyP+xftSQ@mail.gmail.com>
Subject: Re: [PATCH] CAPABILITIES: remove undefined caps from all processes
From: Kees Cook <keescook@chromium.org>
To: Eric Paris <eparis@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Steve Grubb <sgrubb@redhat.com>, Dan Walsh <dwalsh@redhat.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 1:49 PM, Eric Paris <eparis@redhat.com> wrote:
> On Wed, 2014-07-23 at 13:46 -0700, Andy Lutomirski wrote:
>> On 07/23/2014 12:36 PM, Eric Paris wrote:
>> > This is effectively a revert of 7b9a7ec565505699f503b4fcf61500dceb36e744
>> > plus fixing it a different way...
>>
>> You sent something like this a couple days ago.  What changed?
>
> right when I sent it I knew I forgot to do the -v2 type stuff.
>
> The new portions are fixes 3 and 4 below.  Which consists of masking
> unknown caps from sys_setcap() and executing files with unknown
> filecaps.

It might be good to add some tools/testing/selftests/ items for this?
Then we can capture the corner cases with in-tree examples.

Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

>
> -Eric
>
>> --Andy
>>
>> >
>> > We found, when trying to run an application from an application which
>> > had dropped privs that the kernel does security checks on undefined
>> > capability bits.  This was ESPECIALLY difficult to debug as those
>> > undefined bits are hidden from /proc/$PID/status.
>> >
>> > Consider a root application which drops all capabilities from ALL 4
>> > capability sets.  We assume, since the application is going to set
>> > eff/perm/inh from an array that it will clear not only the defined caps
>> > less than CAP_LAST_CAP, but also the higher 28ish bits which are
>> > undefined future capabilities.
>> >
>> > The BSET gets cleared differently.  Instead it is cleared one bit at a
>> > time.  The problem here is that in security/commoncap.c::cap_task_prctl()
>> > we actually check the validity of a capability being read.  So any task
>> > which attempts to 'read all things set in bset' followed by 'unset all
>> > things set in bset' will not even attempt to unset the undefined bits
>> > higher than CAP_LAST_CAP.
>> >
>> > So the 'parent' will look something like:
>> > CapInh:     0000000000000000
>> > CapPrm:     0000000000000000
>> > CapEff:     0000000000000000
>> > CapBnd:     ffffffc000000000
>> >
>> > All of this 'should' be fine.  Given that these are undefined bits that
>> > aren't supposed to have anything to do with permissions.  But they do...
>> >
>> > So lets now consider a task which cleared the eff/perm/inh completely
>> > and cleared all of the valid caps in the bset (but not the invalid caps
>> > it couldn't read out of the kernel).  We know that this is exactly what
>> > the libcap-ng library does and what the go capabilities library does.
>> > They both leave you in that above situation if you try to clear all of
>> > you capapabilities from all 4 sets.  If that root task calls execve()
>> > the child task will pick up all caps not blocked by the bset.  The bset
>> > however does not block bits higher than CAP_LAST_CAP.  So now the child
>> > task has bits in eff which are not in the parent.  These are
>> > 'meaningless' undefined bits, but still bits which the parent doesn't
>> > have.
>> >
>> > The problem is now in cred_cap_issubset() (or any operation which does a
>> > subset test) as the child, while a subset for valid cap bits, is not a
>> > subset for invalid cap bits!  So now we set durring commit creds that
>> > the child is not dumpable.  Given it is 'more priv' than its parent.  It
>> > also means the parent cannot ptrace the child and other stupidity.
>> >
>> > The solution here:
>> > 1) stop hiding capability bits in status
>> >     This makes debugging easier!
>> >
>> > 2) stop giving any task undefined capability bits.  it's simple, it you

typo: if/if

>> > don't put those invalid bits in CAP_FULL_SET you won't get them in init
>> > and you won't get them in any other task either.
>> >     This fixes the cap_issubset() tests and resulting fallout (which
>> >     made the init task in a docker container untraceable among other
>> >     things)
>> >
>> > 3) mask out undefined bits when sys_capset() is called as it might use
>> > ~0, ~0 to denote 'all capabilities' for backward/forward compatibility.
>> >     This lets 'capsh --caps="all=eip" -- -c /bin/bash' run.
>> >
>> > 4) mask out undefined bit when we read a file capability off of disk as
>> > again likely all bits are set in the xattr for forward/backward
>> > compatibility.
>> >     This lets 'setcap all+pe /bin/bash; /bin/bash' run
>> >
>> > Signed-off-by: Eric Paris <eparis@redhat.com>
>> > Cc: Andrew Vagin <avagin@openvz.org>
>> > Cc: Andrew G. Morgan <morgan@kernel.org>
>> > Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
>> > Cc: Kees Cook <keescook@chromium.org>
>> > Cc: Steve Grubb <sgrubb@redhat.com>
>> > Cc: Dan Walsh <dwalsh@redhat.com>
>> > Cc: stable@vger.kernel.org
>> > ---
>> >  fs/proc/array.c            | 11 +----------
>> >  include/linux/capability.h |  5 ++++-
>> >  kernel/audit.c             |  2 +-
>> >  kernel/capability.c        |  4 ++++
>> >  security/commoncap.c       |  3 +++
>> >  5 files changed, 13 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/fs/proc/array.c b/fs/proc/array.c
>> > index 64db2bc..3e1290b 100644
>> > --- a/fs/proc/array.c
>> > +++ b/fs/proc/array.c
>> > @@ -297,15 +297,11 @@ static void render_cap_t(struct seq_file *m, const char *header,
>> >     seq_puts(m, header);
>> >     CAP_FOR_EACH_U32(__capi) {
>> >             seq_printf(m, "%08x",
>> > -                      a->cap[(_KERNEL_CAPABILITY_U32S-1) - __capi]);
>> > +                      a->cap[CAP_LAST_U32 - __capi]);
>> >     }
>> >     seq_putc(m, '\n');
>> >  }
>> >
>> > -/* Remove non-existent capabilities */
>> > -#define NORM_CAPS(v) (v.cap[CAP_TO_INDEX(CAP_LAST_CAP)] &= \
>> > -                           CAP_TO_MASK(CAP_LAST_CAP + 1) - 1)
>> > -
>> >  static inline void task_cap(struct seq_file *m, struct task_struct *p)
>> >  {
>> >     const struct cred *cred;
>> > @@ -319,11 +315,6 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>> >     cap_bset        = cred->cap_bset;
>> >     rcu_read_unlock();
>> >
>> > -   NORM_CAPS(cap_inheritable);
>> > -   NORM_CAPS(cap_permitted);
>> > -   NORM_CAPS(cap_effective);
>> > -   NORM_CAPS(cap_bset);
>> > -
>> >     render_cap_t(m, "CapInh:\t", &cap_inheritable);
>> >     render_cap_t(m, "CapPrm:\t", &cap_permitted);
>> >     render_cap_t(m, "CapEff:\t", &cap_effective);
>> > diff --git a/include/linux/capability.h b/include/linux/capability.h
>> > index 84b13ad..aa93e5e 100644
>> > --- a/include/linux/capability.h
>> > +++ b/include/linux/capability.h
>> > @@ -78,8 +78,11 @@ extern const kernel_cap_t __cap_init_eff_set;
>> >  # error Fix up hand-coded capability macro initializers
>> >  #else /* HAND-CODED capability initializers */
>> >
>> > +#define CAP_LAST_U32                       ((_KERNEL_CAPABILITY_U32S) - 1)
>> > +#define CAP_LAST_U32_VALID_MASK            (CAP_TO_MASK(CAP_LAST_CAP + 1) -1)
>> > +
>> >  # define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
>> > -# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
>> > +# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, CAP_LAST_U32_VALID_MASK }})
>> >  # define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0 \
>> >                                 | CAP_TO_MASK(CAP_LINUX_IMMUTABLE), \
>> >                                 CAP_FS_MASK_B1 } })
>> > diff --git a/kernel/audit.c b/kernel/audit.c
>> > index 3ef2e0e..ba2ff5a 100644
>> > --- a/kernel/audit.c
>> > +++ b/kernel/audit.c
>> > @@ -1677,7 +1677,7 @@ void audit_log_cap(struct audit_buffer *ab, char *prefix, kernel_cap_t *cap)
>> >     audit_log_format(ab, " %s=", prefix);
>> >     CAP_FOR_EACH_U32(i) {
>> >             audit_log_format(ab, "%08x",
>> > -                            cap->cap[(_KERNEL_CAPABILITY_U32S-1) - i]);
>> > +                            cap->cap[CAP_LAST_U32 - i]);
>> >     }
>> >  }
>> >
>> > diff --git a/kernel/capability.c b/kernel/capability.c
>> > index a5cf13c..989f5bf 100644
>> > --- a/kernel/capability.c
>> > +++ b/kernel/capability.c
>> > @@ -258,6 +258,10 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
>> >             i++;
>> >     }
>> >
>> > +   effective.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
>> > +   permitted.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
>> > +   inheritable.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
>> > +
>> >     new = prepare_creds();
>> >     if (!new)
>> >             return -ENOMEM;
>> > diff --git a/security/commoncap.c b/security/commoncap.c
>> > index b9d613e..963dc59 100644
>> > --- a/security/commoncap.c
>> > +++ b/security/commoncap.c
>> > @@ -421,6 +421,9 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
>> >             cpu_caps->inheritable.cap[i] = le32_to_cpu(caps.data[i].inheritable);
>> >     }
>> >
>> > +   cpu_caps->permitted.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
>> > +   cpu_caps->inheritable.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
>> > +
>> >     return 0;
>> >  }
>> >
>> >
>>
>
>

Thanks for fixing this!

-Kees

-- 
Kees Cook
Chrome OS Security
