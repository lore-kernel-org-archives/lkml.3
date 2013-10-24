Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JXBOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 21:14:23 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53982 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3JXBOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 21:14:20 -0400
Message-ID: <52687468.3060206@mit.edu>
Date: Wed, 23 Oct 2013 18:14:16 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: Jim Lieb <jlieb@panasas.com>, tytso@mit.edu, viro@zeniv.linux.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com
Subject: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file server
 ops
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>	<1381960919-4542-2-git-send-email-jlieb@panasas.com>	<20131016224248.GQ13318@ZenIV.linux.org.uk>	<87ppr4lmp3.fsf@xmission.com>	<20131017012050.GR13318@ZenIV.linux.org.uk> <87hacgk0yt.fsf@xmission.com>
In-Reply-To: <87hacgk0yt.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 08:52 PM, Eric W. Biederman wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
>> On Wed, Oct 16, 2013 at 06:18:16PM -0700, Eric W. Biederman wrote:
>>
>>> That doesn't look bad but it does need capable(CAP_SETUID) &&
>>> capable(CAP_SETGID) or possibly something a little more refined.
>>
>> D'oh
>>
>>> I don't think we want file descriptor passing to all of a sudden become
>>> a grant of privilege, beyond what the passed fd can do.
>>
>> Definitely.  And an extra ) to make it compile wouldn't hurt either...
> 
> There also appears to need to be a check that we don't gain any
> capabilities.
> 
> We also need a check so that you don't gain any capabilities, and
> possibly a few other things.

Why?  I like the user_ns part, but I'm not immediately seeing the issue
with capabilities.

> 
> So I suspect we want a check something like:
> 
> if ((new_cred->securebits != current_cred->securebits)  ||
>     (new_cred->cap_inheritable != current_cred->cap_inheritable) ||
>     (new_cred->cap_permitted != current_cred->cap_permitted) ||
>     (new_cred->cap_effective != current_cred->cap_effective) ||
>     (new_cred->cap_bset != current_cred->cap_bset) ||
>     (new_cred->jit_keyring != current_cred->jit_keyring) ||
>     (new_cred->session_keyring != current_cred->session_keyring) ||
>     (new_cred->process_keyring != current_cred->process_keyring) ||
>     (new_cred->thread_keyring != current_cred->thread_keyring) ||
>     (new_cred->request_keyring != current_cred->request_keyring) ||
>     (new_cred->security != current_cred->security) ||
>     (new_cred->user_ns != current_cred->user_ns)) {
> 	return -EPERM;
> }
> 

I *really* don't like the idea of being able to use any old file
descriptor.  I barely care what rights the caller needs to have to
invoke this -- if you're going to pass an fd that grants a capability
(in the non-Linux sense of the work), please make sure that the sender
actually wants that behavior.

IOW, have a syscall to generate a special fd for this purpose.  It's
only a couple lines of code, and I think we'll really regret it if we
fsck this up.

(I will take it as a personal challenge to find at least one exploitable
privilege escalation in this if an arbitrary fd works.)

Also... real_cred looks confusing.  AFAICS it is used *only* for knfsd
and faccessat.  That is, current userspace can't see it.  But now you'll
expose various oddities.  For example, AFAICS a capability-less process
that's a userns owner can always use setuid.  This will *overwrite*
real_cred.  Then you're screwed, especially if this happens by accident.

That being said, Windows has had functions like this for a long time.
Processes have a primary token and possibly an impersonation token.  Any
process can call ImpersonateLoggedOnUser (no privilege required) to
impersonate the credentials of a token (which is special kind of fd).
Similarly, any process can call RevertToSelf to undo it.

Is there any actual problem with allowing completely unprivileged tasks
to switch to one of these magic cred fds?  That would avoid needing a
"revert" operation.


Another note: I think that there may be issues if the creator of a token
has no_new_privs set and the user doesn't.  Imagine a daemon that
accepts one of these fds, impersonates it, and calls exec.  This could
be used to escape from no_new_privs land.

--Andy
