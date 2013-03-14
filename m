Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab3CNU3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:29:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42582 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3CNU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:29:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, containers@lists.linux-foundation.org,
        Sebastian Krahmer <krahmer@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20130313175729.GH12501@outflux.net> <87r4jjkv18.fsf@xmission.com>
	<51412C67.30908@mit.edu>
Date: Thu, 14 Mar 2013 13:29:10 -0700
In-Reply-To: <51412C67.30908@mit.edu> (Andy Lutomirski's message of "Wed, 13
	Mar 2013 18:48:23 -0700")
Message-ID: <87hakdrai1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+wUn5/TpXEB8C7gcw0VvVz2R8nYcxa2lo=
X-SA-Exim-Connect-IP: 208.54.5.196
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: CLONE_NEWUSER|CLONE_FS root exploit
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On 03/13/2013 11:35 AM, Eric W. Biederman wrote:
>> Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> writes:
>> 
>>> Hi,
>>>
>>> It seem like we should block (at least) this combination. On 3.9, this
>>> exploit works once uidmapping is added.
>>>
>>> http://www.openwall.com/lists/oss-security/2013/03/13/10
>> 
>> Yes.  That is a bad combination.  It let's chroot confuse privileged
>> processes.
>> 
>> Now to figure out if this is easier to squash by adding a user_namespace
>> to fs_struct or by just forbidding this combination.
>
> It's worth making sure that setns(2) doesn't have similar issues.

setns(2) and unshare(2) are done and merged.  See commit.

commit e66eded8309ebf679d3d3c1f5820d1f2ca332c71
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Wed Mar 13 11:51:49 2013 -0700

    userns: Don't allow CLONE_NEWUSER | CLONE_FS


> Looking through other shared-but-not-a-namespace things, there are:
>
> fs_struct: Buggy as noted.
>
> files_struct: Probably harmless -- SCM_RIGHTS can emulate it
>
> signal_struct: This interacts with the tty code.  Is it okay?

It should be.  The tty code is heavily pid based, and CLONE_NEWPID
requires !CLONE_VM (which implies !CLONE_SIGHAND and !CLONE_VM).

> sighand_struct: Looks safe.  Famous last words.
>
> FWIW, I've been alarmed in the past that struct path (e.g. the root
> directory) implies an mnt_namespace (hidden in struct mount), and it's
> entirely possible for the root directory's mnt_namespace not to match
> nsproxy->mnt_namespace.  I'm not sure what the implications are, but
> this doesn't seem healthy.

The calls to check_mnt prevent abuse of the files found with fs_struct
not matching the current mount namespace.

static inline int check_mnt(struct mount *mnt)
{
	return mnt->mnt_ns == current->nsproxy->mnt_ns;
}

Thanks for looking I know I did the same double take and wondered if I
had missed anything else by accident when this bug showed up.

So far even just looking it all over again I can't see anything.  But I
have clearly been blind before.

Eric


