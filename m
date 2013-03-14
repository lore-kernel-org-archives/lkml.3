Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3CNVcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:32:33 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52994 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3CNVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <87hakdrai1.fsf@xmission.com>
References: <20130313175729.GH12501@outflux.net> <87r4jjkv18.fsf@xmission.com>
 <51412C67.30908@mit.edu> <87hakdrai1.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 14 Mar 2013 14:32:10 -0700
Message-ID: <CALCETrUiQ+V9kHozA7ySjf3_UswXFkmzFq2eWzKrOW8Yhqh-ZA@mail.gmail.com>
Subject: Re: CLONE_NEWUSER|CLONE_FS root exploit
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, containers@lists.linux-foundation.org,
        Sebastian Krahmer <krahmer@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 1:29 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On 03/13/2013 11:35 AM, Eric W. Biederman wrote:
>>> Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> writes:
>>>
>>>> Hi,
>>>>
>>>> It seem like we should block (at least) this combination. On 3.9, this
>>>> exploit works once uidmapping is added.
>>>>
>>>> http://www.openwall.com/lists/oss-security/2013/03/13/10
>>>
>>> Yes.  That is a bad combination.  It let's chroot confuse privileged
>>> processes.
>>>
>>> Now to figure out if this is easier to squash by adding a user_namespace
>>> to fs_struct or by just forbidding this combination.
>>
>> It's worth making sure that setns(2) doesn't have similar issues.
>
> setns(2) and unshare(2) are done and merged.  See commit.
>
> commit e66eded8309ebf679d3d3c1f5820d1f2ca332c71
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Wed Mar 13 11:51:49 2013 -0700
>
>     userns: Don't allow CLONE_NEWUSER | CLONE_FS
>
>
>> Looking through other shared-but-not-a-namespace things, there are:
>>
>> fs_struct: Buggy as noted.
>>
>> files_struct: Probably harmless -- SCM_RIGHTS can emulate it
>>
>> signal_struct: This interacts with the tty code.  Is it okay?
>
> It should be.  The tty code is heavily pid based, and CLONE_NEWPID
> requires !CLONE_VM (which implies !CLONE_SIGHAND and !CLONE_VM).
>
>> sighand_struct: Looks safe.  Famous last words.
>>
>> FWIW, I've been alarmed in the past that struct path (e.g. the root
>> directory) implies an mnt_namespace (hidden in struct mount), and it's
>> entirely possible for the root directory's mnt_namespace not to match
>> nsproxy->mnt_namespace.  I'm not sure what the implications are, but
>> this doesn't seem healthy.
>
> The calls to check_mnt prevent abuse of the files found with fs_struct
> not matching the current mount namespace.
>
> static inline int check_mnt(struct mount *mnt)
> {
>         return mnt->mnt_ns == current->nsproxy->mnt_ns;
> }
>
> Thanks for looking I know I did the same double take and wondered if I
> had missed anything else by accident when this bug showed up.
>
> So far even just looking it all over again I can't see anything.  But I
> have clearly been blind before.

This is way too fun.  Got another one :/

I'll follow up in a sec off-list.

--Andy
