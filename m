Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab3HOH4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:56:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39557 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760494Ab3HOH4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:56:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CALCETrUzJjTDT6mxEoQg=cq9jOvw8mn9dLQ=q=qko+oEwkGsVQ@mail.gmail.com>
Date: Thu, 15 Aug 2013 00:55:25 -0700
In-Reply-To: <CALCETrUzJjTDT6mxEoQg=cq9jOvw8mn9dLQ=q=qko+oEwkGsVQ@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 14 Aug 2013 23:52:11 -0700")
Message-ID: <87bo4zfkwi.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18ZF8uWLov+GCbMQJLjoRYAmrURxpMqCl0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: DoS with unprivileged mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Wed, Aug 14, 2013 at 11:45 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Miklos Szeredi <miklos@szeredi.hu> writes:
>>
>> Part of me does prefer the semantics Andy has suggested where instead of
>> unmounting things we have something like a skeleton of the mount tree
>> unioned with dcaches of the filesystems themselves.  With "struct
>> mountpoint" we are amazing close to that already.
>
> Two possible nasty cases:
>
> 1. mount whatever /tmp/foo/bar; rmdir /tmp/foo/bar; rmdir /tmp/foo
>
> Presumably ls /tmp shouldn't show foo.  Should cd /tmp/foo/bar work?
> What about umount /tmp/foo/bar?  What about cd /tmp/foo?

You have to have two mount namespaces or at least two different paths to
to the same filesystem to make this work.  rdir /tmp/foo/bar where
/tmp/foo/bar is a mountpoint in your mount namespace will not work
because you are trying to remove a root directory.

So the semantics I would expect to see if it was implementable is
/tmp/foo and /tmp/foo/bar would continue to exist on the paths where
/tmp/foo/bar was a mount point and would disappear as soon as it was
unmounted.

> 2. mount whatever /tmp/foo; rmdir /tmp/foo; mkdir /tmp/foo
>
> Ugh.

Likewise.  I would expect to see the new /tmp/foo slide under the old
/tmp/foo mountpoint.

Essentially my expectation would be that the mount points would float
over the filesystems.  Semantically I like it, and have played with the
idea before.  Implementation wise shrug I didn't realize any of this was
close to being practically implementatable until today.

Eric
