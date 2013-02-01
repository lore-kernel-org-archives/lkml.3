Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3BAOUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:20:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47528 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3BAOUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:20:45 -0500
Message-ID: <510BCF29.7000104@oracle.com>
Date: Fri, 01 Feb 2013 09:20:25 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] liblock: public headers for mutex implementation
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com> <1359694058-24452-3-git-send-email-sasha.levin@oracle.com> <20130201095701.GA23061@gmail.com>
In-Reply-To: <20130201095701.GA23061@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 04:57 AM, Ingo Molnar wrote:
> 
> * Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> These headers provide the same API as their pthread mutex counterparts.
>>
>> The design here is to allow to easily switch to liblock lock validation
>> just by adding a "liblock_" to pthread_mutex_*() calls, which means that
>> it's easy to integrate liblock into existing codebases.
> 
> I'd suggest to name the user-space counterpart 'liblockdep', to 
> make it clear that this is user-space lockdep.

Agreed. Pekka also mentioned that liblock sounds to much like lib-block, so
renaming it to liblockdep will take care of that :)

> Regarding pthread_mutex_t checking, I think what we *really* 
> want is a wrapper that can be activated via:
> 
> #define __USE_LIBLOCKDEP
> 
> And which then takes over the pthread primitives via:
> 
>   #define pthread_mutex_lock liblockdep_pthread_mutex_lock
> 
> or so.
> 
> That way the source code only needs a __USE_LIBLOCKDEP in one or 
> two key places and checking is activated.

There are 2 issues I see with that:
 - api calls which are liblockdep specific (liblockdep_init() for example) would
still have to be wrapped somehow in the new code.
 - LIBLOCKDEP_PTHREAD_MUTEX_INIT(mtx) doesn't only change the name of the original
pthread mutex initializer, it also starts requiring the mutex name as parameter so
that it could pass it on to lockdep.

Dealing with these two will mean that there's a '#ifdef __USE_LIBLOCKDEP' both in
the lib and in the source code that uses it, which might be a bit confusing.

Either way, I'll resend the patch with these changes so we'll have a better view
of how it would look.


Thanks,
Sasha

