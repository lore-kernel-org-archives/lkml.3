Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaHNQXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:23:25 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37727 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaHNQXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAFdhcLQ11MnF7Py+X1wrJMiu0L15-JrV883oYGopdz1oag0njQ@mail.gmail.com>
References: <1407978746-20587-1-git-send-email-minchan@kernel.org>
	<1407978746-20587-3-git-send-email-minchan@kernel.org>
	<CALZtONDB5q56f1TUHgqbiJ4ZaP6Yk=GcNQw9DhvLhNyExdfQ4w@mail.gmail.com>
	<CAFdhcLQ11MnF7Py+X1wrJMiu0L15-JrV883oYGopdz1oag0njQ@mail.gmail.com>
Date: Thu, 14 Aug 2014 12:23:23 -0400
Message-ID: <CAFdhcLQ2cU8APUP=qVQqQmWT8jouFvdSHPVsQ8RCXceaVWa4dQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] zram: add mem_used_max via sysfs
From: David Horner <ds2horner@gmail.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 11:32 AM, David Horner <ds2horner@gmail.com> wrote:
> On Thu, Aug 14, 2014 at 11:09 AM, Dan Streetman <ddstreet@ieee.org> wrote:
>> On Wed, Aug 13, 2014 at 9:12 PM, Minchan Kim <minchan@kernel.org> wrote:
>>> -       if (zram->limit_bytes &&
>>> -               zs_get_total_size_bytes(meta->mem_pool) > zram->limit_bytes) {
>>> +       total_bytes = zs_get_total_size_bytes(meta->mem_pool);
>>> +       if (zram->limit_bytes && total_bytes > zram->limit_bytes) {
>>
>> do you need to take the init_lock to read limit_bytes here?  It could
>> be getting changed between these checks...
>
> There is no real danger in freeing with an error.
> It is more timing than a race.
I probably should explain my reasoning.

any changes between getting the total value and the limit test are not
problematic (From race perspective).

1) If the actual total increases and the value returned under rates it, then
a) if this.total exceeds the limit - no problem it is rolled back as
it would if the actual total were used.
b) if this.total <= limit OK - as other process will be dinged (it
will see its own allocation)

2)  If the actual total decreases and the value returned overrates
rates it, then
a) if this.value <= limit then allocation great (actual has even more room)
b) if this.value > max it will be rolled back (as the other might be
as well) and process can compete again.

Is there a denial of service possible if 2.b repeats indefinitely.
Yes, but how to set it up reliably? And it is no different than a
single user exhausting the limit before any other users.
Yes, it is potentially a live false limit exhaustion, with one process
requesting an amount exceeding the limit but able to be allocated.
 But this is no worse than the rollback load we already have at the limit.

It would be better to check before the zs_malloc if the concern is
avoiding heavy processing in that function (as an optimization),  as
well as here.after allocation

But I see no real race or danger doing this unlocked.
