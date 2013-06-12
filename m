Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab3FLBRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:17:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44856 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab3FLBRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:17:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Raphael S. Carvalho" <raphael.scarv@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
References: <1370901398-8989-1-git-send-email-raphael.scarv@gmail.com>
	<20130611154518.fda9262961c21e96a57cbd5e@linux-foundation.org>
Date: Tue, 11 Jun 2013 18:16:50 -0700
In-Reply-To: <20130611154518.fda9262961c21e96a57cbd5e@linux-foundation.org>
	(Andrew Morton's message of "Tue, 11 Jun 2013 15:45:18 -0700")
Message-ID: <8761xkt9fh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX195bEgPjJS3FgQtc8fB2YE+RSN7/hgwWd8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] kernel/pid.c: Masking the flag out to get the actual value.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 10 Jun 2013 18:56:38 -0300 "Raphael S. Carvalho" <raphael.scarv@gmail.com> wrote:
>
>> This patch shouldn't be applied if those branches must only be taken when
>> the pid_allocation(PIDNS_HASH_ADDING) flag was turned off.

That is correct.  We should not encounter the last pid in the pid
namespace while still allowing processes to be created in the pid
namespace.

So the patch I am seeing quoted below is unnecessary.

> Well yes - hopefully this is the case.  Otherwise we're missing some
> rather important-looking wakeups.
>
>
>> Otherwise, we must turn the PIDNS_HASH_ADDING flag (1U << 31) off
>> before getting into the switch-cases.
>> 
>> ...
>>
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -263,7 +263,10 @@ void free_pid(struct pid *pid)
>>  		struct upid *upid = pid->numbers + i;
>>  		struct pid_namespace *ns = upid->ns;
>>  		hlist_del_rcu(&upid->pid_chain);
>> -		switch(--ns->nr_hashed) {
>> +
>> +		/* We must turn the PIDNS_HASH_ADDING flag off to
>> +		   get the actual value of nr_hashed */
>> +		switch ((--ns->nr_hashed) & ~(PIDNS_HASH_ADDING)) {
>>  		case 1:
>>  			/* When all that is left in the pid namespace
>>  			 * is the reaper wake up the reaper.  The reaper
>
> Eric, can you please take a look?  Presumably and hopefully
> PIDNS_HASH_ADDING cannot be set here, but what guarantees this?

The init process has not exited, and called zap_pid_ns_processes.

In fact there is a case where nr_hashed can be 0 | PIDNS_HASH_ADDING
where we absolutely don't want to do these things.   Of course there
are no pids allocated in that case to free so we can't possible get 
to the switch in free pid either.

> Hopefully we can fix this one by adding the missing comment.

Perhaps we can fix this one by having people who care read the code and 
think about what it means?  Seriously if we are adding pids/processes in
the pid namespace why would to clean up the pid namespace?

Eric

