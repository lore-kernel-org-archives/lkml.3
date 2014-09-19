Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaISJq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:46:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaISJqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:46:25 -0400
Message-ID: <541BFB6D.3040903@nod.at>
Date: Fri, 19 Sep 2014 11:46:21 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] UBI: Fix possible deadlock in erase_worker()
References: <1410853702-11616-1-git-send-email-richard@nod.at> <1410946526.28850.120.camel@sauron.fi.intel.com>
In-Reply-To: <1410946526.28850.120.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.09.2014 11:35, schrieb Artem Bityutskiy:
> On Tue, 2014-09-16 at 09:48 +0200, Richard Weinberger wrote:
>> If sync_erase() failes with EINTR, ENOMEM, EAGAIN or
>> EBUSY erase_worker() re-schedules the failed work.
>> This will lead to a deadlock because erase_worker() is called
>> with work_sem held in read mode. And schedule_erase() will take
>> this lock again.
> 
> There is this code snippet:
> 
>         ubi_err("failed to erase PEB %d, error %d", pnum, err);
>         kfree(wl_wrk);
> 
>         if (err == -EINTR || err == -ENOMEM || err == -EAGAIN ||
>             err == -EBUSY) {
>                 int err1;
> 
>                 /* Re-schedule the LEB for erasure */
>                 err1 = schedule_erase(ubi, e, vol_id, lnum, 0);
>                 if (err1) {
>                         err = err1;
>                         goto out_ro;
>                 }
>                 return err;
>         }
> 
> How about move 'kfree(wl_wrk)' down, and execute
> 
>         __schedule_ubi_work(ubi, wl_wrk)
> 
> inside the 'if' clause instead? The fix would seem to be more elegant
> then.
> 
> Hmm?

Yes, that would work too.
Or we apply "[PATCH 1/2] UBI: Call worker functions without work_sem held". :)

Thanks,
//richard
