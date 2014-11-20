Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbaKTJeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:34:50 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50041 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:34:47 -0500
Message-ID: <546DB5B0.8040105@linaro.org>
Date: Thu, 20 Nov 2014 09:34:40 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC] debug: add parameters to prevent entering debug mode on
 errors
References: <1416312516-4551-1-git-send-email-kiran.kumar@linaro.org>	<546B7E21.4000602@linaro.org> <CA+RfmHYe7MJi61h76HPFpoh4bMG8erTGKpVhvQFjr8SaFXgH6w@mail.gmail.com>
In-Reply-To: <CA+RfmHYe7MJi61h76HPFpoh4bMG8erTGKpVhvQFjr8SaFXgH6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/14 08:18, Kiran Raparthy wrote:
> Hi Daniel,
> 
> On 18 November 2014 22:43, Daniel Thompson <daniel.thompson@linaro.org> wrote:
>> On 18/11/14 12:08, Kiran Kumar Raparthy wrote:
>>> From: Colin Cross <ccross@android.com>
>>>
>>> debug: add parameters to prevent entering debug mode on errors
>>>
>>> On non-developer devices kgdb prevents CONFIG_PANIC_TIMEOUT from rebooting the
>>> device after a panic. Add module parameters debug_core.break_on_exception and
>>> debug_core.break_on_panic to allow skipping debug on panics and exceptions
>>> respectively.  Both default to true to preserve existing behavior.
>>
>> I am a little unsure about break_on_panic.
>>
>> It ought to be possible for kgdb/kdb to honour CONFIG_PANIC_TIMEOUT by
>> tracking how long it takes for the user to attach a debugger (or to run
>> the first kdb command after the panic). As it happens the timeout value
>> is already an exported kernel symbol so all the info it there for us to
>> use...
>>
>> Doing so would save us imposing further configuration burden on the user
>> (although it would be a good deal more code).
>>
>> Note that I can't think of an automatic way to handle break_on_exception
>> so I'm less worried about that one.
> Alright,so it it okay if we have this mechanism limited to "skip debug
> on exceptions"?
> please let me know if i have misunderstood your point.

Spliting it up would certainly stop a review comment from needlessly
interfering with good stuff being delivered. That's always a good thing.

To be clear though, providing the user a way to prevent kgdb from
preventing the machine from rebooting after panic seems to me to be a
useful feature. It is simply that I think the existing panic_timeout
value could be used to realize it.

>>> +             return 1;
>>> +
>>>       memset(ks, 0, sizeof(struct kgdb_state));
>>>       ks->cpu                 = raw_smp_processor_id();
>>>       ks->ex_vector           = evector;
>>> @@ -821,6 +830,9 @@ static int kgdb_panic_event(struct notifier_block *self,
>>>                           unsigned long val,
>>>                           void *data)
>>>  {
>>> +     if (!break_on_panic)
>>> +             return NOTIFY_DONE;

How about simply:

	if (panic_timeout)
		return NOTIFY_DONE;

(plus a nice comment explaining why)

This doesn't implement a timeout and so does not prevent a physically
present user from exploiting kgdb. Nevertheless its an accurate
interpretation of what the user told us to do and leaves the door open
to adding a timeout in the future.

Actually it might be a good idea to use panic_timeout to control
trap-on-oops as well! If the user wants the machine to reboot itself on
panic they certainly don't want it to hang during an oops.

if (panic_timeout)
	return NOTIFY_DONE;

>>> +
>>>       if (dbg_kdb_mode)
>>>               kdb_prinf("PANIC: %s\n", (char *)data);
>>>       kgdb_breakpoint();
>>>
>>

