Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaG3EMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:12:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55504 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaG3EMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:12:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@google.com>,
        David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
	<1406296033-32693-12-git-send-email-drysdale@google.com>
	<CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
	<CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
	<CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com>
	<87vbqhp4hf.fsf@x220.int.ebiederm.org>
	<CALCETrWaUsi1Ea3YTXLN6BFqcoHnbFTuMvcNncS5rq0nSgOatA@mail.gmail.com>
Date: Tue, 29 Jul 2014 21:08:11 -0700
In-Reply-To: <CALCETrWaUsi1Ea3YTXLN6BFqcoHnbFTuMvcNncS5rq0nSgOatA@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 29 Jul 2014 21:05:42 -0700")
Message-ID: <87oaw7ij4k.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/H6yPbj4ROVUJyzCrfUNBH3+NAzpMdUTI=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4879]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Mon, Jul 28, 2014 at 2:18 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> [cc: Eric Biederman]
>>>
>>
>>> Can we do one better and add a flag to prevent any non-self pid
>>> lookups?  This might actually be easy on top of the pid namespace work
>>> (e.g. we could change the way that find_task_by_vpid works).
>>>
>>> It's far from just being signals.  There's access_process_vm, ptrace,
>>> all the signal functions, clock_gettime (see CPUCLOCK_PID -- yes, this
>>> is ridiculous), and probably some others that I've forgotten about or
>>> never noticed in the first place.
>>
>> So here is the practical question.
>>
>> Are these processes that only can send signals to their thread group
>> allowed to call fork()?
>>
>>
>> If fork is allowed and all pid lookups are restricted to their own
>> thread group that wait, waitpid, and all of the rest of the wait family
>> will never return the pids of their children, and zombies will
>> accumulate.  Aka the semantics are fundamentally broken.
>
> Good point.
>
> I can imagine at least three ways that fork() could continue working, though:
>
> 1. Allow lookups of immediate children, too.  (I don't love this one.)
> 2. Allow non-self pids to be translated in but not out.  This way
> P_ALL will continue working.
> 3. Have the kernel treat any PID-restricted process as though it were NOCLDWAIT.
>
> I think I like #3.  Thoughts?
>
>>
>> If fork is not allowed pid namespaces already solve this problem.
>
> PID namespaces are fairly heavyweight.  Julien pointed out that using
> PID namespaces requires a bunch of dummy PID 1 processes.

Only if you can't tolerate init exiting.  The reasoning with respect to
signals and signals being ignored was wrong.  And if you only have one
process you care about and no children to worry about neither the
difference in signal handling nor the world dies whe init exits applies.

Therefore given what I have read described pid namespaces are a trivial
solution to this problem space.

Eric

