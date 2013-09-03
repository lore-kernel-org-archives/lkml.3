Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab3ICQdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:33:18 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53757 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3ICQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:33:14 -0400
Message-ID: <52260F45.6040702@colorfullife.com>
Date: Tue, 03 Sep 2013 18:33:09 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: sedat.dilek@gmail.com, Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave.bueso@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] ipc/msg.c: Fix lost wakeup in msgsnd().
References: <1378216808-2564-1-git-send-email-manfred@colorfullife.com> <CA+icZUUdnK3Kc9OFNjcEsZYigbyytsFk90_HaqqUWh9cvq5+0w@mail.gmail.com>
In-Reply-To: <CA+icZUUdnK3Kc9OFNjcEsZYigbyytsFk90_HaqqUWh9cvq5+0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sedat,

On 09/03/2013 06:13 PM, Sedat Dilek wrote:
> On Tue, Sep 3, 2013 at 4:00 PM, Manfred Spraul <manfred@colorfullife.com> wrote:
>> The check if the queue is full and adding current to the wait queue of pending
>> msgsnd() operations (ss_add()) must be atomic.
>>
>> Otherwise:
>> - the thread that performs msgsnd() finds a full queue and decides to sleep.
>> - the thread that performs msgrcv() calls first reads all messages from the
>>    queue and then sleep, because the queue is empty.
> reads -> sleeps
Correct.
>> - the msgrcv() calls do not perform any wakeups, because the msgsnd() task
>>    has not yet called ss_add().
>> - then the msgsnd()-thread first calls ss_add() and then sleeps.
>> Net result: msgsnd() and msgrcv() both sleep forever.
>>
> I don't know what and why "net result" - net in sense of networking?
http://en.wiktionary.org/wiki/net#Adjective
I.e.: Ignore/remove the "Net".

>> Observed with msgctl08 from ltp with a preemptible kernel.
>>
> ...on ARC arch (that sounds funny somehow).
>
>> Fix: Call ipc_lock_object() before performing the check.
>>
>> The patch also moves security_msg_queue_msgsnd() under ipc_lock_object:
>> - msgctl(IPC_SET) explicitely mentions that it tries to expunge any pending
>>    operations that are not allowed anymore with the new permissions.
>>    If security_msg_queue_msgsnd() is called without locks, then there might be
>>    races.
>> - it makes the patch much simpler.
>>
>> Reported-by: Vineet Gupta <Vineet.Gupta1@synopsys.com>
>> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> I guess this is missing a "CC: stable" as Vineet reported against
> Linux v3.11-rc7 (and should enter v3.11.1)?
Yes. I didn't notice that Linus already released 3.11.

--
     Manfred
> - Sedat -
>
>> ---
>>   ipc/msg.c | 12 +++++-------
>>   1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/ipc/msg.c b/ipc/msg.c
>> index 9f29d9e..b65fdf1 100644
>> --- a/ipc/msg.c
>> +++ b/ipc/msg.c
>> @@ -680,16 +680,18 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
>>                  goto out_unlock1;
>>          }
>>
>> +       ipc_lock_object(&msq->q_perm);
>> +
>>          for (;;) {
>>                  struct msg_sender s;
>>
>>                  err = -EACCES;
>>                  if (ipcperms(ns, &msq->q_perm, S_IWUGO))
>> -                       goto out_unlock1;
>> +                       goto out_unlock0;
>>
>>                  err = security_msg_queue_msgsnd(msq, msg, msgflg);
>>                  if (err)
>> -                       goto out_unlock1;
>> +                       goto out_unlock0;
>>
>>                  if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
>>                                  1 + msq->q_qnum <= msq->q_qbytes) {
>> @@ -699,10 +701,9 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
>>                  /* queue full, wait: */
>>                  if (msgflg & IPC_NOWAIT) {
>>                          err = -EAGAIN;
>> -                       goto out_unlock1;
>> +                       goto out_unlock0;
>>                  }
>>
>> -               ipc_lock_object(&msq->q_perm);
>>                  ss_add(msq, &s);
>>
>>                  if (!ipc_rcu_getref(msq)) {
>> @@ -730,10 +731,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
>>                          goto out_unlock0;
>>                  }
>>
>> -               ipc_unlock_object(&msq->q_perm);
>>          }
>> -
>> -       ipc_lock_object(&msq->q_perm);
>>          msq->q_lspid = task_tgid_vnr(current);
>>          msq->q_stime = get_seconds();
>>
>> --
>> 1.8.3.1
>>

