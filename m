Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaIOM5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:57:46 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:58644 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaIOM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:57:44 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC] perf kvm stat live: cache mmap()ed events
References: <1410539263-25857-1-git-send-email-yarygin@linux.vnet.ibm.com>
	<5415B6B9.2040607@gmail.com>
Date: Mon, 15 Sep 2014 16:57:34 +0400
In-Reply-To: <5415B6B9.2040607@gmail.com> (David Ahern's message of "Sun, 14
	Sep 2014 09:39:37 -0600")
Message-ID: <874mw9vy69.fsf@linux.vnet.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091512-4966-0000-0000-000001560B5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 9/12/14, 10:27 AM, Alexander Yarygin wrote:
>> During mmap() process 'perf kvm stat live' gets a pointer to events and
>> passes them to the session queue. Events are stored in shared memory and
>> eventually they will be overwritten by the kernel. The problem is, that
>> when events come too fast, old events can be overwritten before they
>> have been processed that can lead to perf crash.
>>
>> To prevent that happening, we can copy upcoming events and pass a copy
>> to the session queue. There is a safe place to copy event: before
>> perf_evlist__mmap_consume() is executed. There are 3 places to free it:
>> when event is processed, when it's lost and on exit, if it's turned out
>> unprocessed.
>
> Did you see what I proposed a year ago:
> https://lkml.org/lkml/2013/9/6/388
>
> The intent is to keep the copy generic and not local a command since
> conceptually other live commands need the same.
>
> David

Hello,

Yes, your patch works fine. But as far as I understand, right now only
the 'perf kvm stat live' is infected: other 'live' tools were fixed by
the patch "PERF: The tail position of the event buffer should only be modified
after actually use that event." and since they don't use ordered queue
they don't need a copying. That's why I came up with 'perf kvm stat
live' specific approach. Maybe I missed something...

Anyhow, having >30K events is a quite usual situation on s390 and the
'perf kvm stat live' command hardly works there, so it would be good to
have at least some working solution. Any ideas? :)

Thanks.

