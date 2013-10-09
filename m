Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3JIXgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:36:17 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51762 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3JIXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:36:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <874n8w1wsz.fsf_-_@xmission.com>
	<20131008155041.GI14242@tucsk.piliscsaba.szeredi.hu>
	<877gdne8pr.fsf@xmission.com> <8761t65kd2.fsf_-_@xmission.com>
	<CALCETrUqXTj7T_bYOgwMiO_kcU=NPD_+ck+Z=JsmXuUJJGshuQ@mail.gmail.com>
Date: Wed, 09 Oct 2013 16:35:56 -0700
In-Reply-To: <CALCETrUqXTj7T_bYOgwMiO_kcU=NPD_+ck+Z=JsmXuUJJGshuQ@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 9 Oct 2013 13:09:17 -0700")
Message-ID: <87ob6yyq3n.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18OZDXbvk8KGrwAfqVULjhwrGCl5Yto9Aw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0103]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: Grrrr fusermount.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Wed, Oct 9, 2013 at 12:12 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> ebiederm@xmission.com (Eric W. Biederman) writes:
>>
>>> But I will go through and read the old fusermount code before I get too
>>> much farther just so I understand what I am potentially breaking.
>>
>> Grr.
>>
>> So I have just read the fusermount umount code and the hack that it uses
>> before there was UMOUNT_NOFOLLOW support in the vm.
>>
>> If I walk this path of lazy unmounts and detaching directories, anyone
>> with a new kernel and an old copy of fusermount and a nfs mounted home
>> directory will be able to exploit the fusermount umount symlink race.
>>
>> Unless we can declare that old fusermount binaries are buggy beyond
>> supporting this patchset as it exists is dead.
>
> What's the hack that it does?

The problem is that "umount -l /some/user/supplied/path" can unmount
anything.

Even after checking mtab etc there are races, and replacing "path" with
a symlink will still allow you to unmount anything.

So when not usering UMOUNT_NOFOLLOW fusermount will do:

cd "/some/user/supplied/"

clone(CLONE_NEWNS)
   mount --make-rprivate /
   COUNT=$(cat /proc/mounts | wc -l)
   mount --rbind . /
   Look at new /proc/mounts entries past $COUNT and see if there is an
     entry for "path"
   if $found
	exit 0
   else
        exit 1
wait
if ($? == 0) umount -l "path"

As everything happens in the directory just below the mount point
we are only concerned about things that happen in that directory.

This does mean there is a window between checking that path is
a valid fuse mount point and when that mountpoint is unmounted.

So if someone can unlink/rename the mount point and replace it
with a symlink during that small window it is possible to unmount
anything.

Today the d_mountpoint tests and the requirement distributed filesystems
(aka nfs) lie to the vfs prevent those issues.

The UMOUNT_NOFOLLOW code which appears in fuse 2.9.0 is new enough that
distro's like CentOS6 don't ship it yet.

Eric


