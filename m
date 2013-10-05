Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3JEADk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 20:03:40 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:59480 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JEADj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 20:03:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<CA+55aFyCDyGqqbueJtZSUh5JeMcGONy+nW=RXiiouneXuxQ9aA@mail.gmail.com>
Date: Fri, 04 Oct 2013 17:03:23 -0700
In-Reply-To: <CA+55aFyCDyGqqbueJtZSUh5JeMcGONy+nW=RXiiouneXuxQ9aA@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 4 Oct 2013 16:20:10 -0700")
Message-ID: <8761tctwhg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/sRbiHPNHJ4pWpFO7Qhzm1JlQqBum/brc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0042]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Oct 4, 2013 at 3:41 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> After thinking about it removing the restrictions on mount points
>> appears safe, because it is just plain dumb to have a mount point
>> in a directory that is not restricted to root only modifications.
>>
>> This is a change in user visible semantics, so I want to be very careful
>> about this.  Are there any reasons to not make this change?
>
> At least one worry: people are very used to 'rmdir()' not removing
> empty directories, and I've written code myself that just does an
> 'rmdir()' without worrying about it. I think git has code like "remove
> file, then try to remove directory file is in, and recurse until it
> fails or you hit the top of tree". And it all depends on knowing that
> rmdir() is harmless, and returns the appropriate error when the
> directory isn't empty.
>
> And you're now changing that. If it's a mount-point, the rmdir just
> succeeds, afaik.
>
> Does anybody care? I dunno. But it looks like a _big_ semantic change.

Which is definitley why I am asking and being careful.

> That said, I like the _concept_ of being able to remove a mount-point
> and the mount just goes away. But I do think that for sanity sake, it
> should have something like "if one of the mounts is in the current
> namespace, return -EBUSY". IOW, the patch-series would make the VFS
> layer _able_ to remove mount-points, but a normal rmdir() when
> something is mounted in that namespace would fail in order to give
> legacy behavior.
>
> Hmm?

In principle I have no problems tweaking rmdir to check for that case.

At the same time the real reason that this is safe is that mount points
are almost always part of trusted paths to important files and you just
don't mess with those paths.

So tweaking rmdir to fail would be more about making stupid mistakes
like running "rm -rf /" fail than it would be about security or
correctness.

My intuition agrees with yours that it is less surprising if rmdir was
forbidden in mount namespaces where it has a mount.  Root would still be
able to do crazy things like:

# unshare --mount /bin/bash
# umount -l /sys
# mv /proc /sys
# exit
#
# ls /proc
ls: cannot access /proc No such file or directory
#
# ls /sys
1 2 3 4 acpi/ asound/ buddyinfo bus/ cmdline config.gz consoles cpuinfo
crypto devices diskstats dma dir/ driver/ execdomains fb filesystems
fs/ interrupts iomem ioports irq/ kallsyms kcore key-users kmsg
kpagecount kpageflags loadavg locks mdstat meminfo misc modules mounts/
mtrr pagetypeinfo partitions schedstat scsi/ self/ slabinfo softirqs
stat swaps sys/ sysrq-trigger sysvipc/ timer_list tty/ uptime version
vmallocinfo vmstat zoneinfo
#


I just noticed that Al's latest vfs changes posted yesterday mean I need
to rebase and possibly respin these patches, as all of the locking and
interesting bits of the dcache have changed.  I don't think the
conflicts would be fun to resolve during the merge window.

Eric
