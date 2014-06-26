Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaFZEIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 00:08:52 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59762 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaFZEIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 00:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140625150318.4355468ab59a5293e870605e@linux-foundation.org>
References: <20140624201606.18273.44270.stgit@zurg>
	<20140624201614.18273.39034.stgit@zurg>
	<20140625150318.4355468ab59a5293e870605e@linux-foundation.org>
Date: Thu, 26 Jun 2014 08:08:50 +0400
Message-ID: <CALYGNiOtO9bV2RJuM_42fc-R_9aHpjkfRxX7V_zy=GBX68UW_A@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: catch memory commitment underflow
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 2:03 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 25 Jun 2014 00:16:14 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>
>> This patch prints warning (if CONFIG_DEBUG_VM=y) when
>> memory commitment becomes too negative.
>>
>> ...
>>
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -134,6 +134,12 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>>  {
>>       unsigned long free, allowed, reserve;
>>
>> +#ifdef CONFIG_DEBUG_VM
>> +     WARN_ONCE(percpu_counter_read(&vm_committed_as) <
>> +                     -(s64)vm_committed_as_batch * num_online_cpus(),
>> +                     "memory commitment underflow");
>> +#endif
>> +
>>       vm_acct_memory(pages);
>
> The changelog doesn't describe the reasons for making the change.
>
> I assume this warning will detect the situation which the previous two
> patches just fixed?

Yep. Otherwise there is no way to validate these bugs, /proc/meminfo
hides negative values.

> Why not use VM_WARN_ON_ONCE()?

This patch is older than this macro.
Previously I've sent it in the last september and it was ignored. Now
I've found it again in my backlog.
