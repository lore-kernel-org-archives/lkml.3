Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaIQHny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:43:54 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34489 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaIQHnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:43:52 -0400
Message-ID: <54193BB2.8010500@redhat.com>
Date: Wed, 17 Sep 2014 09:43:46 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>
CC: Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
References: <1410811885-17267-1-git-send-email-andreslc@google.com>	<54184078.4070505@redhat.com>	<CAJu=L5_w+u6komiZB6RE1+9H5MiL+8RJBy_GYO6CmjqkhaG5Zg@mail.gmail.com>	<54188179.7010705@redhat.com> <CAJu=L58z-=_KkZXpEiPjDUup8GpH7079HH39csmvgUxGkvXy0A@mail.gmail.com>
In-Reply-To: <CAJu=L58z-=_KkZXpEiPjDUup8GpH7079HH39csmvgUxGkvXy0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/09/2014 20:42, Andres Lagar-Cavilla ha scritto:
> On Tue, Sep 16, 2014 at 11:29 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>     I think a first patch should introduce kvm_get_user_page_retry ("Retry a
>>>     fault after a gup with FOLL_NOWAIT.") and the second would add
>>>     FOLL_TRIED ("This properly relinquishes mmap semaphore if the
>>>     filemap/swap has to wait on page lock (and retries the gup to completion
>>>     after that").
>>>
>>> That's not what FOLL_TRIED does. The relinquishing of mmap semaphore is
>>> done by this patch minus the FOLL_TRIED bits. FOLL_TRIED will let the
>>> fault handler (e.g. filemap) know that we've been there and waited on
>>> the IO already, so in the common case we won't need to redo the IO.
>>
>> Yes, that's not what FOLL_TRIED does.  But it's the difference between
>> get_user_pages and kvm_get_user_page_retry, right?
> 
> Unfortunately get_user_pages does not expose the param (int
> *nonblocking) that __gup will use to set FAULT_FLAG_ALLOW_RETRY. So
> that's one difference. The second difference is that kvm_gup_retry
> will call two times if necessary (the second without _RETRY but with
> _TRIED).

Yeah, that's how it is in your patch.  I can see that.

What I'm saying is that your patch is two changes in one:

1) do not use gup_fast in hva_to_pfn_slow, instead use gup as in
async_pf_execute.  This change can already introduce a function called
kvm_get_user_page_retry, and can already use it in async_pf_execute and
hva_to_pfn_slow

2) introduce the two-phase RETRY + TRIED mechanism in
kvm_get_user_page_retry, so that the mmap semaphore is relinquished
properly if the filemap or swap has to wait on the page lock.

I would prefer to split it in two patches.  Is it clearer now?

Paolo
