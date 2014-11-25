Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaKYRwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:52:19 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53464 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaKYRwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:52:17 -0500
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
Date: Tue, 25 Nov 2014 11:50:59 -0600
In-Reply-To: <20141125170718.GA29360@redhat.com> (Oleg Nesterov's message of
	"Tue, 25 Nov 2014 18:07:18 +0100")
Message-ID: <87lhmzb24c.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19/Lob7BE2q9jvFeafsfl1tDOR+U5si2SU=
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
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 431 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.7 (0.8%), b_tie_ro: 2.8 (0.7%), parse: 1.13 (0.3%),
	extract_message_metadata: 5 (1.2%), get_uri_detail_list: 2.9 (0.7%),
	tests_pri_-1000: 5 (1.2%), tests_pri_-950: 1.93 (0.4%), tests_pri_-900: 1.57
	(0.4%), tests_pri_-400: 36 (8.4%), check_bayes: 34 (8.0%), b_tokenize: 10
	(2.3%), b_tok_get_all: 8 (2.0%), b_comp_prob: 3.6 (0.8%), b_tok_touch_all: 9
	(2.0%), b_finish: 0.77 (0.2%), tests_pri_0: 357 (83.0%), tests_pri_500: 4.7
	(1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 11/24, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > --- a/kernel/pid.c
>> > +++ b/kernel/pid.c
>> > @@ -320,7 +320,6 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>> >  			goto out_free;
>> >  	}
>> >
>> > -	get_pid_ns(ns);
>> >  	atomic_set(&pid->count, 1);
>> >  	for (type = 0; type < PIDTYPE_MAX; ++type)
>> >  		INIT_HLIST_HEAD(&pid->tasks[type]);
>> > @@ -336,7 +335,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>> >  	}
>> >  	spin_unlock_irq(&pidmap_lock);
>> >
>> > -out:
>> > +	get_pid_ns(ns);
>>
>> Moving the label and changing the goto out logic is gratuitous confusing
>> and I think it probably even generates worse code.
>>
>> Furthermore multiple exits make adding debugging code more difficult.
>
> Oh, I strongly disagree but I am not going to argue ;) cleanups are
> always subjective, and I do believe in "maintainer is always right"
> mantra. I can make v2 without this change.

Fair enough.  My primary complaint was that you were changing the logic
and fixing a bug at the same time.  That added noise and made analysis
of what was really going on much more difficult.

>> Moving get_pid_ns down does close a leak in the error handling path.
>
> OK, good.
>
>> However at the moment my I can't figure out if it is safe to move
>> get_pid_ns elow hlist_add_head_rcu.  Because once we are on the rcu list
>> the pid is findable, and being publicly visible with a bad refcount could cause
>> problems.
>
> The caller has a reference, this ns can't go away. Obviously, otherwise
> get_pid_ns(ns) is not safe.
>
> We need this get_pid_ns() to balance put_pid()->put_pid_ns() which obviously
> won't be called until we return this pid, otherwise everything is wrong.
>
> So I think this should be safe?

My concern is exposing a half initialized struct pid to the world via an
rcu data structure.  In particular could one of the rcu users get into
trouble because we haven't called get_pid_ns yet?  That is unclear to me.

That is one of those weird nasty races I would rather not have to
consider and moving the get_pid_ns after hlist_add requires that we
think about it.

To fix the error handling and avoid thinking about the races we have two
choices:
- In the error path that is currently called out_unlock we can drop the
  extra references.
- Immediately after we perform the test that on error jumps to out_unlock
  we call get_pid_ns.

My preference would be the first, as it is a trivially correct one line
change.

Aka I think this is the obviously correct trivial fix.

 out_unlock:
 	spin_unlock_irq(&pidmap_lock);
+	put_pid_ns(ns);
 out_free:
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);
 


Eric
