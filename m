Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3DKHUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:20:36 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:46442 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3DKHUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:20:35 -0400
Message-ID: <5166643E.6050704@gmail.com>
Date: Thu, 11 Apr 2013 03:20:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Arun Sharma <asharma@fb.com>, John Stultz <john.stultz@linaro.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jason Evans <je@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC v7 00/11] Support vrange for anonymous page
References: <1363073915-25000-1-git-send-email-minchan@kernel.org> <5165CA22.6080808@gmail.com> <20130411065546.GA10303@blaptop>
In-Reply-To: <20130411065546.GA10303@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>   DONTNEED makes sure user always can see zero-fill pages after
>>>   he calls madvise while vrange can see data or encounter SIGBUS.
>>
>> For replacing DONTNEED, user want to zero-fill pages like DONTNEED
>> instead of SIGBUS. So, new flag option would be nice.
> 
> If userspace people want it, I can do it. 
> But not sure they want it at the moment becaue vrange is rather
> different concept of madvise(DONTNEED) POV usage.
> 
> As you know well, in case of DONTNEED, user calls madvise _once_ and
> VM releases memory as soon as he called system call.
> But vrange is same with delayed free when the system memory pressure
> happens so user can't know OS frees the pages anytime.
> It means user should call pair of system call both VRANGE_VOLATILE
> and VRANGE_NOVOLATILE for right usage of volatile range
> (for simple, I don't want to tell SIGBUS fault recovery method).
> If he took a mistake(ie, NOT to call VRANGE_NOVOLATILE) on the range
> which is used by current process, pages used by some process could be
> disappeared suddenly.
> 
> In summary, I don't think vrange is a replacement of madvise(DONTNEED)
> but could be useful with madvise(DONTNEED) friend. For example, we can
> make return 1 in vrange(VRANGE_VOLATILE) if memory pressure was already

Do you mean vrange(VRANGE_UNVOLATILE)?
btw, assign new error number to asm-generic/errno.h is better than strange '1'.


> severe so user can catch up memory pressure by return value and calls
> madvise(DONTNEED) if memory pressure was already severe. Of course, we
> can handle it vrange system call itself(ex, change vrange system call to
> madvise(DONTNEED) but don't want it because I want to keep vrange hinting
> sytem call very light at all times so user can expect latency.

For allocator usage, vrange(UNVOLATILE) is annoying and don't need at all.
When data has already been purged, just return new zero filled page. so,
maybe adding new flag is worthwhile. Because malloc is definitely fast path
and adding new syscall invokation is unwelcome.


>> # of     # of   # of
>> thread   iter   iter (patched glibc)
> 
> What's the workload?

Ahh, sorry. I forgot to write. I use ebizzy, your favolite workload.



