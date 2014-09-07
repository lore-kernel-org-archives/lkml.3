Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaIGHnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 03:43:03 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62605 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaIGHnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 03:43:01 -0400
MIME-Version: 1.0
In-Reply-To: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 7 Sep 2014 10:42:45 +0300
X-Google-Sender-Auth: fjEilUARGZP-ZMd6e9GNSW2ai1w
Message-ID: <CA+XVXfeA=sakSDwgYqziJ2cyLTximvcWKvj8JiZf9ic1efK+wQ@mail.gmail.com>
Subject: Re: [RFC v2] device coredump: add new device coredump class
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 11:50 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Many devices run firmware and/or complex hardware, and most of that
> can have bugs. When it misbehaves, however, it is often much harder
> to debug than software running on the host.
>

Very nice concept IMO :)

[....]
> +void dev_coredumpm(struct device *dev, struct module *owner,
> +                  const void *data, size_t datalen, gfp_t gfp,
> +                  ssize_t (*read)(char *buffer, loff_t offset, size_t count,
> +                                  const void *data, size_t datalen),
> +                  void (*free)(const void *data))
> +{
> +       static atomic_t devcd_count = ATOMIC_INIT(0);
> +       struct devcd_entry *devcd;
> +       struct device *existing;
> +
> +       existing = class_find_device(&devcd_class, NULL, dev,
> +                                    devcd_match_failing);
> +       if (existing) {
> +               put_device(existing);
> +               return;
> +       }
> +
> +       if (!try_module_get(owner))
> +               return;
> +
> +       devcd = kzalloc(sizeof(*devcd), gfp);
> +       if (!devcd)
> +               goto put_module;
> +
> +       devcd->owner = owner;
> +       devcd->data = data;
> +       devcd->datalen = datalen;
> +       devcd->read = read;
> +       devcd->free = free;
> +       devcd->failing_dev = get_device(dev);
> +
> +       device_initialize(&devcd->devcd_dev);
> +
> +       dev_set_name(&devcd->devcd_dev, "devcd%d",
> +                    atomic_inc_return(&devcd_count));
> +       devcd->devcd_dev.class = &devcd_class;
> +
> +       if (device_add(&devcd->devcd_dev))
> +               goto put_device;
> +
> +       if (sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
> +                             "failing_device"))
> +               /* nothing - symlink will be missing */;
> +
> +       if (sysfs_create_link(&dev->kobj, &devcd->devcd_dev.kobj,
> +                             "dev_coredump"))
> +               /* nothing - symlink will be missing */;

Aren't you confusing the compiler here and above, doing the
INIT_DELAYED_WORK only when link creation failed? I would have thought
some braces are necessary..

> +
> +       INIT_DELAYED_WORK(&devcd->del_wk, devcd_del);
> +       schedule_delayed_work(&devcd->del_wk, DEVCD_TIMEOUT);
> +
> +       return;
> + put_device:
> +       put_device(&devcd->devcd_dev);
> + put_module:
> +       module_put(owner);
> +}
> +EXPORT_SYMBOL(dev_coredumpm);
