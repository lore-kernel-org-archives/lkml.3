Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaARHZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 02:25:55 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53466 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaARHZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 02:25:52 -0500
MIME-Version: 1.0
Date: Sat, 18 Jan 2014 12:55:51 +0530
Message-ID: <CAJ8eaTzT4Os5RjtTu5gWpA=t-8Gg9rwmthEHVUOf+3+XhRpu6Q@mail.gmail.com>
Subject: BUG: spinlock lockup
From: naveen yadav <yad.naveen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, will.deacon@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

We are using 3.8.x  kernel on ARM, We are facing soft lockup issue.
Following are the logs.

BUG: spinlock lockup suspected on CPU#0, process1/525
lock: 0xd8ac9a64, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1


1 . Looks like lock is available as owner is -1, why arch_spin_trylock
is getting failed ?

2. There is a patch : ARM: spinlock: retry trylock operation if strex
fails on free lock
http://permalink.gmane.org/gmane.linux.ports.arm.kernel/240913
In this patch, A loop has been added around strexeq %2, %0, [%3]".
{Comment "retry the trylock operation if the lock appears
to be free but the strex reported failure"}

but arch_spin_trylock is called by __spin_lock_debug and its already
getting called in loops. So what purpose is resolves?

static void __spin_lock_debug(raw_spinlock_t *lock)
{
        u64 i;
        u64 loops = loops_per_jiffy * HZ;

        for (i = 0; i < loops; i++) {
                if (arch_spin_trylock(&lock->raw_lock))
                        return;
                __delay(1);
        }
        /* lockup suspected: */
        spin_dump(lock, "lockup suspected");
}

3. Is this patch useful to us, How can we reproduce this scenario ?
Scenario : Lock is available but arch_spin_trylock  is returning as failure

Thanks
