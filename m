Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3AVREH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:04:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3AVREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:04:04 -0500
Message-ID: <50FEC680.7030602@canonical.com>
Date: Tue, 22 Jan 2013 18:04:00 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Francesco Lavra <francescolavra.fl@gmail.com>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [PATCH 6/7] reservation: cross-device reservation
 support
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com> <1358253244-11453-7-git-send-email-maarten.lankhorst@canonical.com> <50FEC28F.3090100@gmail.com>
In-Reply-To: <50FEC28F.3090100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-01-13 17:47, Francesco Lavra schreef:
> On 01/15/2013 01:34 PM, Maarten Lankhorst wrote:
>> This adds support for a generic reservations framework that can be
>> hooked up to ttm and dma-buf and allows easy sharing of reservations
>> across devices.
>>
>> The idea is that a dma-buf and ttm object both will get a pointer
>> to a struct reservation_object, which has to be reserved before
>> anything is done with the contents of the dma-buf.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> ---
>>  Documentation/DocBook/device-drivers.tmpl |   2 +
>>  drivers/base/Makefile                     |   2 +-
>>  drivers/base/reservation.c                | 251 ++++++++++++++++++++++++++++++
>>  include/linux/reservation.h               | 182 ++++++++++++++++++++++
>>  4 files changed, 436 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/base/reservation.c
>>  create mode 100644 include/linux/reservation.h
> [...]
>> diff --git a/include/linux/reservation.h b/include/linux/reservation.h
>> new file mode 100644
>> index 0000000..fc2349d
>> --- /dev/null
>> +++ b/include/linux/reservation.h
>> @@ -0,0 +1,182 @@
>> +/*
>> + * Header file for reservations for dma-buf and ttm
>> + *
>> + * Copyright(C) 2011 Linaro Limited. All rights reserved.
>> + * Copyright (C) 2012 Canonical Ltd
>> + * Copyright (C) 2012 Texas Instruments
>> + *
>> + * Authors:
>> + * Rob Clark <rob.clark@linaro.org>
>> + * Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> + * Thomas Hellstrom <thellstrom-at-vmware-dot-com>
>> + *
>> + * Based on bo.c which bears the following copyright notice,
>> + * but is dual licensed:
>> + *
>> + * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
>> + * All Rights Reserved.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the
>> + * "Software"), to deal in the Software without restriction, including
>> + * without limitation the rights to use, copy, modify, merge, publish,
>> + * distribute, sub license, and/or sell copies of the Software, and to
>> + * permit persons to whom the Software is furnished to do so, subject to
>> + * the following conditions:
>> + *
>> + * The above copyright notice and this permission notice (including the
>> + * next paragraph) shall be included in all copies or substantial portions
>> + * of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
>> + * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
>> + * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
>> + * USE OR OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +#ifndef _LINUX_RESERVATION_H
>> +#define _LINUX_RESERVATION_H
>> +
>> +#include <linux/spinlock.h>
>> +#include <linux/mutex.h>
>> +#include <linux/fence.h>
>> +
>> +#define BUF_MAX_SHARED_FENCE 8
>> +
>> +struct fence;
>> +
>> +extern atomic_long_t reservation_counter;
>> +extern const char reservation_object_name[];
>> +extern struct lock_class_key reservation_object_class;
>> +extern const char reservation_ticket_name[];
>> +extern struct lock_class_key reservation_ticket_class;
>> +
>> +struct reservation_object {
>> +	struct ticket_mutex lock;
>> +
>> +	u32 fence_shared_count;
>> +	struct fence *fence_excl;
>> +	struct fence *fence_shared[BUF_MAX_SHARED_FENCE];
>> +};
>> +
>> +struct reservation_ticket {
>> +	unsigned long seqno;
>> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
>> +	struct lockdep_map dep_map;
>> +#endif
>> +};
>> +
>> +/**
>> + * struct reservation_entry - reservation structure for a
>> + * reservation_object
>> + * @head:	list entry
>> + * @obj_shared:	pointer to a reservation_object to reserve
>> + *
>> + * Bit 0 of obj_shared is set to bool shared, as such pointer has to be
>> + * converted back, which can be done with reservation_entry_get.
>> + */
>> +struct reservation_entry {
>> +	struct list_head head;
>> +	unsigned long obj_shared;
>> +};
>> +
>> +
>> +static inline void
>> +reservation_object_init(struct reservation_object *obj)
>> +{
>> +	obj->fence_shared_count = 0;
>> +	obj->fence_excl = NULL;
>> +
>> +	__ticket_mutex_init(&obj->lock, reservation_object_name,
>> +			    &reservation_object_class);
>> +}
>> +
>> +static inline void
>> +reservation_object_fini(struct reservation_object *obj)
>> +{
>> +	int i;
>> +
>> +	if (obj->fence_excl)
>> +		fence_put(obj->fence_excl);
>> +	for (i = 0; i < obj->fence_shared_count; ++i)
>> +		fence_put(obj->fence_shared[i]);
>> +
>> +	mutex_destroy(&obj->lock.base);
>> +}
>> +
>> +static inline void
>> +reservation_ticket_init(struct reservation_ticket *t)
>> +{
>> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
>> +	/*
>> +	 * Make sure we are not reinitializing a held ticket:
>> +	 */
>> +
>> +	debug_check_no_locks_freed((void *)t, sizeof(*t));
>> +	lockdep_init_map(&t->dep_map, reservation_ticket_name,
>> +			 &reservation_ticket_class, 0);
>> +#endif
>> +	mutex_acquire(&t->dep_map, 0, 0, _THIS_IP_);
> If CONFIG_DEBUG_LOCK_ALLOC is not defined, t->dep_map is not there.
And mutex_acquire will not expand either, so it's harmless. :-)
>> +	do {
>> +		t->seqno = atomic_long_inc_return(&reservation_counter);
>> +	} while (unlikely(!t->seqno));
>> +}
> --
> Francesco
>

