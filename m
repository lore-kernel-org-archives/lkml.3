Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbaISMlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:41:12 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:62702 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaISMlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:41:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140918174127.GB340@redhat.com>
References: <20140917174647.GC19308@redhat.com>
	<1411047228-2576-1-git-send-email-r.peniaev@gmail.com>
	<20140918174127.GB340@redhat.com>
Date: Fri, 19 Sep 2014 21:41:09 +0900
Message-ID: <CACZ9PQWDynSqUREO_79e5DFKqhV62ra3ecYYaNttOdNx4wS6_A@mail.gmail.com>
Subject: Re: [v3 PATCH 1/1] init: fix race between rootfs mount and firmware loading
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

On Fri, Sep 19, 2014 at 2:41 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/18, Roman Pen wrote:
>>
>> +void wait_for_rootfs(void)
>> +{
>> +     /* Avoid waiting for ourselves */
>> +     if (WARN_ON(is_global_init(current)))
>> +             return;
>> +     else
>> +             wait_event(rootfs_waitq, rootfs_mounted);
>> +}
>
> Ah, wait, the is_global_init() check doesn't look right in any case.
>
> What if /sbin/init does sys_init_module() and this module does
> request_firmware() ?

Yeah, right. It turned out to be more tricky than I expected.
Will fix.

>
> I think we should only warn if init is going to wait,
>
>         /* Avoid waiting for ourselves */
>         if (rootfs_mounted || WARN_ON(is_global_init(current)))
>                 return;
>
>         __wait_event(rootfs_waitq, rootfs_mounted);
>
>
>> +EXPORT_SYMBOL(wait_for_rootfs);
>
> Why?

CONFIG_FW_LOADER (which includes firmware_class.c to compilation
sequence) is declared as tristate,
thus it can be built as module. Seems I can break  loading of this
module if skip exporting, right?

--
Roman
