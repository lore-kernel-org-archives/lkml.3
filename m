Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927Ab3GRXto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:49:44 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44021 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467Ab3GRXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1337724574-2193-1-git-send-email-hdegoede@redhat.com>
References: <1337724574-2193-1-git-send-email-hdegoede@redhat.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 18 Jul 2013 16:49:18 -0700
X-Google-Sender-Auth: FzLaPErSvvR6mnFzE3C70plIwVI
Message-ID: <CAB=NE6XHnBZW39bm7u=omHihQxiiwoGWNg9=MRgTLE8zE4Rm4w@mail.gmail.com>
Subject: Re: [PATCH] device-core: Ensure drvdata = NULL when no driver is bound
To: Hans de Goede <hdegoede@redhat.com>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, Julia Lawall <julia.lawall@lip6.fr>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 3:09 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> 1) drvdata is for a driver to store a pointer to driver specific data
> 2) If no driver is bound, there is no driver specific data associated with
>    the device
> 3) Thus logically drvdata should be NULL if no driver is bound.
>
> But many drivers don't clear drvdata on device_release, or set drvdata
> early on in probe and leave it set on probe error. Both of which results
> in a dangling pointer in drvdata.
>
> This patch enforce for drvdata to be NULL after device_release or on probe
> failure.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/base/dd.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 1b1cbb5..9a1e970 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -283,6 +283,7 @@ probe_failed:
>         devres_release_all(dev);
>         driver_sysfs_remove(dev);
>         dev->driver = NULL;
> +       dev_set_drvdata(dev, NULL);
>
>         if (ret == -EPROBE_DEFER) {
>                 /* Driver requested deferred probing */
> @@ -487,6 +488,7 @@ static void __device_release_driver(struct device *dev)
>                         drv->remove(dev);
>                 devres_release_all(dev);
>                 dev->driver = NULL;
> +               dev_set_drvdata(dev, NULL);
>                 klist_remove(&dev->p->knode_driver);
>                 if (dev->bus)
>                         blocking_notifier_call_chain(&dev->bus->p->bus_notifier,

Just as a heads up for backports:

Because of this patch a huge series of cleanups were made across the
kernel removing redundant setting of the driver data to NULL that was
spread out through the kernel. An example type patch is
785ec305b26ee23e0efb834b5cd0dd24070ba1bf. This is an example type of
collateral evolution that doesn't cause compilation issues if the
upstream code is used but if not addressed could potentially cause an
issue. That is the only way to catch these are by policing /
proactively reviewing kernel changes.

I'll post a patch that backports this to enable usage of the code
as-is upstream on older kernels without having to put the code that
was being removed for each driver specifically shortly.

  Luis
