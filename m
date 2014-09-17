Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaIQIkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:40:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbaIQIkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:40:06 -0400
Message-ID: <541948E3.3080602@nod.at>
Date: Wed, 17 Sep 2014 10:40:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] UBI: Fix possible deadlock in erase_worker()
References: <1410853702-11616-1-git-send-email-richard@nod.at> <1410942507.28850.78.camel@sauron.fi.intel.com>
In-Reply-To: <1410942507.28850.78.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.09.2014 10:28, schrieb Artem Bityutskiy:
> On Tue, 2014-09-16 at 09:48 +0200, Richard Weinberger wrote:
>> If sync_erase() failes with EINTR, ENOMEM, EAGAIN or
>> EBUSY erase_worker() re-schedules the failed work.
>> This will lead to a deadlock because erase_worker() is called
>> with work_sem held in read mode. And schedule_erase() will take
>> this lock again.
> 
> IIRC, the assumption was that the R/W semaphore may be taken in read
> mode many times, so it wouldn't hurt to do:
> 
> down_read()
> down_read()
> up_read()
> up_read()

Hmm, are you sure that this is legal?

Quoting rwsem.h:
/*
 * nested locking. NOTE: rwsems are not allowed to recurse
 * (which occurs if the same task tries to acquire the same
 * lock instance multiple times), but multiple locks of the
 * same lock class might be taken, if the order of the locks
 * is always the same. This ordering rule can be expressed
 * to lockdep via the _nested() APIs, but enumerating the
 * subclasses that are used. (If the nesting relationship is
 * static then another method for expressing nested locking is
 * the explicit definition of lock class keys and the use of
 * lockdep_set_class() at lock initialization time.
 * See Documentation/lockdep-design.txt for more details.)
 */

In this case the same task is taking the same lock multiple times,
which is not allowed according to rwsem.h.

Thanks,
//richard
