Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab3LPRRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:17:39 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:63359 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3LPRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:17:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131216103944.GO11295@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
	<CA+55aFyNAigQqBk07xLpf0nkhZ_x-QkBYG8otRzsqg_8A2eg-Q@mail.gmail.com>
	<52AB8C68.1040305@zytor.com>
	<20131216103944.GO11295@suse.de>
Date: Mon, 16 Dec 2013 09:17:35 -0800
X-Google-Sender-Auth: Rk_sng5LDCaQe1QsfW9BIJ-6kxk
Message-ID: <CA+55aFzgH0hG3-zOOzADvBOMXJCGo4=JXafiRiXqL8NRec5J4A@mail.gmail.com>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alex Shi <alex.shi@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 2:39 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> First was Alex's microbenchmark from https://lkml.org/lkml/2012/5/17/59
> and ran it for a range of thread numbers, 320 iterations per thread with
> random number of entires to flush. Results are from two machines

There's something wrong with that benchmark, it sometimes gets stuck,
and the profile numbers are just random (and mostly in user space).

I think you mentioned fixing a bug in it, mind pointing at the fixed benchmark?

Looking at the kernel footprint, it seems to depend on what parameters
you ran that benchmark with. Under certain loads, it seems to spend
most of the time in clearing pages and in the page allocation ("-t 8
-n 320"). And in other loads, it hits smp_call_function_many() and the
TLB flushers ("-t 8 -n 8"). So exactly what parameters did you use?

Because we've had things that change those two things (and they are
totally independent).

And does anything stand out in the profiles of ebizzy? For example, in
between 3.4.x and 3.11, we've converted the anon_vma locking from a
mutex to a rwsem, and we know that caused several issues, possibly
causing unfairness. There are other potential sources of unfairness.
It would be good to perhaps bisect things at least *somewhat*, because
*so* much has changed in 3.4 to 3.11 that it's impossible to guess.

                    Linus
