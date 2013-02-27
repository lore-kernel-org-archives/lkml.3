Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3B0Weq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:34:46 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52831 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3B0Wep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:34:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130227221954.GJ2071@hansolo.jdub.homelinux.org>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
	<20130227175427.GQ26411@outflux.net>
	<20130227180145.GH2071@hansolo.jdub.homelinux.org>
	<CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
	<1361998001.2110.22.camel@localhost>
	<20130227221954.GJ2071@hansolo.jdub.homelinux.org>
Date: Wed, 27 Feb 2013 14:34:43 -0800
X-Google-Sender-Auth: dn64VrE3a9K8KevilgdXmoRQwsc
Message-ID: <CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 2:19 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> On Wed, Feb 27, 2013 at 03:46:41PM -0500, Eric Paris wrote:
>> Fine Fine, I'll get off my lazy butt and look at this.
>
> Shock!
>
>> Right.  Now we have /proc/kmsg, /dev/kmsg, and the syscall.  /proc/kmsg
>> and the syscall both use do_syslog() which calls
>> check_syslog_permissions() and security_syslog().  /dev/kmsg only calls
>> security_syslog(), which we all agree needs fixed.
>>
>> > > Also, the LSM hooks aren't doing any capability checks at all that I can
>> > > see, which may or may not be a bug in and of itself but I have no idea.
>> > > I was hoping Eric would speak up about that.
>>
>> I wouldn't call it a bug.  But it sure is a pretty shitty design pattern
>> to have security_* sometimes the right thing to do and sometimes
>> capable() is the right thing to do.  It is pervasive in the kernel that
>> you have either/or, but I can't think of anywhere that functions are
>> expected to do BOTH.  So yeah, that needs fixed.
>
> OK.
>
>>
>> > Eric explicitly removed the cap check since it was cluttering things
>> > the way it was originally written. I do think security_syslog() should
>> > pass through check_syslog_permissions(), though. Then this wouldn't
>> > have happened. That might actually be the right way to clean this up,
>> > but I'd like to see Eric's thoughts first.
>>
>> How about something like this?
>
> I think this looks pretty good.  Much clearer overall and the
> consolidation is nice.  I'll try to get it tested soon.
>
> josh
>
>>
>> diff --git a/kernel/printk.c b/kernel/printk.c
>> index 7c69b3e..ced2cac 100644
>> --- a/kernel/printk.c
>> +++ b/kernel/printk.c
>> @@ -626,7 +626,7 @@ static int devkmsg_open(struct inode *inode, struct file *file)
>>       if ((file->f_flags & O_ACCMODE) == O_WRONLY)
>>               return 0;
>>
>> -     err = security_syslog(SYSLOG_ACTION_READ_ALL);
>> +     err = check_syslog_permissions(SYSLOG_ACTION_OPEN, SYSLOG_FROM_FILE);

Yes, this looks correct with the consolidation below. Nice!

>>       if (err)
>>               return err;
>>
>> @@ -840,22 +840,23 @@ static int check_syslog_permissions(int type, bool from_file)
>>        * already done the capabilities checks at open time.
>>        */
>>       if (from_file && type != SYSLOG_ACTION_OPEN)
>> -             return 0;
>> +             goto ok;
>>
>>       if (syslog_action_restricted(type)) {
>>               if (capable(CAP_SYSLOG))
>> -                     return 0;
>> +                     goto ok;
>>               /* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
>>               if (capable(CAP_SYS_ADMIN)) {
>>                       printk_once(KERN_WARNING "%s (%d): "
>>                                "Attempt to access syslog with CAP_SYS_ADMIN "
>>                                "but no CAP_SYSLOG (deprecated).\n",
>>                                current->comm, task_pid_nr(current));
>> -                     return 0;
>> +                     goto ok;
>>               }
>>               return -EPERM;
>>       }
>> -     return 0;
>> +ok:
>> +     return security_syslog(type);
>>  }
>>
>>  #if defined(CONFIG_PRINTK_TIME)
>> @@ -1133,10 +1134,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>>       if (error)
>>               goto out;
>>
>> -     error = security_syslog(type);
>> -     if (error)
>> -             return error;
>> -
>>       switch (type) {
>>       case SYSLOG_ACTION_CLOSE:       /* Close log */
>>               break;
>>
>>

I think for completeness, we need to add a
check_syslog_permissions(SYSLOG_ACTION_READ_ALL, SYSLOG_FROM_FILE)
call to devkmsg_read().

-Kees

-- 
Kees Cook
Chrome OS Security
