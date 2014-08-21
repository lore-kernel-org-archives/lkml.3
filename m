Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaHUGaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:30:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbaHUGaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:30:05 -0400
Message-ID: <53F591E7.3010509@nod.at>
Date: Thu, 21 Aug 2014 08:29:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com> <87vbpm4f4y.fsf@x220.int.ebiederm.org>
In-Reply-To: <87vbpm4f4y.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.08.2014 06:53, schrieb Eric W. Biederman:
> The bugs fixed are security issues, so if we have to break a small
> number of userspace applications we will.  Anything that we can
> reasonably do to avoid regressions will be done.
> 
> Could you please look at my user-namespace.git#for-next branch I have a
> fix for at least one regresion causing issue in there.  I think it may
> fix your issues but I am not fully certain more comments below.

I'll run this on my LXC testbed today.

>>         /*
>>          * We can't immediately set the MS_RDONLY flag when mounting filesystems
>>          * because (in at least some kernel versions) this will propagate back
>>          * to the original mount in the host OS, turning it readonly too. Thus
>>          * we mount the filesystem in read-write mode initially, and then do a
>>          * separate read-only bind mount on top of that.
>>          */
>>         bindOverReadonly = !!(mnt_mflags & MS_RDONLY);
>>
>>         VIR_DEBUG("Mount %s on %s type=%s flags=%x",
>>                   mnt_src, mnt->dst, mnt->type, mnt_mflags & ~MS_RDONLY);
>>         if (mount(mnt_src, mnt->dst, mnt->type, mnt_mflags &
>> ~MS_RDONLY, NULL) < 0) {
>>
>> ^^^^ Here it fails for sysfs because with user namespaces we bind the
>> existing /sys into the container
>> and would have to read out all existing mount flags from the current /sys mount.
>> Otherwise mount() fails with EPERM.
>> On my test system /sys is mounted with
>> "rw,nosuid,nodev,noexec,relatime" and libvirt
>> misses the realtime...
> 
> Not specifying any atime flags to mount should be safe as that asks for
> the default atime flags which for remount I have made the default atime
> flags the existing atime flags.  So I am scratching my head a little on
> this one.

Okay, let me find out why exactly libvirt gets a EPERM here.
Maybe there are more odds hidden.

>>
>>             virReportSystemError(errno,
>>                                  _("Failed to mount %s on %s type %s flags=%x"),
>>                                  mnt_src, mnt->dst, NULLSTR(mnt->type),
>>                                  mnt_mflags & ~MS_RDONLY);
>>             goto cleanup;
>>         }
>>
>>         if (bindOverReadonly &&
>>             mount(mnt_src, mnt->dst, NULL,
>>                   MS_BIND|MS_REMOUNT|MS_RDONLY, NULL) < 0) {
>>
>> ^^^ Here it fails because now we'd have to specify all flags as used
>> for the first
>> mount. For the procfs case MS_NOSUID|MS_NOEXEC|MS_NODEV.
>> See lxcBasicMounts[].
>> In this case the fix is easy, add mnt_mflags to the mount flags.
> 
> That has always been a bug in general because remount has always
> required specifying the complete set of mount flags you want to have.
> 
> That fact that flags such as nosuid are now properly locked so you can
> not change them if you are not the global root user just makes this
> obvious.
> 
> Andy Lutermorski has observed that statvfs will return the mount flags
> making reading them simple.

Thanks for the clarification, I'll create a fix for libvirt.

Thanks,
//richard
