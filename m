Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3KOE6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:58:31 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54078 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230Ab3KOEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:54:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <878uzmhkqg.fsf@xmission.com> <52749663.2000701@cn.fujitsu.com>
	<527C4D88.10907@cn.fujitsu.com> <87k3gigmgj.fsf@xmission.com>
	<5283299B.8080702@cn.fujitsu.com> <5284AF90.7060506@cn.fujitsu.com>
	<CALCETrXtWtF=JgiwENNzh7UZKnXijHauOQ5ZjHYxYJC-BAU5Aw@mail.gmail.com>
	<528575EC.2030309@cn.fujitsu.com>
Date: Thu, 14 Nov 2013 20:54:10 -0800
In-Reply-To: <528575EC.2030309@cn.fujitsu.com> (Gao feng's message of "Fri, 15
	Nov 2013 09:16:28 +0800")
Message-ID: <87txfexo25.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Mnc14c01t92Z5LXNSp5ACOOqx3dOoLfM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1835]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and sysfs can be mounted
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> On 11/15/2013 12:54 AM, Andy Lutomirski wrote:
>> On Thu, Nov 14, 2013 at 3:10 AM, Gao feng <gaofeng@cn.fujitsu.com> wrote:
>>> On 11/13/2013 03:26 PM, Gao feng wrote:
>>>> On 11/09/2013 01:42 PM, Eric W. Biederman wrote:
>>>>> Right now I would rather not have the empty directory exception than
>>>>> remove this code.
>>>>>
>>>>> The test is a little trickier to write than it might otherwise be
>>>>> because /proc and /sys tend to be slightly imperfect filesystems.
>>>>>
>>>>> I think the only way to really test that is to call readdir on the
>>>>> directory itself :(  I don't like that thought.
>>>>>
>>>>> I don't know what I was thinking when I wrote that test but I definitely
>>>>> goofed up.  Grr!
>>>>>
>>>>> I can certainly filter out any directory with nlink > 2.  That would be
>>>>> an easy partial step forward.
>>>>>
>>>>> The real question though is how do I detect directories it is safe to
>>>>> mount on where there will not be files in them.  I can't call iterate
>>>>> with the namespace_lock held so things are a bit tricky.
>>>>>
>>>>
>>>> I know this problem is not easy to be resolved. why not let the user
>>>> make the decision?  maybe we can introduce a new mount option MS_LOCK,
>>>> if user wants to use mount to hide something, he should use mount with
>>>> option MS_LOCK. so the unpriviged user can't umount this filesystem and
>>>> fail to mount the filesystem if one of it's child mount is mounted with
>>>> MS_LOCK option otherwise he use MS_REC too.
>>>>
>>>
>>> Something like this.
>>>
>>> From 437f33ea366623c7a9d557b2e84cae424876a44f Mon Sep 17 00:00:00 2001
>>> From: Gao feng <gaofeng@cn.fujitsu.com>
>>> Date: Wed, 13 Nov 2013 16:06:46 +0800
>>> Subject: [PATCH] userns: introduce new mount option MS_LOCK
>>>
>>> After commit 5ff9d8a65ce80efb509ce4e8051394e9ed2cd942
>>> vfs: Lock in place mounts from more privileged users,
>>> in userns, the mounts of child mntns which copied from
>>> parent mntns is locked and user has no rights to umount/move
>>> them, it's too strict.
>>>
>>> The core purpose of above commit is trying to prevent
>>> unprivileged user from accessing files hidden by mount.
>>> This patch introduces a new mount option MS_LOCK, this
>>> gives user the capable to mount filesystem as the type
>>> of lock if he wants to use mount to hide something.
>>>
>> 
>> This is bad -- if something was secure in old kernels, it needs to
>> stay secure.  If you had MS_NOT_A_LOCK, that would be okay, but it
>> might not solve your problem.
>> 
>
> what you mean old kernels here? I saw patch "vfs: Lock in place mounts from more privileged users"
> is merged into upstream in linux 3.12-rc1, this is not very old. I think there
> are not many userspace processes rely on this feature.

Sort of true.  Most people aren't that silly.  This feature was added to
defend against a theoretical attack that you can use with mount
namespaces.

In particular the scenario we are concerned with is:

Suppose the file system looks like:

Suppose there are two filesystems a and b that look like:

a:/usr/
a:/usr/my_very_secret_file
a:/dev/
a:/etc/
a:/lib/

b:/bin/
b:/etc/
b:/games/
b:/include/
b:/lib/
b:/lib32/
b:/local/
b:/sbin/
b:/share/
b:/src/

And filesystem b is mounted on a:/usr hiding a:/usr/my_very_secret_file

So the filesystem looks like:

/usr/
/usr/bin/
/usr/etc/
/usr/games/
/usr/include/
/usr/lib/
/usr/lib32/
/usr/local/
/usr/sbin/
/usr/share/
/usr/src/
/dev/
/etc/
/lib/

Without locking mounts into place an unprivileged user can clone the
mount namespace and do "umount /usr" and read /usr/my_very_secret_file.

Most systems don't hide sensitive things with mounts but it is very
possible and guarding against is fairly cheap and easy.  And while a
little annoying it should not be a large impediment to unprivileged user
of the user namespace because pivot root still works.

This thread started talking about bugs in fs_fully_visible.  And those
bugs are fixable and I aim to get to them shortly.  At the very least
I can lie and test for nlink <= 2 which fixes the regression in mounting
proc.

Then I can write the fun version that takes references and drops locks
so it can call the internal version of readdir to see if a directory is
actually empty.

But the principle remains the same we really don't want to reveal
anything that is hidden under a mount on purpose or by mistake.  Just
because then we don't have to think about those things from a security
point of view making everyone's life easier.

Eric
