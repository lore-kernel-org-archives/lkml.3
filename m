Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab3DXUfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:35:21 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63670 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab3DXUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:35:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130424175835.GF15272@hansolo.jdub.homelinux.org>
References: <CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
	<20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
	<20130322221444.GJ15821@hansolo.jdub.homelinux.org>
	<CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
	<1256775981.281402.1364864751771.JavaMail.root@redhat.com>
	<CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
	<20130409005050.GE18176@hansolo.jdub.homelinux.org>
	<20130409154820.GE32476@hansolo.jdub.homelinux.org>
	<CAGXu5jLs1ghuCwcu7crOG1OHuiaP3hmzYY410br_puc9i82-2g@mail.gmail.com>
	<CAPXgP10Vd3Ucxn77WX7wzQoaUmy-JdOBWvYv4zpGSu9qcd=GoQ@mail.gmail.com>
	<20130424175835.GF15272@hansolo.jdub.homelinux.org>
Date: Wed, 24 Apr 2013 13:35:17 -0700
X-Google-Sender-Auth: vvD3NFbgtv4R8VEAJFf3m9CKu40
Message-ID: <CAGXu5jLaQ=Amui3i5+MyG_3HOVnK-1ZoaLqw=jFDwaQCzE+4qw@mail.gmail.com>
Subject: Re: [PATCH v2] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kzak@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 10:58 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> On Wed, Apr 24, 2013 at 07:44:33PM +0200, Kay Sievers wrote:
>> On Tue, Apr 9, 2013 at 6:33 PM, Kees Cook <keescook@chromium.org> wrote:
>> > On Tue, Apr 9, 2013 at 8:48 AM, Josh Boyer <jwboyer@redhat.com> wrote:
>> >> The dmesg_restrict sysctl currently covers the syslog method for access
>> >> dmesg, however /dev/kmsg isn't covered by the same protections.  Most
>> >> people haven't noticed because util-linux dmesg(1) defaults to using the
>> >> syslog method for access in older versions.  With util-linux dmesg(1)
>> >> defaults to reading directly from /dev/kmsg.
>> >>
>> >> Fix this by reworking all of the access methods to use the
>> >> check_syslog_permissions function and adding checks to devkmsg_open and
>> >> devkmsg_read.
>> >>
>> >> This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192
>> >>
>> >> Reported-by: Christian Kujau <lists@nerdbynature.de>
>> >> CC: stable@vger.kernel.org
>> >> Signed-off-by: Eric Paris <eparis@redhat.com>
>> >> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
>> >
>> > Thanks!
>> >
>> > Acked-by: Kees Cook <keescook@chromium.org>
>>
>> If that's the version currently in Fedora, we just cannot do this.
>>    https://bugzilla.redhat.com/show_bug.cgi?id=952655
>>
>> /dev/kmsg is supposed, and was added, to be a sane alternative to
>> syslog(). It is already used in dmesg(1) which is now broken with this
>> patch.
>>
>> The access rules for /dev/kmsg should follow the access rules of
>> syslog(), and not be any stricter.
>
> I haven't tested it yet, but I think something like this should work
> while still honoring dmesg_restrict.  I'll test it out while the rest
> of you debate things.
>
> josh
>
> From: Josh Boyer <jwboyer@redhat.com>
> Date: Tue, 9 Apr 2013 11:08:13 -0400
> Subject: [PATCH v3] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
>
> The dmesg_restrict sysctl currently covers the syslog method for access
> dmesg, however /dev/kmsg isn't covered by the same protections.  Most
> people haven't noticed because util-linux dmesg(1) defaults to using the
> syslog method for access in older versions.  With util-linux dmesg(1)
> defaults to reading directly from /dev/kmsg.
>
> Fix this by reworking all of the access methods to use the
> check_syslog_permissions function and adding checks to devkmsg_open and
> devkmsg_read.
>
> This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192
>
> Reported-by: Christian Kujau <lists@nerdbynature.de>
> CC: stable@vger.kernel.org
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  v3: Allow devkmsg_open to work without CAP_SYSLOG, but still make
>      devkmsg_read honor dmesg_restrict
>
>  kernel/printk.c | 91 +++++++++++++++++++++++++++++----------------------------
>  1 file changed, 47 insertions(+), 44 deletions(-)
>
> diff --git a/kernel/printk.c b/kernel/printk.c
> index abbdd9e..2d7be05 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -368,6 +368,46 @@ static void log_store(int facility, int level,
>         log_next_seq++;
>  }
>
> +#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> +int dmesg_restrict = 1;
> +#else
> +int dmesg_restrict;
> +#endif
> +
> +static int syslog_action_restricted(int type)
> +{
> +       if (dmesg_restrict)
> +               return 1;
> +       /* Unless restricted, we allow "read all" and "get buffer size" for everybody */
> +       return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
> +}
> +
> +static int check_syslog_permissions(int type, bool from_file)
> +{
> +       /*
> +        * If this is from /proc/kmsg and we've already opened it, then we've
> +        * already done the capabilities checks at open time.
> +        */
> +       if (from_file && type != SYSLOG_ACTION_OPEN)
> +               goto ok;
> +
> +       if (syslog_action_restricted(type)) {
> +               if (capable(CAP_SYSLOG))
> +                       goto ok;
> +               /* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
> +               if (capable(CAP_SYS_ADMIN)) {
> +                       printk_once(KERN_WARNING "%s (%d): "
> +                                "Attempt to access syslog with CAP_SYS_ADMIN "
> +                                "but no CAP_SYSLOG (deprecated).\n",
> +                                current->comm, task_pid_nr(current));
> +                       goto ok;
> +               }
> +               return -EPERM;
> +       }
> +ok:
> +       return security_syslog(type);
> +}
> +
>  /* /dev/kmsg - userspace message inject/listen interface */
>  struct devkmsg_user {
>         u64 seq;
> @@ -443,10 +483,16 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>         char cont = '-';
>         size_t len;
>         ssize_t ret;
> +       int err;
>
>         if (!user)
>                 return -EBADF;
>
> +       err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
> +               SYSLOG_FROM_CALL);
> +       if (err)
> +               return err;
> +
>         ret = mutex_lock_interruptible(&user->lock);
>         if (ret)
>                 return ret;
> @@ -624,7 +670,7 @@ static int devkmsg_open(struct inode *inode, struct file *file)
>         if ((file->f_flags & O_ACCMODE) == O_WRONLY)
>                 return 0;
>
> -       err = security_syslog(SYSLOG_ACTION_READ_ALL);
> +       err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL, SYSLOG_FROM_FILE);
>         if (err)
>                 return err;
>
> @@ -817,45 +863,6 @@ static inline void boot_delay_msec(int level)
>  }
>  #endif
>
> -#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> -int dmesg_restrict = 1;
> -#else
> -int dmesg_restrict;
> -#endif
> -
> -static int syslog_action_restricted(int type)
> -{
> -       if (dmesg_restrict)
> -               return 1;
> -       /* Unless restricted, we allow "read all" and "get buffer size" for everybody */
> -       return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
> -}
> -
> -static int check_syslog_permissions(int type, bool from_file)
> -{
> -       /*
> -        * If this is from /proc/kmsg and we've already opened it, then we've
> -        * already done the capabilities checks at open time.
> -        */
> -       if (from_file && type != SYSLOG_ACTION_OPEN)
> -               return 0;
> -
> -       if (syslog_action_restricted(type)) {
> -               if (capable(CAP_SYSLOG))
> -                       return 0;
> -               /* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
> -               if (capable(CAP_SYS_ADMIN)) {
> -                       printk_once(KERN_WARNING "%s (%d): "
> -                                "Attempt to access syslog with CAP_SYS_ADMIN "
> -                                "but no CAP_SYSLOG (deprecated).\n",
> -                                current->comm, task_pid_nr(current));
> -                       return 0;
> -               }
> -               return -EPERM;
> -       }
> -       return 0;
> -}
> -
>  #if defined(CONFIG_PRINTK_TIME)
>  static bool printk_time = 1;
>  #else
> @@ -1131,10 +1138,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>         if (error)
>                 goto out;
>
> -       error = security_syslog(type);
> -       if (error)
> -               return error;
> -
>         switch (type) {
>         case SYSLOG_ACTION_CLOSE:       /* Close log */
>                 break;

So, the problem here is the expectation of privileges. The /proc/kmsg
usage pattern was:

open /proc/kmsg with CAP_SYSLOG
drop CAP_SYSLOG
read /proc/kmsg forever

If we change the FILE vs CALL and OPEN vs READ stuff here, we're lying
to the API about what's happening. If we use this patch, then we can't
use /dev/kmsg in the same way (i.e. running without privileges).

That said, I much prefer doing the privilege test at read time since
that means passing a file descriptor to another process doesn't mean
the new process can just continue reading. If we're going to be
defining the new behavior for /dev/kmsg, then I think we should
explicitly drop the fall-back to CAP_SYS_ADMIN. Perhaps introduce a
"legacy_privs" option to check_syslog_permissions() and leave it set
for do_syslog and cleared for devkmsg_*. This means we can run a
/dev/kmsg reader with _only_ CAP_SYSLOG. (A while back, the original
intent that reworked the permissions here was to avoid needing
CAP_SYS_ADMIN.)

And then maybe we need to rename the from_file to be from_proc (and
similarly SYSLOG_FROM_PROC) too?

-Kees

--
Kees Cook
Chrome OS Security
