Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3ERNsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 09:48:12 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:35662 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3ERNsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 09:48:10 -0400
Message-ID: <51978696.6040705@colorfullife.com>
Date: Sat, 18 May 2013 15:48:06 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: riel@redhat.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ipc/sem.c: Lockup with complex ops, comments not updated
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

I like your change to the ipc/sem locking:
A scheme with a per-semaphore lock and without the overhead of always 
acquiring both the global and the per-semaphore lock.

But:
1) I found one bug with your sem locking changes:
If
- a complex operation is sleeping [would be woken up by update_queue(,-1)]
- a simple op is sleeping
- the success of the simple op would allow the complex op to complete
     [i.e.: update_queue(,sem_num) changes the semaphore value to the 
value that the complex op waits on]
- an operation wakes up the simple op.

then the complex op is not woken up.

One fix would be a loop in do_smart_update():
- first check the global queue
- then the per-semaphore queues
- if one of the per-semaphore queues made progress: check the global 
queue again
- if the global queue made progress: check the per semaphore queues again
...

2) Your patches remove FIFO ordering of the wakeups:
As far as I can see complex ops are now preferred over simple ops.
It's not a bug, noone exept linux implements FIFO.
But the comment it line 28 should be updated

Should I write a patch, do you want to fix it yourself?

--
     Manfred
