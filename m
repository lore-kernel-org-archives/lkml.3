Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaDQQWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:22:09 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38046 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaDQQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140417160828.GP15326@htj.dyndns.org>
References: <20140416165052.GK1257@htj.dyndns.org>
	<1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
	<20140417152744.GM15326@htj.dyndns.org>
	<CACvQF527RneJwUXf0=C6L0_9ncdS6--iqhdpWAFKqHtd25LOYg@mail.gmail.com>
	<20140417160828.GP15326@htj.dyndns.org>
Date: Fri, 18 Apr 2014 00:21:51 +0800
X-Google-Sender-Auth: afTIfF8NkmRG7yCaZPWWrulnwwU
Message-ID: <CACvQF53DOj0+sn5EQKLA+mCBdtuceO29gBmH2HCqCOXBmRMWAQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] workqueue: rescuer_thread() processes all pwqs before exit
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 12:08 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> On Fri, Apr 18, 2014 at 12:04:29AM +0800, Lai Jiangshan wrote:
>> > I don't think this is reliable.  What if mayday requests take place
>> > between wq_mayday_lock and kthread_should_stop() check?  We'll
>> > probably need to run through mayday list after checking should_stop.
>>
>> It is destroy_workqueue()'s responsibility to avoid this.
>> destroy_workqueue() should drain all works and refuse any new work queued
>> on the wq before destroy the wq.
>>
>> So since there is no works, there is no new mayday request,
>> and there is no mayday request take place between wq_mayday_lock
>> and kthread_should_stop() check.
>
> Hmmm?  Isn't this the same race condition that you tried to remove by
> relocating the test?  It doesn't matter what destroy_workqueue() does,
> the rescuer may get preempted inbetween and anything can happen
> inbetween including someone maydaying and initiation of
> destroy_workqueue().  Your patch doesn't change the situation at all.
> It can still return with non-empty mayday list.

You are right. We need a additional atomic check.

Thanks,
Lai

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
