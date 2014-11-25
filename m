Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaKYSoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:44:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49422 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaKYSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:44:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
References: <20141124200629.GA21009@redhat.com>
	<87vbm4ff0r.fsf@x220.int.ebiederm.org>
	<20141125170718.GA29360@redhat.com>
	<87lhmzb24c.fsf@x220.int.ebiederm.org>
	<20141125181521.GA31963@redhat.com>
Date: Tue, 25 Nov 2014 12:43:15 -0600
In-Reply-To: <20141125181521.GA31963@redhat.com> (Oleg Nesterov's message of
	"Tue, 25 Nov 2014 19:15:21 +0100")
Message-ID: <87wq6j9l4s.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18WRN2pF2kKA3HPZdScnO30w2SdmZoYBR8=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 383 ms - load_scoreonly_sql: 0.09 (0.0%),
	signal_user_changed: 2.9 (0.8%), b_tie_ro: 1.99 (0.5%), parse: 1.15 (0.3%),
	extract_message_metadata: 5 (1.4%), get_uri_detail_list: 3.1 (0.8%),
	tests_pri_-1000: 3.5 (0.9%), tests_pri_-950: 1.32 (0.3%), tests_pri_-900:
	1.10 (0.3%), tests_pri_-400: 36 (9.5%), check_bayes: 35 (9.1%), b_tokenize: 7
	(1.8%), b_tok_get_all: 13 (3.3%), b_comp_prob: 4.6 (1.2%), b_tok_touch_all: 6
	(1.5%), b_finish: 2.4 (0.6%), tests_pri_0: 312 (81.5%), tests_pri_500: 7
	(1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 11/25, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > On 11/24, Eric W. Biederman wrote:
>> >>
>> >> However at the moment my I can't figure out if it is safe to move
>> >> get_pid_ns elow hlist_add_head_rcu.  Because once we are on the rcu list
>> >> the pid is findable, and being publicly visible with a bad refcount could cause
>> >> problems.
>> >
>> > The caller has a reference, this ns can't go away. Obviously, otherwise
>> > get_pid_ns(ns) is not safe.
>> >
>> > We need this get_pid_ns() to balance put_pid()->put_pid_ns() which obviously
>> > won't be called until we return this pid, otherwise everything is wrong.
>> >
>> > So I think this should be safe?
>>
>> My concern is exposing a half initialized struct pid to the world via an
>> rcu data structure.  In particular could one of the rcu users get into
>> trouble because we haven't called get_pid_ns yet?  That is unclear to me.
>
> They can't. This pid was fully initialized, in particular
> pid->numbers[pid->level].ns == ns has a reference.
>
> Just it is not ready for put_pid() which will be called by the "owner" of
> this pid, the caller or the new child. So in this sense it doesn't matter
> when we call get_pid_ns(), just we need to do this before return.

Or by someone calling find_get_pid() ... put_pid().

Now the reference count should not hit zero in that case but I hate to
think of that case separately.

>> That is one of those weird nasty races I would rather not have to
>> consider and moving the get_pid_ns after hlist_add requires that we
>> think about it.
>>
>> To fix the error handling and avoid thinking about the races we have two
>> choices:
>> - In the error path that is currently called out_unlock we can drop the
>>   extra references.
>> - Immediately after we perform the test that on error jumps to out_unlock
>>   we call get_pid_ns.
>>
>> My preference would be the first, as it is a trivially correct one line
>> change.
>>
>> Aka I think this is the obviously correct trivial fix.
>>
>>  out_unlock:
>>  	spin_unlock_irq(&pidmap_lock);
>> +	put_pid_ns(ns);
>
> Sure, initially I was going to do this. But this is sub-optimal imo, I mainly
> mean less clear (imho).
>
> But again, I won't argue. I'll send V2 once we finish the discussion
> about 2/2.

At this point, and especially since we need to Cc stable and get this
fix backported to who knows how many kernel releases having something
that is trivial to validate is correct is important.

If you prefer to call get_pid_ns() immedately after:

	if (!(ns->nr_hashed & PIDNS_HASH_ADDING))
		goto out_unlock;

That would be fine with me as well.

Anything else to too clever for my brain to verify is correct today.

Eric

