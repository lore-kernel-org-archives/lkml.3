Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaIQNS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:18:26 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48388 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaIQNSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140915163935.GB22768@redhat.com>
References: <1410792308-21577-1-git-send-email-r.peniaev@gmail.com>
	<20140915163935.GB22768@redhat.com>
Date: Wed, 17 Sep 2014 22:18:23 +0900
Message-ID: <CACZ9PQXJzoczS7gN5UCFygTHrLW5Rtjew5BF-txfL=cryE331w@mail.gmail.com>
Subject: Re: [PATCH 1/1] init: fix race between rootfs mount and firmware loading
From: Roman Peniaev <r.peniaev@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 1:39 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/15, Roman Pen wrote:
>>
>> +static DECLARE_COMPLETION(rootfs_mounted);
>> +
>> +void wait_for_rootfs(void)
>> +{
>> +     /* Avoid waiting for ourselves */
>> +     if (is_global_init(current))
>> +             pr_warn("it is not a good idea to wait for rootfs mount from init task\n");
>> +     else
>> +             wait_for_completion(&rootfs_mounted);
>> +}
>> +
>> +static inline void wake_up_rootfs_waiters(void)
>> +{
>> +     complete(&rootfs_mounted);
>> +}
>
> Probably you need complete_all() ?

Yes, of course. My fault.

>
> Otherwise wait_for_rootfs() can return only once, the next call will block
> forever. And perhaps it would be better to use another primitive, even if
> UINT_MAX/2 should be enough.

And why do you think completion is not good for this?
Seems it is impossible to have so many threads on early init, which wait
for rootfs.

Oleg, I prepared version 2 (will be in reply to this email). What I did there:

1/ wait_for_rootfs should be exported, because framework_class.c is a tristate,
    thus can be built as module.

2/ replaced completion on wait_event and wake_up_all pair.

3/ did some minor tweaks.

--
Roman
