Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3IIR5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:57:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52499 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3IIR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:57:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com>
	<20130830144232.GA18281@mail.hallyn.com>
	<87hae6vh0w.fsf_-_@xmission.com> <20130908175602.GA3172@redhat.com>
	<20130908180137.GA4915@redhat.com> <87bo43gg4h.fsf@xmission.com>
	<20130909151530.GA6755@redhat.com>
Date: Mon, 09 Sep 2013 10:54:58 -0700
In-Reply-To: <20130909151530.GA6755@redhat.com> (Oleg Nesterov's message of
	"Mon, 9 Sep 2013 17:15:30 +0200")
Message-ID: <87bo41j2x9.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Tf2/dxneQxyYfmYWxCODwjrnn0Kfgf3k=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2598]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: free_pid() && PIDNS_HASH_ADDING
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 09/08, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > On 09/08, Oleg Nesterov wrote:
>> >>
>> >> Off topic. What if the first alloc_pid() succeeds and then later
>> >> copy_process() fails. In this case free_pid() is called but
>> >> PIDNS_HASH_ADDING was not cleared, we miss kern_unmount(), no?
>> >
>> > Perhaps something like below?
>>
>> I am thinking more:
>>
>> diff --git a/kernel/pid.c b/kernel/pid.c
>> index ab75add..ef59516 100644
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -273,6 +273,10 @@ void free_pid(struct pid *pid)
>>                          */
>>                         wake_up_process(ns->child_reaper);
>>                         break;
>> +               case PIDNS_HASH_ADDING:
>> +                       /* Handle a fork failure of the first process */
>> +                       ns->nr_hashed = 0;
>
> Agreed, it also makes sense to clear ->nr_hashed. But I still think
> that WARN_ON(ns->child_reaper) makes sense too.

I don't know that I like warnings for impossible conditions.  How could
we even make a mistake that gets us there?

>> At which point I ask myself what of the pathlogocical case where the
>> first fork fails but because we created the pid namespace with unshare
>> there is a concurrent fork from another process into the pid namespace
>> that succeeds.  Resulting in one pid in the pid namespace that is not
>> the reaper.
>
> But how can setns() work before the first fork() succeeds and makes the
> ->child_reaper visible in /proc ?
>
> Probably I missed something obvious, I didn't sleep today...

Actually that is a very good point.  That is an accidental feature but
one I very much appreciate today.

Of course this leads me to the question of what the checkpoint/restart
guys can do about checkpointing that properly. Sigh.

Eric
