Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaAHX4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:56:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53375 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932128AbaAHX4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:56:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH][tentative] PCI / ACPI: Rework PCI host bridge removal to avoid sysfs warnings
Date: Thu, 09 Jan 2014 01:10:26 +0100
Message-ID: <1473769.SaDXEol2iJ@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAE9FiQXYskZcfccVO6OacYchfA=cd0Ns9EF1CbwERS7MR05bUA@mail.gmail.com>
References: <37552283.kG1L4S8Daa@vostro.rjw.lan> <4679785.iPCX7mECEL@vostro.rjw.lan> <CAE9FiQXYskZcfccVO6OacYchfA=cd0Ns9EF1CbwERS7MR05bUA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 08, 2014 03:41:52 PM Yinghai Lu wrote:
> On Mon, Jan 6, 2014 at 12:41 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> >> Not sure how that could happen.
> >>
> >> If it would really happen, we could set dev->match_driver to 0 in pci_stop_dev.
> >
> > Simply, run "modprobe -r driver && modprobe driver" in a loop and
> > remove the PCI host bridge the given device is on in parallel to that.  Chances
> > are, you'll see some nice breakage.
> 
> I would suggest using match_driver prevent driver from attaching again.

Yes, we can do that.  Some locking is needed for it to be non-racy, however.

Anyway, we still have the problem with race conditions between different PCI
removal/rescan code paths.  And I'm still going to prepare a patch to use
the remove-rescan mutex to address those race conditions and that patch should
help here too.

> 
> ---
>  drivers/pci/remove.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/drivers/pci/remove.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/remove.c
> +++ linux-2.6/drivers/pci/remove.c
> @@ -11,6 +11,7 @@ static void pci_stop_dev(struct pci_dev
>          pci_proc_detach_device(dev);
>          pci_remove_sysfs_dev_files(dev);
>          device_release_driver(&dev->dev);
> +        dev->match_driver = false;
>          dev->is_added = 0;
>      }
> 
> 
> >
> > Also what happens if somebody uses the "remove" sysfs attribute on a device
> > needed by ioapic/dmar?
> 
> Good question, we will have problem in that case.
> To make it simple, we may hide the "remove" in sysfs for ioapic pci device ?

Yeah, we need to do that if using that attribute may lead to problems.

Thanks,
Rafael

