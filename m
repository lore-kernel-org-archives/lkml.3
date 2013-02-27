Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3B0Uqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:46:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab3B0Uqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:46:51 -0500
Message-ID: <1361998001.2110.22.camel@localhost>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Eric Paris <eparis@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Feb 2013 15:46:41 -0500
In-Reply-To: <CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
	 <20130227175427.GQ26411@outflux.net>
	 <20130227180145.GH2071@hansolo.jdub.homelinux.org>
	 <CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fine Fine, I'll get off my lazy butt and look at this.

On Wed, 2013-02-27 at 10:14 -0800, Kees Cook wrote:
> On Wed, Feb 27, 2013 at 10:01 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> > On Wed, Feb 27, 2013 at 09:54:27AM -0800, Kees Cook wrote:
> >> On Fri, Feb 22, 2013 at 01:18:57PM -0500, Josh Boyer wrote:
> >> > Originally, the addition of dmesg_restrict covered both the syslog
> >> > method of accessing dmesg, as well as /dev/kmsg itself.  This was done
> >> > indirectly by security_syslog calling cap_syslog before doing any LSM
> >> > checks.
> >> >
> >> > However, commit 12b3052c3ee (capabilities/syslog: open code cap_syslog
> >> > logic to fix build failure) moved the code around and pushed the checks
> >> > into the caller itself.  That seems to have inadvertently dropped the
> >> > checks for dmesg_restrict on /dev/kmsg.

Not sure this is correct.  There was no devkmsg_open() in commit
12b3052c3ee.  That was added in e11fea92e.  Looks like before that
commit the devkmsg code was even worse.  It didn't call security_syslog
or capable().  Uggh.

>   Most people haven't noticed
> >> > because util-linux dmesg(1) defaults to using the syslog method for
> >> > access in older versions.  With util-linux 2.22 and a kernel newer than
> >> > 3.5, dmesg(1) defaults to reading directly from /dev/kmsg.
> >> >
> >> > Fix this by making an explicit check in the devkmsg_open function.
> >> >
> >> > This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192
> >> >
> >> > Reported-by: Christian Kujau <lists@nerdbynature.de>
> >> > CC: stable@vger.kernel.org
> >> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> >> > ---
> >> >  kernel/printk.c | 3 +++
> >> >  1 file changed, 3 insertions(+)
> >> >
> >> > diff --git a/kernel/printk.c b/kernel/printk.c
> >> > index f24633a..398ef9a 100644
> >> > --- a/kernel/printk.c
> >> > +++ b/kernel/printk.c
> >> > @@ -615,6 +615,9 @@ static int devkmsg_open(struct inode *inode, struct file *file)
> >> >     struct devkmsg_user *user;
> >> >     int err;
> >> >
> >> > +   if (dmesg_restrict && !capable(CAP_SYSLOG))
> >> > +           return -EACCES;
> >> > +
> >>
> >> I think this should use check_syslog_permissions() instead, as done for
> >> /proc/kmsg and the syslog syscall.
> >>
> >>       err = check_syslog_permissions(SYSLOG_ACTION_OPTION, SYSLOG_FROM_FILE);
> >
> > Did you mean SYSLOG_ACTION_OPEN?
> 
> Oops, yes, typo.
> 
> > I didn't code it that way because the comment in that function about the
> > capability checks already being done seem pretty off to me.  I could
> > have just misread the /proc code though.  I can resend with the change
> > you suggest if everyone thinks that's a better way.
> 
> Yeah, the comment is meaningful if you examine how /proc/kmsg works,
> which was basically as a wrapper to the syslog syscall. The issue was
> that we had to catch (and potentially block) the "open" action on
> /proc/kmsg vs blocking the the syslog read action. In this case, we've
> got another file-based interface, so we should use OPEN and FROM_FILE
> to block the open. (Though it could be argued that we only want to
> block the open if it's reading, which is exactly what Kay was trying
> to do originally it looks like.)

Right.  Now we have /proc/kmsg, /dev/kmsg, and the syscall.  /proc/kmsg
and the syscall both use do_syslog() which calls
check_syslog_permissions() and security_syslog().  /dev/kmsg only calls
security_syslog(), which we all agree needs fixed.

> > Also, the LSM hooks aren't doing any capability checks at all that I can
> > see, which may or may not be a bug in and of itself but I have no idea.
> > I was hoping Eric would speak up about that.

I wouldn't call it a bug.  But it sure is a pretty shitty design pattern
to have security_* sometimes the right thing to do and sometimes
capable() is the right thing to do.  It is pervasive in the kernel that
you have either/or, but I can't think of anywhere that functions are
expected to do BOTH.  So yeah, that needs fixed.

> Eric explicitly removed the cap check since it was cluttering things
> the way it was originally written. I do think security_syslog() should
> pass through check_syslog_permissions(), though. Then this wouldn't
> have happened. That might actually be the right way to clean this up,
> but I'd like to see Eric's thoughts first.

How about something like this?

diff --git a/kernel/printk.c b/kernel/printk.c
index 7c69b3e..ced2cac 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -626,7 +626,7 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
 
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	err = check_syslog_permissions(SYSLOG_ACTION_OPEN, SYSLOG_FROM_FILE);
 	if (err)
 		return err;
 
@@ -840,22 +840,23 @@ static int check_syslog_permissions(int type, bool from_file)
 	 * already done the capabilities checks at open time.
 	 */
 	if (from_file && type != SYSLOG_ACTION_OPEN)
-		return 0;
+		goto ok;
 
 	if (syslog_action_restricted(type)) {
 		if (capable(CAP_SYSLOG))
-			return 0;
+			goto ok;
 		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
 		if (capable(CAP_SYS_ADMIN)) {
 			printk_once(KERN_WARNING "%s (%d): "
 				 "Attempt to access syslog with CAP_SYS_ADMIN "
 				 "but no CAP_SYSLOG (deprecated).\n",
 				 current->comm, task_pid_nr(current));
-			return 0;
+			goto ok;
 		}
 		return -EPERM;
 	}
-	return 0;
+ok:
+	return security_syslog(type);
 }
 
 #if defined(CONFIG_PRINTK_TIME)
@@ -1133,10 +1134,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	if (error)
 		goto out;
 
-	error = security_syslog(type);
-	if (error)
-		return error;
-
 	switch (type) {
 	case SYSLOG_ACTION_CLOSE:	/* Close log */
 		break;


