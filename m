Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaHUE6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 00:58:40 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49014 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaHUE6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 00:58:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list\@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
Date: Wed, 20 Aug 2014 21:53:49 -0700
In-Reply-To: <CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
	(Richard Weinberger's message of "Wed, 20 Aug 2014 17:06:59 +0200")
Message-ID: <87vbpm4f4y.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+AvuhsZWCbnPevSdJfir+w0eZ0eIAEHbk=
X-SA-Exim-Connect-IP: 107.0.249.3
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4983]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Richard Weinberger <richard.weinberger@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard.weinberger@gmail.com> writes:

> On Wed, Aug 6, 2014 at 2:57 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> This commit breaks libvirt-lxc.
> libvirt does in lxcContainerMountBasicFS():

The bugs fixed are security issues, so if we have to break a small
number of userspace applications we will.  Anything that we can
reasonably do to avoid regressions will be done.

Could you please look at my user-namespace.git#for-next branch I have a
fix for at least one regresion causing issue in there.  I think it may
fix your issues but I am not fully certain more comments below.

>         /*
>          * We can't immediately set the MS_RDONLY flag when mounting filesystems
>          * because (in at least some kernel versions) this will propagate back
>          * to the original mount in the host OS, turning it readonly too. Thus
>          * we mount the filesystem in read-write mode initially, and then do a
>          * separate read-only bind mount on top of that.
>          */
>         bindOverReadonly = !!(mnt_mflags & MS_RDONLY);
>
>         VIR_DEBUG("Mount %s on %s type=%s flags=%x",
>                   mnt_src, mnt->dst, mnt->type, mnt_mflags & ~MS_RDONLY);
>         if (mount(mnt_src, mnt->dst, mnt->type, mnt_mflags &
> ~MS_RDONLY, NULL) < 0) {
>
> ^^^^ Here it fails for sysfs because with user namespaces we bind the
> existing /sys into the container
> and would have to read out all existing mount flags from the current /sys mount.
> Otherwise mount() fails with EPERM.
> On my test system /sys is mounted with
> "rw,nosuid,nodev,noexec,relatime" and libvirt
> misses the realtime...

Not specifying any atime flags to mount should be safe as that asks for
the default atime flags which for remount I have made the default atime
flags the existing atime flags.  So I am scratching my head a little on
this one.

>
>             virReportSystemError(errno,
>                                  _("Failed to mount %s on %s type %s flags=%x"),
>                                  mnt_src, mnt->dst, NULLSTR(mnt->type),
>                                  mnt_mflags & ~MS_RDONLY);
>             goto cleanup;
>         }
>
>         if (bindOverReadonly &&
>             mount(mnt_src, mnt->dst, NULL,
>                   MS_BIND|MS_REMOUNT|MS_RDONLY, NULL) < 0) {
>
> ^^^ Here it fails because now we'd have to specify all flags as used
> for the first
> mount. For the procfs case MS_NOSUID|MS_NOEXEC|MS_NODEV.
> See lxcBasicMounts[].
> In this case the fix is easy, add mnt_mflags to the mount flags.

That has always been a bug in general because remount has always
required specifying the complete set of mount flags you want to have.

That fact that flags such as nosuid are now properly locked so you can
not change them if you are not the global root user just makes this
obvious.

Andy Lutermorski has observed that statvfs will return the mount flags
making reading them simple.

Eric
