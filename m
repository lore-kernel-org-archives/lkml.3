Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaHNNiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:38:54 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:54737 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaHNNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140814132239.GA24465@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com>
	<20140812191218.GA15210@redhat.com>
	<53EA94DD.5040900@redhat.com>
	<20140813172230.GA6296@redhat.com>
	<20140813133526.1eb5526f@cuia.bos.redhat.com>
	<20140813180807.GA8098@redhat.com>
	<53EBADB1.2020403@redhat.com>
	<20140813184511.GA9663@redhat.com>
	<20140813170324.544aaf2d@cuia.bos.redhat.com>
	<20140814132239.GA24465@redhat.com>
Date: Thu, 14 Aug 2014 15:38:50 +0200
Message-ID: <CAFTL4hwvPobNwm39qzLdP1mPLya7Wg-bLQnWn-Bt5mSV_i3QsA@mail.gmail.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with seqlock
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-14 15:22 GMT+02:00 Oleg Nesterov <oleg@redhat.com>:
> On 08/13, Rik van Riel wrote:
>>
>> On Wed, 13 Aug 2014 20:45:11 +0200
>> Oleg Nesterov <oleg@redhat.com> wrote:
>>
>> > That said, it is not that I am really sure that seqcount_t in ->signal
>> > is actually worse, not to mention that this is subjective anyway. IOW,
>> > I am not going to really fight with your approach ;)
>>
>> This is what it looks like, on top of your for_each_thread series
>> from yesterday:
>
> OK, lets forget about alternative approach for now. We can reconsider
> it later. At least I have to admit that seqlock is more straighforward.
>
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -646,6 +646,7 @@ struct signal_struct {
>>        * Live threads maintain their own counters and add to these
>>        * in __exit_signal, except for the group leader.
>>        */
>> +     seqlock_t stats_lock;
>
> Ah. Somehow I thought that you were going to use seqcount_t and fallback
> to taking ->siglock if seqcount_retry, but this patch adds the "full blown"
> seqlock_t.
>
> OK, I won't argue, this can make the seqbegin_or_lock simpler...

Is this really needed? seqlock are useful when we have concurrent
updaters. But updaters of thread stats should be under the thread lock
already, right? If we have only one updater at a time, seqcount should
be enough.
