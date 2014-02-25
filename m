Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBYXQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:16:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaBYXQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:16:33 -0500
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
From: Alexander Graf <agraf@suse.de>
X-Mailer: iPhone Mail (11B554a)
In-Reply-To: <20140225171940.GS6835@laptop.programming.kicks-ass.net>
Date: Wed, 26 Feb 2014 07:16:17 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>, "kay@vrfy.org" <kay@vrfy.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5E6DB7F9-41E0-4DCC-A14B-49E2F4134A1C@suse.de>
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <20140225171528.GJ4407@cmpxchg.org> <20140225171940.GS6835@laptop.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> Am 26.02.2014 um 01:19 schrieb Peter Zijlstra <peterz@infradead.org>:
>> 
>>> On Tue, Feb 25, 2014 at 12:15:28PM -0500, Johannes Weiner wrote:
>>> On Tue, Feb 25, 2014 at 12:28:04AM +0100, Alexander Graf wrote:
>>> Configuration of tunables and Linux virtual memory settings has traditionally
>>> happened via sysctl. Thanks to that there are well established ways to make
>>> sysctl configuration bits persistent (sysctl.conf).
>>> 
>>> KSM introduced a sysfs based configuration path which is not covered by user
>>> space persistent configuration frameworks.
>>> 
>>> In order to make life easy for sysadmins, this patch adds all access to all
>>> KSM tunables via sysctl as well. That way sysctl.conf works for KSM as well,
>>> giving us a streamlined way to make KSM configuration persistent.
>>> 
>>> Reported-by: Sasche Peilicke <speilicke@suse.com>
>>> Signed-off-by: Alexander Graf <agraf@suse.de>
>>> ---
>>> kernel/sysctl.c |   10 +++++++
>>> mm/ksm.c        |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> 2 files changed, 88 insertions(+), 0 deletions(-)
>>> 
>>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>>> index 332cefc..2169a00 100644
>>> --- a/kernel/sysctl.c
>>> +++ b/kernel/sysctl.c
>>> @@ -217,6 +217,9 @@ extern struct ctl_table random_table[];
>>> #ifdef CONFIG_EPOLL
>>> extern struct ctl_table epoll_table[];
>>> #endif
>>> +#ifdef CONFIG_KSM
>>> +extern struct ctl_table ksm_table[];
>>> +#endif
>>> 
>>> #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
>>> int sysctl_legacy_va_layout;
>>> @@ -1279,6 +1282,13 @@ static struct ctl_table vm_table[] = {
>>>   },
>>> 
>>> #endif /* CONFIG_COMPACTION */
>>> +#ifdef CONFIG_KSM
>>> +    {
>>> +        .procname    = "ksm",
>>> +        .mode        = 0555,
>>> +        .child        = ksm_table,
>>> +    },
>>> +#endif
>> 
>> ksm can be a module, so this won't work.
>> 
>> Can we make those controls proper module parameters instead?
> 
> You can do dynamic sysctl registration and removal. Its its own little
> filesystem of sorts.

Hm. Doesn't this open another big can of worms? If we have ksm as a module and our sysctl helpers try to enable ksm on boot, they may not be able to because the module hasn't been loaded yet.

So in that case, we want to always register the sysctl and dynamically load the ksm module when the sysctl gets accessed - similar to how we can do stub devices that load modiles, no?

Alex