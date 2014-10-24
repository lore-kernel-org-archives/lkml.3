Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaJXWYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:24:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48652 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaJXWYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:24:30 -0400
Message-ID: <544AD16C.40904@zytor.com>
Date: Fri, 24 Oct 2014 15:23:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Dmitry Vyukov <dvyukov@google.com>
CC: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>, "x86@kernel.org" <x86@kernel.org>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>	<5444EBFA.5030103@samsung.com>	<20141020124929.GA23177@thunk.org>	<54451501.2070700@samsung.com>	<5445179A.4080804@redhat.com>	<20141020141635.GA4499@thunk.org>	<20141024100108.GF12706@worktop.programming.kicks-ass.net>	<544A52D7.6000202@oracle.com>	<20141024134205.GB21513@worktop.programming.kicks-ass.net>	<544A6A6B.3040602@oracle.com>	<CACT4Y+boMTKpTovCWYQa6baSAWjagCN=mwXBZGAjbobzG80oWA@mail.gmail.com> <20141024220502.54cac82d@alan.etchedpixels.co.uk>
In-Reply-To: <20141024220502.54cac82d@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 02:05 PM, One Thousand Gnomes wrote:
> On Fri, 24 Oct 2014 19:10:49 +0400
> Dmitry Vyukov <dvyukov@google.com> wrote:
> 
>> On Fri, Oct 24, 2014 at 7:04 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>> On 10/24/2014 09:42 AM, Peter Zijlstra wrote:
>>>> On Fri, Oct 24, 2014 at 09:23:35AM -0400, Sasha Levin wrote:
>>>>>
>>>>> i >> 32 may happen to be "i", but is there anything that prevents the compiler
>>>>> from returning, let's say, 42?
>>>>
>>>> Not really, although gcc seems to opt for the 'sane' option and emit the
>>>> instruction and let the arch figure out how to deal with it. Hence the
>>>> 'fun' difference between x86 and ARM.
>>>
>>> It's interesting how many different views on undefined behaviour there are between
>>> kernel folks.
>>>
>>> Everything between Ted Ts'o saying that GCC can launch nethack on oversized shifts,
>>> to DaveM saying he will file a GCC bug if the behaviour isn't sane w.r.t to memcpy().
>>
>> One of the benefits of fixing such issues (or not letting them into
>> code in the first place) is just saving numerous hours of top-notch
>> engineers spent on disputes like this.
> 
> Also it means when someone quietly changes the default behaviour next
> year in the compiler they won't spend months trying to work out why it
> broke.
> 
> gcc has one behaviour but people also try and build the kernel with icc
> and with llvm. In addition in some cases you risk the compiler simply
> generating an undefined in hardware operation and the hardware behaviour
> changing. If x >> 32 is undefined then generating "load Y with the
> shift, shift X left by Y" is fine. What happens in future silicon - who
> knows.
> 
> Most of the kernel is already very careful about the >> 32 problem.
> 

The real question is if we can rely on the gcc-ism:

	(x >> (S-y)) | (x << y)

... where S is the number of bits to indicate a rotate.

This is technically a gcc extension to the C language.

	-hpa


