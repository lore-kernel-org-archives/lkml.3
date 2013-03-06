Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3CFHQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:16:38 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:62365 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3CFHQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:16:35 -0500
Message-ID: <5136ED2F.8080400@huawei.com>
Date: Wed, 6 Mar 2013 15:15:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
References: <5136B7C1.6030403@huawei.com> <20130306062224.GJ1227@htj.dyndns.org> <5136E9A4.7000201@huawei.com> <CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
In-Reply-To: <CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/6 15:02, Tejun Heo wrote:
> On Tue, Mar 5, 2013 at 11:00 PM, Li Zefan <lizefan@huawei.com> wrote:
>>> Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
>>> irq context?
>>
>> becase cgroup_event_wake() is a callback to a wait queue, and it's wake_up()
>> that acquires wqh->lock with irq disabled.
> 
> So, acquiring a lock with irq disabled doesn't make it a irq lock.
> Being grabbed *from* irq handler makes it a irq lock. Would the
> wake_up() happen from irq handler?
> 

wqh->lock is used through out fs/eventfd.c. I don't know if currently there's
any kernel user using eventfd APIs in an irq handler, but at least that should
be allowed.

wake_up() is also allowed to be called from irq handler?

"allowed" should be enough reason we forbid:

	spin_lock_irqsave(...)
	spin_lock(...)

