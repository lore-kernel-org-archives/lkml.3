Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab3B0SO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:14:28 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:53565 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760176Ab3B0SO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:14:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130227180145.GH2071@hansolo.jdub.homelinux.org>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
	<20130227175427.GQ26411@outflux.net>
	<20130227180145.GH2071@hansolo.jdub.homelinux.org>
Date: Wed, 27 Feb 2013 10:14:25 -0800
X-Google-Sender-Auth: Nk2omrxHsgmfd6iOpyfznpVDa-o
Message-ID: <CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:01 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> On Wed, Feb 27, 2013 at 09:54:27AM -0800, Kees Cook wrote:
>> On Fri, Feb 22, 2013 at 01:18:57PM -0500, Josh Boyer wrote:
>> > Originally, the addition of dmesg_restrict covered both the syslog
>> > method of accessing dmesg, as well as /dev/kmsg itself.  This was done
>> > indirectly by security_syslog calling cap_syslog before doing any LSM
>> > checks.
>> >
>> > However, commit 12b3052c3ee (capabilities/syslog: open code cap_syslog
>> > logic to fix build failure) moved the code around and pushed the checks
>> > into the caller itself.  That seems to have inadvertently dropped the
>> > checks for dmesg_restrict on /dev/kmsg.  Most people haven't noticed
>> > because util-linux dmesg(1) defaults to using the syslog method for
>> > access in older versions.  With util-linux 2.22 and a kernel newer than
>> > 3.5, dmesg(1) defaults to reading directly from /dev/kmsg.
>> >
>> > Fix this by making an explicit check in the devkmsg_open function.
>> >
>> > This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192
>> >
>> > Reported-by: Christian Kujau <lists@nerdbynature.de>
>> > CC: stable@vger.kernel.org
>> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
>> > ---
>> >  kernel/printk.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/kernel/printk.c b/kernel/printk.c
>> > index f24633a..398ef9a 100644
>> > --- a/kernel/printk.c
>> > +++ b/kernel/printk.c
>> > @@ -615,6 +615,9 @@ static int devkmsg_open(struct inode *inode, struct file *file)
>> >     struct devkmsg_user *user;
>> >     int err;
>> >
>> > +   if (dmesg_restrict && !capable(CAP_SYSLOG))
>> > +           return -EACCES;
>> > +
>>
>> I think this should use check_syslog_permissions() instead, as done for
>> /proc/kmsg and the syslog syscall.
>>
>>       err = check_syslog_permissions(SYSLOG_ACTION_OPTION, SYSLOG_FROM_FILE);
>
> Did you mean SYSLOG_ACTION_OPEN?

Oops, yes, typo.

> I didn't code it that way because the comment in that function about the
> capability checks already being done seem pretty off to me.  I could
> have just misread the /proc code though.  I can resend with the change
> you suggest if everyone thinks that's a better way.

Yeah, the comment is meaningful if you examine how /proc/kmsg works,
which was basically as a wrapper to the syslog syscall. The issue was
that we had to catch (and potentially block) the "open" action on
/proc/kmsg vs blocking the the syslog read action. In this case, we've
got another file-based interface, so we should use OPEN and FROM_FILE
to block the open. (Though it could be argued that we only want to
block the open if it's reading, which is exactly what Kay was trying
to do originally it looks like.)

> Also, the LSM hooks aren't doing any capability checks at all that I can
> see, which may or may not be a bug in and of itself but I have no idea.
> I was hoping Eric would speak up about that.

Eric explicitly removed the cap check since it was cluttering things
the way it was originally written. I do think security_syslog() should
pass through check_syslog_permissions(), though. Then this wouldn't
have happened. That might actually be the right way to clean this up,
but I'd like to see Eric's thoughts first.

>>       if (err)
>>               return err;
>>
>> And going forward we should probably think about dropping the CAP_SYS_ADMIN
>> backward-compat code in check_syslog_permissions.
>
> Sure, but that's a separate commit.

Yup.

-Kees

-- 
Kees Cook
Chrome OS Security
