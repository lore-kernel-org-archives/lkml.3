Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab3KMOd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:33:56 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62073 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab3KMOdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:33:54 -0500
Message-ID: <52838DD0.20906@gmail.com>
Date: Wed, 13 Nov 2013 07:33:52 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/5] perf record: Handle out of space failures writing
 data with mmap
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com> <1384267617-3446-6-git-send-email-dsahern@gmail.com> <20131112211926.GD25913@gmail.com>
In-Reply-To: <20131112211926.GD25913@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13, 2:19 PM, Ingo Molnar wrote:

> So this isn't very robust, because it assumes that all sources of SIGBUS
> are due to that memcpy() hitting -ENOSPC...
>
> There are several failure modes:
>
>   - If mmap_jmp is not set yet and we get a SIGBUS is some other place,
>     then the longjmp() result will be undefined.
>
>   - If mmap_jmp environment is set, but we've returned from
>     do_mmap_output() already, then the result will be undefined - likely a
>     non-obvious crash.
>
> So at minimum we need a flag that tells us whether the jump environment is
> valid or not - i.e. whether we are executing inside the protected region
> or not - and only do the longjmp() if that flag is set.

Right I meant to add that -- a flag to know when the jmp should be used. 
Got distracted.

>
> Is there really no other way to handle the -ENOSPC case robustly? I guess
> not because the memcpy() really needs memory to write to, but I thought
> I'd ask ...

You need some means to interrupt memcpy and bounce out of it. longjmp is 
the only option I know of.

David
