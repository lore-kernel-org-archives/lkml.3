Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3ILMUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:20:24 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54189 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab3ILMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:20:22 -0400
Message-ID: <5231B181.7080705@colorfullife.com>
Date: Thu, 12 Sep 2013 14:20:17 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: davidlohr.bueso@hp.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] ipc,msg: shorten critical region in msgsnd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

I think the patch (3dd1f784ed6603d7ab1043e51e6371235edf2313) is still 
unsafe, i.e. my correction (bebcb928c820d0ee83aca4b192adc195e43e66a2) 
doesn't fix everything:

AFAICS, ipc_obtain_object_check:
- look up the id in the idr tree
- check if it is deleted
- return without taking any locks.

This means that the "is not deleted" information can be stale immediately.

Thus do_msgsnd() in ipc/msg.c contains a memory leak:
>        rcu_read_lock();
>         msq = msq_obtain_object_check(ns, msqid);
>         if (IS_ERR(msq)) {
>                 err = PTR_ERR(msq);
>                 goto out_unlock1;
>         }
<<<< what if the code is preempted here and RMID is processed?
The code below would queue the message into an already removed queue.
The queue is freed by the rcu callback, but the message memory is leaked.

> ipc_lock_object(&msq->q_perm);
>

Is this analysis correct?

And: What about the other users of obtain_object_check?
exit_sem() is also quite long, but I didn't spot any obvious problems.

--
     Manfred
