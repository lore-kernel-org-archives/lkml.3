Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaKZTHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:07:02 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25139 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:07:00 -0500
Message-ID: <547624C7.3020003@oracle.com>
Date: Wed, 26 Nov 2014 14:06:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrey Ryabinin <ryabinin.a.a@gmail.com>, mingo <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] kvm: eventfd: detect integer overflow using check_*_overflow
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>	<1417010419-3827-2-git-send-email-sasha.levin@oracle.com>	<CAPAsAGztsLxPbYfLzmDmGUeezhs_q_Az=Q9oNHRqnpBXjAajjg@mail.gmail.com>	<54761406.9090602@oracle.com> <CA+55aFz8TUtKtkPzQVHAS+-RfNmd6W=CQq4BRcEux+mf8tYtqw@mail.gmail.com>
In-Reply-To: <CA+55aFz8TUtKtkPzQVHAS+-RfNmd6W=CQq4BRcEux+mf8tYtqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 01:23 PM, Linus Torvalds wrote:
> On Wed, Nov 26, 2014 at 9:55 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > Good point. Do you think there's an advantage in using GCC's overflow
>> > checker in this case?
> No. However, if your coccinelle script can be changed to verify that
> the type of the expression is unsigned, _that_ would be useful.

I'm pretty sure that this is something GCC will warn you about in the
compilation stage.

> And the "multiplication overflow" may actually be a way to generate
> better code. Possibly. I'm not entirely sure exactly what gcc actually
> does. How many multiplication overflow tests do we actually have,
> though?

Well, there are two straightforward checks in the kcalloc() family. They're
not the issue though. The problem is the *unchecked* *signed* integer overflows
lurking around.

kernel/time/ntp.c:process_adjtimex_modes():

	if (txc->modes & ADJ_FREQUENCY) {
                time_freq = txc->freq * PPM_SCALE;   <=== Undefined overflow
                time_freq = min(time_freq, MAXFREQ_SCALED);
                time_freq = max(time_freq, -MAXFREQ_SCALED);
                /* update pps_freq */
                pps_set_freq(time_freq);
        }

The multiplication is between signed integers, and it overflows (user triggerable).


Thanks,
Sasha
