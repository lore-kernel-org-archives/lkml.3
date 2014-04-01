Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaDAVgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:36:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37036 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaDAVgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:36:04 -0400
Message-ID: <533B30D2.6060606@zytor.com>
Date: Tue, 01 Apr 2014 14:34:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <20140401212102.GM4407@cmpxchg.org>
In-Reply-To: <20140401212102.GM4407@cmpxchg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 02:21 PM, Johannes Weiner wrote:
> [ I tried to bring this up during LSFMM but it got drowned out.
>   Trying again :) ]
> 
> On Fri, Mar 21, 2014 at 02:17:30PM -0700, John Stultz wrote:
>> Optimistic method:
>> 1) Userland marks a large range of data as volatile
>> 2) Userland continues to access the data as it needs.
>> 3) If userland accesses a page that has been purged, the kernel will
>> send a SIGBUS
>> 4) Userspace can trap the SIGBUS, mark the affected pages as
>> non-volatile, and refill the data as needed before continuing on
> 
> As far as I understand, if a pointer to volatile memory makes it into
> a syscall and the fault is trapped in kernel space, there won't be a
> SIGBUS, the syscall will just return -EFAULT.
> 
> Handling this would mean annotating every syscall invocation to check
> for -EFAULT, refill the data, and then restart the syscall.  This is
> complicated even before taking external libraries into account, which
> may not propagate syscall returns properly or may not be reentrant at
> the necessary granularity.
> 
> Another option is to never pass volatile memory pointers into the
> kernel, but that too means that knowledge of volatility has to travel
> alongside the pointers, which will either result in more complexity
> throughout the application or severely limited scope of volatile
> memory usage.
> 
> Either way, optimistic volatile pointers are nowhere near as
> transparent to the application as the above description suggests,
> which makes this usecase not very interesting, IMO.  If we can support
> it at little cost, why not, but I don't think we should complicate the
> common usecases to support this one.
> 

The whole EFAULT thing is a fundamental problem with the kernel
interface.  This is not in any way the only place where this suffers.

The fact that we cannot reliably get SIGSEGV or SIGBUS because something
may have been passed as a system call is an enormous problem.  The
question is if it is in any way fixable.

	-hpa

