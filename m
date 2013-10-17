Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948Ab3JQBSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:18:39 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60642 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887Ab3JQBSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:18:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jim Lieb <jlieb@panasas.com>, tytso@mit.edu, viro@zeniv.linux.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
	<1381960919-4542-2-git-send-email-jlieb@panasas.com>
	<20131016224248.GQ13318@ZenIV.linux.org.uk>
Date: Wed, 16 Oct 2013 18:18:16 -0700
In-Reply-To: <20131016224248.GQ13318@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 16 Oct 2013 23:42:48 +0100")
Message-ID: <87ppr4lmp3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18RJBQuE3mjhDhjScq0YzhpzyQhoEHZ2OU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0257]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file server ops
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Oct 16, 2013 at 03:01:57PM -0700, Jim Lieb wrote:
>> File servers must do some operations with the credentials of
>> their client.  This syscall switches the key credentials similar
>> to nfsd_setuser() in fs/nfsd/auth.c  with the capability of retaining a
>> handle to the credentials by way of an fd for an open anonymous file.
>> This makes switching for subsequent operations for that client more efficient.
>
> 	Yet Another Untyped Multiplexor.  Inna bun.  Onna stick.
> CMOT Dibbler special...
>
> 	Switching creds to those of opener of given file descriptor
> is fine, but in any realistic situation you'll get all the real win
> from that - you should cache those fds (which you seem to do), and
> then setuid/etc. is done once per cache miss.  Making the magical
> "set them all at once" mess (complete with non-trivial structure,
> 32/64bit compat, etc.) pointless.  Moreover, you don't need any magic
> files at all - just set the creds and open /dev/null and there's your fd.
> With proper creds associated with it.  While we are at it, just _start_
> with opening /dev/null.  With your initial creds.  Voila - revert is
> simply switch to that fd's creds.
>
> 	IOW, you really need only one syscall:

That doesn't look bad but it does need capable(CAP_SETUID) &&
capable(CAP_SETGID) or possibly something a little more refined.

I don't think we want file descriptor passing to all of a sudden become
a grant of privilege, beyond what the passed fd can do.

> SYSCALL_DEFINE1(switch_cred, int, fd)
> {
> 	struct fd f = fdget(fd);
> 	if (!f.file)
> 		return -EBADF;
> 	put_cred(override_creds(f.file->f_cred);
> 	fdput(f);
> 	return 0;
> }
>
> and that's all there is to it.

Eric
