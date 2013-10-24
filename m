Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3JXGAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 02:00:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36531 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3JXGAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 02:00:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jim Lieb <jlieb@panasas.com>,
        tytso@mit.edu, viro@zeniv.linux.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@redhat.com, jlayton@redhat.com
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
	<1381960919-4542-2-git-send-email-jlieb@panasas.com>
	<20131016224248.GQ13318@ZenIV.linux.org.uk>
	<87ppr4lmp3.fsf@xmission.com>
	<20131017012050.GR13318@ZenIV.linux.org.uk>
	<87hacgk0yt.fsf@xmission.com> <52687468.3060206@mit.edu>
Date: Wed, 23 Oct 2013 22:59:54 -0700
In-Reply-To: <52687468.3060206@mit.edu> (Andy Lutomirski's message of "Wed, 23
	Oct 2013 18:14:16 -0700")
Message-ID: <8761snb44l.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX196ddqDg0gFQFw0Ku4NSI+y3WBCQO3zLBE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0356]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file server ops
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On 10/16/2013 08:52 PM, Eric W. Biederman wrote:
>> Al Viro <viro@ZenIV.linux.org.uk> writes:
>> 
>>> On Wed, Oct 16, 2013 at 06:18:16PM -0700, Eric W. Biederman wrote:
>>>
>>>> That doesn't look bad but it does need capable(CAP_SETUID) &&
>>>> capable(CAP_SETGID) or possibly something a little more refined.
>>>
>>> D'oh
>>>
>>>> I don't think we want file descriptor passing to all of a sudden become
>>>> a grant of privilege, beyond what the passed fd can do.
>>>
>>> Definitely.  And an extra ) to make it compile wouldn't hurt either...
>> 
>> There also appears to need to be a check that we don't gain any
>> capabilities.
>> 
>> We also need a check so that you don't gain any capabilities, and
>> possibly a few other things.
>
> Why?  I like the user_ns part, but I'm not immediately seeing the issue
> with capabilities.

My reasoning was instead of making this syscall as generic as possible
start it out by only allowing the cases Jim cares about and working with
a model where you can't gain any permissions you couldn't gain
otherwise.

Although the fd -1 trick to revert to your other existing cred seems
reasonable.  

>> So I suspect we want a check something like:
>> 
>> if ((new_cred->securebits != current_cred->securebits)  ||
>>     (new_cred->cap_inheritable != current_cred->cap_inheritable) ||
>>     (new_cred->cap_permitted != current_cred->cap_permitted) ||
>>     (new_cred->cap_effective != current_cred->cap_effective) ||
>>     (new_cred->cap_bset != current_cred->cap_bset) ||
>>     (new_cred->jit_keyring != current_cred->jit_keyring) ||
>>     (new_cred->session_keyring != current_cred->session_keyring) ||
>>     (new_cred->process_keyring != current_cred->process_keyring) ||
>>     (new_cred->thread_keyring != current_cred->thread_keyring) ||
>>     (new_cred->request_keyring != current_cred->request_keyring) ||
>>     (new_cred->security != current_cred->security) ||
>>     (new_cred->user_ns != current_cred->user_ns)) {
>> 	return -EPERM;
>> }
>> 
>
> I *really* don't like the idea of being able to use any old file
> descriptor.  I barely care what rights the caller needs to have to
> invoke this -- if you're going to pass an fd that grants a capability
> (in the non-Linux sense of the work), please make sure that the sender
> actually wants that behavior.
>
> IOW, have a syscall to generate a special fd for this purpose.  It's
> only a couple lines of code, and I think we'll really regret it if we
> fsck this up.
>
> (I will take it as a personal challenge to find at least one exploitable
> privilege escalation in this if an arbitrary fd works.)

If you can't switch to a uid or a gid you couldn't switch to otherwise
then the worst that can happen is an information leak.  And information
leaks are rarely directly exploitable.

> Also... real_cred looks confusing.  AFAICS it is used *only* for knfsd
> and faccessat.  That is, current userspace can't see it.  But now you'll
> expose various oddities.  For example, AFAICS a capability-less process
> that's a userns owner can always use setuid.  This will *overwrite*
> real_cred.  Then you're screwed, especially if this happens by
> accident.

And doing in userland what faccessat, and knfsd do in the kernel is
exactly what is desired here.  But maybe there are issues with that.

> That being said, Windows has had functions like this for a long time.
> Processes have a primary token and possibly an impersonation token.  Any
> process can call ImpersonateLoggedOnUser (no privilege required) to
> impersonate the credentials of a token (which is special kind of fd).
> Similarly, any process can call RevertToSelf to undo it.
>
> Is there any actual problem with allowing completely unprivileged tasks
> to switch to one of these magic cred fds?  That would avoid needing a
> "revert" operation.

If the permission model is this switching of credentials doesn't get you
anything you couldn't get some other way.  That would seem to totally
rules out unprivileged processes switching these things.

> Another note: I think that there may be issues if the creator of a token
> has no_new_privs set and the user doesn't.  Imagine a daemon that
> accepts one of these fds, impersonates it, and calls exec.  This could
> be used to escape from no_new_privs land.

Which is why I was suggesting that we don't allow changing any field in
the cred except for uids and gids.

Eric
