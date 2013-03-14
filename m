Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3CNPUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:20:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58239 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab3CNPUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <1363261167.25976.221.camel@thor.lan>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	<1362612111-28673-12-git-send-email-walken@google.com>
	<1363034207.27803.8.camel@thor.lan>
	<20130314070303.GA10956@google.com>
	<1363261167.25976.221.camel@thor.lan>
Date: Thu, 14 Mar 2013 08:20:31 -0700
Message-ID: <CANN689HSaiMz=TRLFr6dXk0ndvaHJECL_XCHsV7Xh1+80U9K+Q@mail.gmail.com>
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a reader
From: Michel Lespinasse <walken@google.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 4:39 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Thu, 2013-03-14 at 00:03 -0700, Michel Lespinasse wrote:
>> >   CPU 0                               |  CPU 1
>> >                                       |
>> >                                       | down_write()
>> >
>> > ... CPU 1 has the write lock for the semaphore.
>> >     Meanwhile, 1 or more down_read(s) are attempted and fail;
>> >     these are put on the wait list.
>>
>> I'm not sure of the relevance of these other down_read() calls -
>> please note that as these extra readers are put on the wait list,
>> their +read_bias adjustments are canceled so that the count value
>> ends up at write_bias + waiting_bias (for a total active count of 1)
>
> The relevance of the waiting readers is that when CPU 1 drops the writer
> ___and grabs the spin lock___, it then wakes up these already-waiting
> readers (CPU 0 is still parked in down_read_failed() waiting to acquire
> the spin lock).
>
> When CPU 1 wakes up these readers, the sem count goes > 0 and the
> waiting list is emptied. CPU 1 then drops the spin lock and leaves
> up_write().

Ah, correct. So the race you noticed is real, and the one I found is
just a more complicated way to hit it.

I'll add a fix in v2 of this patch series (probably later today).

BTW, you seem to have been paying pretty close attention, would you
mind giving appropriate Reviewed-by tags when I send v2 ?
