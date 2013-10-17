Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3JQDxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:53:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54987 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab3JQDxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:53:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jim Lieb <jlieb@panasas.com>, tytso@mit.edu, viro@zeniv.linux.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
	<1381960919-4542-2-git-send-email-jlieb@panasas.com>
	<20131016224248.GQ13318@ZenIV.linux.org.uk>
	<87ppr4lmp3.fsf@xmission.com>
	<20131017012050.GR13318@ZenIV.linux.org.uk>
Date: Wed, 16 Oct 2013 20:52:58 -0700
In-Reply-To: <20131017012050.GR13318@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 17 Oct 2013 02:20:50 +0100")
Message-ID: <87hacgk0yt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX191Px/+uaMPnQz/DPeXW86reeVSkcV/IsA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file server ops
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Oct 16, 2013 at 06:18:16PM -0700, Eric W. Biederman wrote:
>
>> That doesn't look bad but it does need capable(CAP_SETUID) &&
>> capable(CAP_SETGID) or possibly something a little more refined.
>
> D'oh
>
>> I don't think we want file descriptor passing to all of a sudden become
>> a grant of privilege, beyond what the passed fd can do.
>
> Definitely.  And an extra ) to make it compile wouldn't hurt either...

There also appears to need to be a check that we don't gain any
capabilities.

We also need a check so that you don't gain any capabilities, and
possibly a few other things.

So I suspect we want a check something like:

if ((new_cred->securebits != current_cred->securebits)  ||
    (new_cred->cap_inheritable != current_cred->cap_inheritable) ||
    (new_cred->cap_permitted != current_cred->cap_permitted) ||
    (new_cred->cap_effective != current_cred->cap_effective) ||
    (new_cred->cap_bset != current_cred->cap_bset) ||
    (new_cred->jit_keyring != current_cred->jit_keyring) ||
    (new_cred->session_keyring != current_cred->session_keyring) ||
    (new_cred->process_keyring != current_cred->process_keyring) ||
    (new_cred->thread_keyring != current_cred->thread_keyring) ||
    (new_cred->request_keyring != current_cred->request_keyring) ||
    (new_cred->security != current_cred->security) ||
    (new_cred->user_ns != current_cred->user_ns)) {
	return -EPERM;
}

Eric

