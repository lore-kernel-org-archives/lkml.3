Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3LTBsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:48:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62435 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932079Ab3LTBsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:48:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Patch v2 03/13] PCI, pci-label: release allocated ACPI object on error recovery path
Date: Fri, 20 Dec 2013 03:01:55 +0100
Message-ID: <1896409.Ntvojm0Xli@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAErSpo4oKsJCKxUhxT8E745BkX+veOD-tMEeHULHOuH-3suMRA@mail.gmail.com>
References: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com> <1387456702-4709-4-git-send-email-jiang.liu@linux.intel.com> <CAErSpo4oKsJCKxUhxT8E745BkX+veOD-tMEeHULHOuH-3suMRA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 19, 2013 11:22:22 AM Bjorn Helgaas wrote:
> On Thu, Dec 19, 2013 at 5:38 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> > Function dsm_get_label() leaks the returned ACPI object if
> > obj->package.count is not 2, so fix the possible memory leak.
> >
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> 
> Rafael, if you want to take these through your tree, feel free.

I'm going to do that, thanks!

> I'm guessing it probably makes sense to keep the whole series together.

Agreed.

> > ---
> >  drivers/pci/pci-label.c |   12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
> > index d51f45a..f6e01a5 100644
> > --- a/drivers/pci/pci-label.c
> > +++ b/drivers/pci/pci-label.c
> > @@ -233,11 +233,7 @@ dsm_get_label(acpi_handle handle, int func,
> >                 return -1;
> >
> >         obj = (union acpi_object *)output->pointer;
> > -
> > -       switch (obj->type) {
> > -       case ACPI_TYPE_PACKAGE:
> > -               if (obj->package.count != 2)
> > -                       break;
> > +       if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2) {
> >                 len = obj->package.elements[0].integer.value;
> >                 if (buf) {
> >                         if (attribute == ACPI_ATTR_INDEX_SHOW)
> > @@ -250,10 +246,10 @@ dsm_get_label(acpi_handle handle, int func,
> >                 }
> >                 kfree(output->pointer);
> >                 return len;
> > -       break;
> > -       default:
> > -               kfree(output->pointer);
> >         }
> > +
> > +       kfree(output->pointer);
> > +
> >         return -1;
> >  }
> >
> > --
> > 1.7.10.4
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
