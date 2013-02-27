Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666Ab3B0SBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:01:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760335Ab3B0SBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:01:52 -0500
Date: Wed, 27 Feb 2013 13:01:45 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, eparis@redhat.com,
        Christian Kujau <lists@nerdbynature.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130227180145.GH2071@hansolo.jdub.homelinux.org>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
 <20130227175427.GQ26411@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227175427.GQ26411@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:54:27AM -0800, Kees Cook wrote:
> On Fri, Feb 22, 2013 at 01:18:57PM -0500, Josh Boyer wrote:
> > Originally, the addition of dmesg_restrict covered both the syslog
> > method of accessing dmesg, as well as /dev/kmsg itself.  This was done
> > indirectly by security_syslog calling cap_syslog before doing any LSM
> > checks.
> > 
> > However, commit 12b3052c3ee (capabilities/syslog: open code cap_syslog
> > logic to fix build failure) moved the code around and pushed the checks
> > into the caller itself.  That seems to have inadvertently dropped the
> > checks for dmesg_restrict on /dev/kmsg.  Most people haven't noticed
> > because util-linux dmesg(1) defaults to using the syslog method for
> > access in older versions.  With util-linux 2.22 and a kernel newer than
> > 3.5, dmesg(1) defaults to reading directly from /dev/kmsg.
> > 
> > Fix this by making an explicit check in the devkmsg_open function.
> > 
> > This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192
> > 
> > Reported-by: Christian Kujau <lists@nerdbynature.de>
> > CC: stable@vger.kernel.org
> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> > ---
> >  kernel/printk.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index f24633a..398ef9a 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -615,6 +615,9 @@ static int devkmsg_open(struct inode *inode, struct file *file)
> >  	struct devkmsg_user *user;
> >  	int err;
> >  
> > +	if (dmesg_restrict && !capable(CAP_SYSLOG))
> > +		return -EACCES;
> > +
> 
> I think this should use check_syslog_permissions() instead, as done for
> /proc/kmsg and the syslog syscall.
> 
> 	err = check_syslog_permissions(SYSLOG_ACTION_OPTION, SYSLOG_FROM_FILE);

Did you mean SYSLOG_ACTION_OPEN?

I didn't code it that way because the comment in that function about the
capability checks already being done seem pretty off to me.  I could
have just misread the /proc code though.  I can resend with the change
you suggest if everyone thinks that's a better way.

Also, the LSM hooks aren't doing any capability checks at all that I can
see, which may or may not be a bug in and of itself but I have no idea.
I was hoping Eric would speak up about that.

> 	if (err)
> 		return err;
> 
> And going forward we should probably think about dropping the CAP_SYS_ADMIN
> backward-compat code in check_syslog_permissions.

Sure, but that's a separate commit.

josh
