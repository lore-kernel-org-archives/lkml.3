Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3HBNdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:33:47 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52098 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab3HBNdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:33:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH] ACPI: Do not fail acpi_bind_one() if device is already bound correctly
Date: Fri, 02 Aug 2013 15:43:58 +0200
Message-ID: <2560973.EJVuxm6PHt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOLK0pxJM6ip-dzcEfswULnJR-qb=X_EXnBbdeSNMRKExPxq3Q@mail.gmail.com>
References: <1888947.F5IBMfDKlY@vostro.rjw.lan> <CAOLK0pxJM6ip-dzcEfswULnJR-qb=X_EXnBbdeSNMRKExPxq3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 10:48:49 AM Lan Tianyu wrote:
> 2013/8/2 Rafael J. Wysocki <rjw@sisk.pl>:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Modify acpi_bind_one() so that it doesn't fail if the device
> > represented by its first argument has already been bound to the
> > given ACPI handle (second argument), because that is not a good
> > enough reason for returning an error code.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/glue.c |   15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> >
> > Index: linux-pm/drivers/acpi/glue.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/glue.c
> > +++ linux-pm/drivers/acpi/glue.c
> > @@ -143,7 +143,10 @@ int acpi_bind_one(struct device *dev, ac
> >         list_for_each_entry(pn, &acpi_dev->physical_node_list, node)
> >                 if (pn->dev == dev) {
> >                         dev_warn(dev, "Already associated with ACPI node\n");
> > -                       goto err_free;
> > +                       if (ACPI_HANDLE(dev) == handle)
> > +                               retval = 0;
> > +
> > +                       goto out_free;
> >                 }
> >
> >         /* allocate physical node id according to physical_node_id_bitmap */
> > @@ -152,7 +155,7 @@ int acpi_bind_one(struct device *dev, ac
> >                 ACPI_MAX_PHYSICAL_NODE);
> >         if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
> >                 retval = -ENOSPC;
> > -               goto err_free;
> > +               goto out_free;
> >         }
> >
> >         set_bit(physical_node->node_id, acpi_dev->physical_node_id_bitmap);
> > @@ -185,10 +188,14 @@ int acpi_bind_one(struct device *dev, ac
> >         put_device(dev);
> >         return retval;
> >
> > - err_free:
> > + out_free:
> >         mutex_unlock(&acpi_dev->physical_node_lock);
> >         kfree(physical_node);
> > -       goto err;
> > +       if (retval)
> > +               goto err;
> > +
> > +       put_device(dev);
> > +       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(acpi_bind_one);
> 
> Hi Rafael:
>             How about the following change?

It is incorrect, because the "problem" it attempts to "fix" is actually
intentional behavior.  [And you could ask if it was intentional in the first
place instead of assuming that it was a mistake.  It wasn't.]

Do you have any problems with my $subject patch?

Rafael


> 
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index f70cc45..35f375e 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -183,19 +183,15 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
> 
>         return 0;
> 
> - err:
> -       ACPI_HANDLE_SET(dev, NULL);
> -       put_device(dev);
> -       return retval;
> -
>   out_free:
>         mutex_unlock(&acpi_dev->physical_node_lock);
>         kfree(physical_node);
> -       if (retval)
> -               goto err;
> 
> + err:
> +       if (retval)
> +               ACPI_HANDLE_SET(dev, NULL);
>         put_device(dev);
> -       return 0;
> +       return retval;
>  }
>  EXPORT_SYMBOL_GPL(acpi_bind_one);
> ---------------
> 
> When I reviewed this patch, found the dev's acpi handle always
> is set  to NULL if there is error. This seems make no sense for
> the case that the handle has been set to dev before binding.
> 
> For this case, the acpi handle has been found before binding.
> Actually, the device driver could control any resources under ACPI
> node even if the binding failed. So adding one flag to differentiate
> it.
> 
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index 35f375e..c868e51 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -113,6 +113,7 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
>         acpi_status status;
>         struct acpi_device_physical_node *physical_node, *pn;
>         char physical_node_name[sizeof(PHYSICAL_NODE_STRING) + 2];
> +       bool has_handle = false;
>         int retval = -EINVAL;
> 
>         if (ACPI_HANDLE(dev)) {
> @@ -121,6 +122,7 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
>                         return -EINVAL;
>                 } else {
>                         handle = ACPI_HANDLE(dev);
> +                       has_handle = true;
>                 }
>         }
>         if (!handle)
> @@ -188,7 +190,7 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
>         kfree(physical_node);
> 
>   err:
> -       if (retval)
> +       if (retval && !has_handle)
>                 ACPI_HANDLE_SET(dev, NULL);
>         put_device(dev);
>         return retval;
> 
> 
> 
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
