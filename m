Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbaJ2Wdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:33:40 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34330 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbaJ2Wdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 15:33:17 -0700
Message-ID: <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
Subject: Re: kdbus: add code to gather metadata
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Daniel Mack <daniel@zonque.org>
>
> A connection chooses which metadata it wants to have attached to each
> message it receives with kdbus_cmd_hello.attach_flags. The metadata
> will be attached as items to the messages. All metadata refers to
> information about the sending task at sending time, unless otherwise
> stated. Also, the metadata is copied, not referenced, so even if the
> sending task doesn't exist anymore at the time the message is received,
> the information is still preserved.
>
> See kdbus.txt for more details on which metadata can currently be
> attached to messages.
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/misc/kdbus/metadata.c | 626 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/misc/kdbus/metadata.h |  51 ++++
>  2 files changed, 677 insertions(+)
>  create mode 100644 drivers/misc/kdbus/metadata.c
>  create mode 100644 drivers/misc/kdbus/metadata.h
>
> diff --git a/drivers/misc/kdbus/metadata.c b/drivers/misc/kdbus/metadata.c
> new file mode 100644
> index 000000000000..8323e6d7a071
> --- /dev/null
> +++ b/drivers/misc/kdbus/metadata.c
> @@ -0,0 +1,626 @@
> +/*
> + * Copyright (C) 2013-2014 Kay Sievers
> + * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> + * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
> + * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
> + * Copyright (C) 2013-2014 Linux Foundation
> + *
> + * kdbus is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU Lesser General Public License as published by the
> + * Free Software Foundation; either version 2.1 of the License, or (at
> + * your option) any later version.
> + */
> +
> +#include <linux/audit.h>
> +#include <linux/capability.h>
> +#include <linux/cgroup.h>
> +#include <linux/cred.h>
> +#include <linux/file.h>
> +#include <linux/init.h>
> +#include <linux/mutex.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/sched.h>
> +#include <linux/security.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/user_namespace.h>
> +#include <linux/version.h>
> +
> +#include "connection.h"
> +#include "item.h"
> +#include "message.h"
> +#include "metadata.h"
> +#include "names.h"
> +
> +/**
> + * kdbus_meta_new() - create new metadata object
> + * @meta:              New metadata object
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int kdbus_meta_new(struct kdbus_meta **meta)
> +{
> +       struct kdbus_meta *m;
> +
> +       BUG_ON(*meta);
> +
> +       m = kzalloc(sizeof(*m), GFP_KERNEL);
> +       if (!m)
> +               return -ENOMEM;
> +
> +       /*
> +        * Remember the PID and user namespaces our credentials belong to;
> +        * we need to prevent leaking authorization and security-relevant
> +        * data across different namespaces.
> +        */
> +       m->pid_namespace = get_pid_ns(task_active_pid_ns(current));
> +       m->user_namespace = get_user_ns(current_user_ns());
> +

This is unusual, and it could be very expensive (it will serialize
essentially everyone on an exclusive cacheline).  What attack is it
protecting against?

> +static int kdbus_meta_append_cred(struct kdbus_meta *meta)
> +{
> +       struct kdbus_creds creds = {
> +               .uid = from_kuid_munged(current_user_ns(), current_uid()),
> +               .gid = from_kgid_munged(current_user_ns(), current_gid()),
> +               .pid = task_pid_vnr(current),
> +               .tid = task_tgid_vnr(current),
> +               .starttime = current->start_time,
> +       };
> +
> +       return kdbus_meta_append_data(meta, KDBUS_ITEM_CREDS,
> +                                     &creds, sizeof(creds));
> +}

This seems wrong to me.  Shouldn't this store kuid_t, etc. directly?
Also, why pid, tid, and starttime?

> +
> +       for (i = 0; i < info->ngroups; i++)
> +               gid[i] = from_kgid_munged(current_user_ns(), GROUP_AT(info, i));

Ditto.

--Andy
