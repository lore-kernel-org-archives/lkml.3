Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbaEFIIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:08:40 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934206AbaEFIIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:08:36 -0400
Message-ID: <5368987E.7040608@nod.at>
Date: Tue, 06 May 2014 10:08:30 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] Deprecate BUG/BUG_ON in favour of BUG_AND_HALT/BUG_AND_HALT_ON
References: <1398870207-52889-1-git-send-email-paul.gortmaker@windriver.com> <CAFLxGvzhd6jwGsu9eOBtXu92JcH1PnZsR9EB_h5LihYRNS-hyQ@mail.gmail.com> <20140506073500.GA26303@gmail.com>
In-Reply-To: <20140506073500.GA26303@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.05.2014 09:35, schrieb Ingo Molnar:
> 
> * Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
>> On Wed, Apr 30, 2014 at 5:03 PM, Paul Gortmaker
>> <paul.gortmaker@windriver.com> wrote:
>>> A long standing problem for us has been the misuse of BUG/BUG_ON.
>>> The typical misuse is someone only thinking of what represents
>>> a bug in their local code, and especially for people relatively
>>> new to Linux, starting out in device drivers, the appeal of using
>>> BUG w/o knowing what it really does is too great.
>>>
>>> So you end up with some trivial non system critical driver bringing
>>> the whole system to a grinding halt just because it detected an
>>> internal inconsistency.  That just makes users unhappy and looks bad.
>>>
>>> It is hopeless to think we can reclaim BUG/BUG_ON for their original
>>> intent, given there are currently ~20k instances.  To make progress
>>> here, we create BUG_AND_HALT variants, which leave no doubt as to
>>> what they do in name alone.
>>>
>>> Then we can incrementally move the real BUG users (unrecoverable
>>> filesystem corruption, page table mangling, etc) onto BUG_AND_HALT,
>>> and finally at some time in the future we'll simply make the old
>>> BUG/BUG_ON be aliases for WARN/WARN_ON, once we've moved over the
>>> bulk of the instances really needing to halt the system.
>>>
>>> Suggested-by: Ingo Molnar <mingo@kernel.org>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>> ---
>>>
>>> [This might not be a unique idea; but I'm pretty sure I'd first
>>> heard of it during a discussion with Ingo at RT summit last year.]
>>>
>>>  include/asm-generic/bug.h | 16 ++++++++++++++++
>>>  scripts/checkpatch.pl     |  7 +++++++
>>>  2 files changed, 23 insertions(+)
>>>
>>> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
>>> index 630dd2372238..57b79a394ceb 100644
>>> --- a/include/asm-generic/bug.h
>>> +++ b/include/asm-generic/bug.h
>>> @@ -43,6 +43,14 @@ struct bug_entry {
>>>   * If you're tempted to BUG(), think again:  is completely giving up
>>>   * really the *only* solution?  There are usually better options, where
>>>   * users don't need to reboot ASAP and can mostly shut down cleanly.
>>> + *
>>> + * Sadly nobody listens to the above, and trying to reclaim BUG/BUG_ON
>>> + * for their original intent is about as hopeful as wishing "selfie"
>>> + * wasn't headed for the OED.  So the plan is to avoid BUG/BUG_ON
>>> + * entirely.  Either use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON.
>>> + * Once the critical (e.g. fs etc) BUG/BUG_ON users are updated to use
>>> + * the clearly named HALT variants, we can point the old BUG/BUG_ON
>>> + * defines below to be clones of the less drastic WARN variants.
>>>   */
>>>  #ifndef HAVE_ARCH_BUG
>>>  #define BUG() do { \
>>> @@ -51,10 +59,18 @@ struct bug_entry {
>>>  } while (0)
>>>  #endif
>>>
>>> +#ifndef HAVE_ARCH_BUG_AND_HALT
>>> +#define BUG_AND_HALT BUG
>>> +#endif
>>> +
>>>  #ifndef HAVE_ARCH_BUG_ON
>>>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
>>>  #endif
>>>
>>> +#ifndef HAVE_ARCH_BUG_AND_HALT_ON
>>> +#define BUG_AND_HALT_ON BUG_ON
>>> +#endif
>>> +
>>>  /*
>>>   * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
>>>   * significant issues that need prompt attention if they should ever
>>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>>> index 34eb2160489d..3cbf3591cf76 100755
>>> --- a/scripts/checkpatch.pl
>>> +++ b/scripts/checkpatch.pl
>>> @@ -2010,6 +2010,13 @@ sub process {
>>>                         $rpt_cleaners = 1;
>>>                 }
>>>
>>> +# Dont use BUG/BUG_ON; use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON
>>> +               if ($rawline =~ /^\+.*BUG\(/ || $rawline =~ /^\+.*BUG_ON\(/) {
>>> +                       my $herevet = "$here\n" . cat_vet($rawline) . "\n";
>>> +                       WARN("BUG/BUG_ON",
>>> +                            "Use of BUG/BUG_ON is deprecated. Use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON\n" . $herevet);
>>> +               }
>>> +
>>>  # Check for FSF mailing addresses.
>>>                 if ($rawline =~ /\bwrite to the Free/i ||
>>>                     $rawline =~ /\b59\s+Temple\s+Pl/i ||
>>> --
>>
>> I like the idea but not the name.
>> What about DIE() and DIE_ON()?
> 
> CRASH_ON() might be a suggestive name as well, as from the user's 
> point of view we are crashing her system.

I fear such users will think "Why should I crash the kernel?". ;-)

Thanks,
//richard
