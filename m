Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965504Ab3DPWAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 18:00:20 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39056 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965386Ab3DPWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130416133017.GB9189@redhat.com>
References: <20130414191205.GA28791@redhat.com>
	<20130414191232.GA28816@redhat.com>
	<20130416004452.GG17561@somewhere.redhat.com>
	<20130416133017.GB9189@redhat.com>
Date: Wed, 17 Apr 2013 00:00:17 +0200
Message-ID: <CAFTL4hzzrqnm4TixUsCf57Xu+AHfSe26OToOo4y=RJzqF8FREg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ptrace/x86: dont delay perf_event_disable() till
 second pass in ptrace_write_dr7()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/16 Oleg Nesterov <oleg@redhat.com>:
> On 04/16, Frederic Weisbecker wrote:
>> >             rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
>> >             if (rc)
>> >                     break;
>>
>> It would be nice to warn here:
>>
>>    WARN_ON_ONCE(rc && second_pass);
>
> Well, I disagree.
>
> To clarify, I agree with WARN_ON_ONCE(), but afaics it has nothing to
> do with "second_pass",
>
>> And these are indeed supposed
>> to.
>
> Indeed, but this is because ptrace_modify_breakpoint() should not fail.
>
> So, what do you think if I change the main loop above
>
>                 rc = ptrace_modify_breakpoint(...)
>         -       if (rc)
>         +       if (WARN_ON_ONCE(rc))
>                         break;

It can fail in the first pass if dr7 is incorrect. For example passing
a length of 8 in x86-32 is rejected. The type can be wrong too.
But the second pass shouldn't fail. If it was validated once, then it
should be valid a second time.
