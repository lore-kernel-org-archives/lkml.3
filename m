Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3GAEMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 00:12:14 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:40550 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762Ab3GAEMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 00:12:13 -0400
Message-ID: <51D1019B.1020406@akamai.com>
Date: Mon, 01 Jul 2013 00:12:11 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH 0/3] static keys: fix test/set races
References: <cover.1372457176.git.jbaron@akamai.com> <20130629072016.GA14746@gmail.com>
In-Reply-To: <20130629072016.GA14746@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 03:20 AM, Ingo Molnar wrote:
> * jbaron@akamai.com <jbaron@akamai.com> wrote:
>
>> Hi,
>>
>> As pointed out by Andi Kleen, some static key users can be racy because they
>> check the value of the key->enabled, and then subsequently update the branch
>> direction. A number of call sites have 'higher' level locking that avoids this
>> race, but the usage in the scheduler features does not. See:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1304.2/01655.html
> But that's not an issue at all - switching the scheduler features is for
> development and debugging only, and in some cases higher level locking
> would be needed to solve it 'properly', beyond what the keys API could
> give ...
>
> So this is pretty pointless, sorry, please don't complicate this facility.
>
> Thanks,
>
> 	Ingo

Hi Ingo,

Yes, I agree that 'higher' level locking may be required for some 
callers of the newly proposed interface. However, I do think that the 
static_key_slow_set_true()/false() provides a nice abstraction for some 
callers, while addressing test/set() races, by making that sequence atomic.

I view the proposed inteface of set_true()/set_false() as somewhat 
analogous to an atomic_set() call. In the same way, the current 
static_key_slow_inc()/dec() are analogous to atomic_inc()/dec().

It arguably makes the code code a bit more readable, transforming 
sequences such as:

if (!static_key_enabled(&control_var))
         static_key_slow_inc(&control_var);

into:

         static_key_slow_set_true(&control_var);


I see at least 3 users of static_keys in the tree which I think would 
benefit  from this transformation. The 2 attached with this series, and 
the usage in kernel/tracepoint.c.

Thanks,

-Jason

