Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3J3F3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:29:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:41740 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3J3F3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:29:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131029220939.GA23060@kroah.com>
	<8761sflhi1.fsf@tw-ebiederman.twitter.com>
	<CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
Date: Tue, 29 Oct 2013 22:29:43 -0700
In-Reply-To: <CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 29 Oct 2013 18:25:53 -0700")
Message-ID: <87sivj9vi0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/3h0CTUfsPZTWIUI4o+UNkiYtJikIznPE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysfs: move assignment to be under lock in sysfs_remove_dir()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Oct 29, 2013 at 5:39 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> I don't have a strong feeling either way but how would that matter?
>> There is only ever one sd associated with a kobj.
>
> What does that matter? If you have multiple callers, they might try to
> free that one sd twice, since they could both see a non-NULL case.

>> And we better be under the sysfs_mutex when the assignment and and
>> sysfs_remove_dir are called.
>
> Not as far as I can tell. kobject_del() calls sysfs_remove_dir(), and
> I'm not seeing why that would be under the mutex.  The only locking I
> see is that sysfs_assoc_lock, which _isn't_ held for the reading of
> kobj->sd.
>
> Now, there may be other reasons for this all working (like the fact
> that only one user ever calls kobject_del() on any particular object,
> but it sure as hell isn't obvious. The fact that you seem to be
> confused about this only proves my point.

I never actually looked deeply into it, and I was working from several
year old memory and a quick skim of the patch when I asked the question.

The protection we have previous to this patch is that syfs_remove_dir is
only sane to call once.

Which makes the code that does:
	if (!dir_sd)
        	return;
in __sysfs_remove_dir very suspicious.   I expect we want a
WARN_ON(!dir_sd);

But the entire directory removal process and working on sysfs stopped
being fun before I managed to get that cleaned up.  And unless I missed
something go by Tejun is going to go generalize this thing before this
bit gets cleaned up.  Sigh.

> Besides, the "design pattern" of having a lock for the assignment, but
> then reading the value without that lock seems to be all kinds of
> f*cking stupid, wouldn't you agree? I'm really not seeing how that
> could _ever_ be something you make excuses for in the first place.
> Even if there is some external locking (which, as far as I can tell,
> there is not), that would just raise the question as to what reason
> that spinlock has to exist at all.

I wasn't making excuses I was just trying to understand the reasoning
for this little patch flying through my inbox.

On an equally bizarre note.  I don't understand why we have a separate
spinlock there.  Looks...  Sigh.  We use a different lock from
everything as a premature optimization so that sysfs_remove_dir could be
modified to just take a sysfs_dirent, and all of the kobject handling
could be removed.

Sigh. It was never in my way and while I was working on the code that
there was a good locking reason for doing that silly thing.

> The code doesn't make any sense with the locking the way it is now. It
> might _work_, of course, but it sure as hell doesn't make sense.

In net I agree.

Eric





