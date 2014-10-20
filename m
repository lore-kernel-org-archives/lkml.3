Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaJTOm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:42:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8973 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaJTOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:42:23 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-a1-54451f4d7868
Message-id: <54451F4B.8020900@samsung.com>
Date: Mon, 20 Oct 2014 18:42:19 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.1
MIME-version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org>
 <54451501.2070700@samsung.com> <5445179A.4080804@redhat.com>
 <20141020141635.GA4499@thunk.org>
In-reply-to: <20141020141635.GA4499@thunk.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4ZV1fedcQgwM/WCy+fulgsZizfg2b
	xYn/RxgtJjxsY7eYtlHcYmXnA1aLP7t2MFlc3jWHzeLSgQVMFi37LjBZHO89wGSx+MhtZovN
	m6YyW7T2/GS3+LHhMasDv0fL5nKPnbPusnss2FTqsXmFlsemVZ1sHu/OnWP3ODHjN4tH05mj
	zB4fn95i8Xi/7yqbx5kFR9g9Pm+S8zjR8oU1gDeKyyYlNSezLLVI3y6BK+PDzBWsBWc5Ktqb
	3RsY97F1MXJySAiYSLzd0skOYYtJXLi3HiwuJLCUUWJlsz+E3cwkce1HKYjNK6AlcfRyOwuI
	zSKgKrFm225WEJtNQE/i36ztYL2iAhESG9fvYISoF5T4MfkeWL2IgKLErZYvzF2MXBzMAr+Z
	Jd5/2AW2WFjAReLUvUfsIAkhgbeMEvOvvgHr5gSa2rh2GlgRs4COxP7WaWwQtrzE5jVvmScw
	CsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJvi87GBcfszrEKMDB
	qMTDK2DpEiLEmlhWXJl7iFGCg1lJhPeUoGuIEG9KYmVValF+fFFpTmrxIUYmDk6pBsYpb7I/
	5Ec7R6oE9rNPCb9t9v32x2i7O2sNnaSXiC5YvG+3aeaFH/av1ykddRBcV5LtKqDNWNL7eo2H
	pgwvP887k+X7X/GcPCZalbzDfd4VhnYN/QSDt8uKpsoZMGW89tg+40fL1taW6G2ttyu+xAjk
	fjV36fsXFRbGezRQNJiZ77Tmyu8cE5RYijMSDbWYi4oTAVR3t3qcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 06:16 PM, Theodore Ts'o wrote:
> On Mon, Oct 20, 2014 at 04:09:30PM +0200, Daniel Borkmann wrote:
>>>
>>> It's triggering when input_rotate == 0, so UBSan complains about right shift in rol32()
>>>
>>> static inline __u32 rol32(__u32 word, unsigned int shift)
>>> {
>>> 	return (word << shift) | (word >> (32 - shift));
>>> }
>>
>> So that would be the case when the entropy store's input_rotate calls
>> _mix_pool_bytes() for the very first time ... I don't think it's an
>> issue though.
> 
> I'm sure it's not an issue, but it's still true that 
> 
> 	return (word << 0) | (word >> 32);
> 
> is technically not undefined, and while it would be unfortunate (and
> highly unlikely) if gcc were to say, start nethack, it's technically
> allowed by the C spec.  :-)
> 

There are plenty of such technically not defined but really
harmless things in kernel.
I've reported only few UBs which seemed to me like a real bugs.
So if it's not an issue we could ignore it, OTOH it would be nice
to fix it to shut up ubsan.

>      	     	   	    	 	     - Ted
> 

