Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3F1UQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:16:31 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62770 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3F1UQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <6889707.ugqJleQ6Ld@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan>
	<6889707.ugqJleQ6Ld@vostro.rjw.lan>
Date: Fri, 28 Jun 2013 13:16:29 -0700
X-Google-Sender-Auth: INzCnZB_wqUq4YKVeXQaZKvqyyo
Message-ID: <CAE9FiQVg+OyztG_W43BHWm4Xhxsh42rS-h+-_pNoma1i5yCZog@mail.gmail.com>
Subject: Re: [PATCH 4/4] ACPI / dock: Simplify dock_init_hotplug() and dock_release_hotplug()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 12:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Make dock_init_hotplug() and dock_release_hotplug() slightly simpler
> and move some checks in those functions to the code paths where they
> are needed.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/acpi/dock.c |   24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
>
> Index: linux-pm/drivers/acpi/dock.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/dock.c
> +++ linux-pm/drivers/acpi/dock.c
> @@ -134,19 +134,16 @@ static int dock_init_hotplug(struct dock
>         int ret = 0;
>
>         mutex_lock(&hotplug_lock);
> -
> -       if (dd->hp_context) {
> +       if (WARN_ON(dd->hp_context)) {
>                 ret = -EEXIST;
>         } else {
>                 dd->hp_refcount = 1;
>                 dd->hp_ops = ops;
>                 dd->hp_context = context;
>                 dd->hp_release = release;
> +               if (init)
> +                       init(context);
>         }
> -
> -       if (!WARN_ON(ret) && init)
> -               init(context);
> -
>         mutex_unlock(&hotplug_lock);
>         return ret;
>  }
> @@ -161,22 +158,17 @@ static int dock_init_hotplug(struct dock
>   */
>  static void dock_release_hotplug(struct dock_dependent_device *dd)
>  {
> -       void (*release)(void *) = NULL;
> -       void *context = NULL;
> -
>         mutex_lock(&hotplug_lock);
> -
>         if (dd->hp_context && !--dd->hp_refcount) {
> +               void (*release)(void *) = dd->hp_release;
> +               void *context = dd->hp_context;
> +
>                 dd->hp_ops = NULL;
> -               context = dd->hp_context;
>                 dd->hp_context = NULL;
> -               release = dd->hp_release;
>                 dd->hp_release = NULL;
> +               if (release)
> +                       release(context);
>         }
> -
> -       if (release && context)
> -               release(context);
> -
>         mutex_unlock(&hotplug_lock);
>  }
>
>
