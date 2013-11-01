Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3KAXk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 19:40:26 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39890 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3KAXkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 19:40:23 -0400
MIME-Version: 1.0
In-Reply-To: <20131029214631.GA19354@kroah.com>
References: <20131029214631.GA19354@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 1 Nov 2013 17:40:02 -0600
Message-ID: <CAErSpo5YpE-aoTbXd5=0xBDe+_aQPEO4PejrG=+JoEM=w2ZxQw@mail.gmail.com>
Subject: Re: [RFC PATCH] PCI: export MSI mode using attributes, not kobjects
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 3:46 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> The PCI MSI sysfs code is a mess with kobjects for things that don't
> really need to be kobjects.  This patch creates attributes dynamically
> for the MSI interrupts instead of using kobjects.
>
> Note, this does not delete the existing sysfs MSI code, but puts the
> attributes under a "msi_irqs_2" directory for testing / example.
>
> Also note, this removes a directory from the current MSI interrupt sysfs
> code:
>
> old MSI kobjects:
> pci_device
>    └── msi_irqs
>        └── 40
>            └── mode
>
> new MSI attributes:
> pci_device
>    └── msi_irqs_2
>        └── 40
>
> As there was only one file "mode" with the kobject model, the interrupt
> number is now a file that returns the "mode" of the interrupt (msi vs.
> msix).
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>
> Bjorn, I can make up a patch that rips out the existing kobject code
> here, but I figured this patch would make things easier to follow
> instead of having to dig through the removed logic at the same time.
>
> I'll clean up the error handling path for the create attribute logic as
> well, this was just a proof of concept that this could be done.
>
> Do you think that anyone cares about the current mode files in sysfs to
> move things in this manner?

I like this a lot better than trying to fix all the holes in the
current kobject code.

I have no idea who, if anybody, cares about the "mode" files.  I
assume there's a way to create the "mode" files with attributes, too?
If so, we could replicate the existing structure with one patch, and
simplify it with a second patch, so it would be easier to revert the
directory change while keeping the fix.

Bjorn

>  drivers/pci/msi.c   |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    1
>  2 files changed, 86 insertions(+)
>
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index d5f90d63..53848ab9 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -353,6 +353,9 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
>  static void free_msi_irqs(struct pci_dev *dev)
>  {
>         struct msi_desc *entry, *tmp;
> +       struct attribute **msi_attrs;
> +       struct device_attribute *dev_attr;
> +       int count = 0;
>
>         list_for_each_entry(entry, &dev->msi_list, list) {
>                 int i, nvec;
> @@ -388,6 +391,22 @@ static void free_msi_irqs(struct pci_dev *dev)
>                 list_del(&entry->list);
>                 kfree(entry);
>         }
> +
> +       if (dev->msi_irq_groups) {
> +               sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
> +               msi_attrs = dev->msi_irq_groups[0]->attrs;
> +               list_for_each_entry(entry, &dev->msi_list, list) {
> +                       dev_attr = container_of(msi_attrs[count],
> +                                               struct device_attribute, attr);
> +                       kfree(dev_attr->attr.name);
> +                       kfree(dev_attr);
> +                       ++count;
> +               }
> +               kfree(msi_attrs);
> +               kfree(dev->msi_irq_groups[0]);
> +               kfree(dev->msi_irq_groups);
> +               dev->msi_irq_groups = NULL;
> +       }
>  }
>
>  static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
> @@ -517,13 +536,79 @@ static struct kobj_type msi_irq_ktype = {
>         .default_attrs = msi_irq_default_attrs,
>  };
>
> +static ssize_t msi_mode_show(struct device *dev, struct device_attribute *attr,
> +                            char *buf)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +       struct msi_desc *entry;
> +       unsigned long irq;
> +       int retval;
> +
> +       retval = kstrtoul(attr->attr.name, 10, &irq);
> +       if (retval)
> +               return retval;
> +
> +       list_for_each_entry(entry, &pdev->msi_list, list) {
> +               if (entry->irq == irq) {
> +                       return sprintf(buf, "%s\n",
> +                                      entry->msi_attrib.is_msix ? "msix" : "msi");
> +               }
> +       }
> +       return -ENODEV;
> +}
> +
>  static int populate_msi_sysfs(struct pci_dev *pdev)
>  {
> +       struct attribute **msi_attrs;
> +       struct device_attribute *msi_dev_attr;
> +       struct attribute_group *msi_irq_group;
> +       const struct attribute_group **msi_irq_groups;
>         struct msi_desc *entry;
>         struct kobject *kobj;
>         int ret;
> +       int num_msi = 0;
>         int count = 0;
>
> +       /* Determine how many msi entries we have */
> +       list_for_each_entry(entry, &pdev->msi_list, list) {
> +               ++num_msi;
> +       }
> +       if (!num_msi)
> +               return 0;
> +
> +       /* Dynamically create the MSI attributes for the PCI device */
> +       msi_attrs = kzalloc(sizeof(void *) * (num_msi + 1), GFP_KERNEL);
> +       if (!msi_attrs)
> +               return -ENOMEM;
> +       list_for_each_entry(entry, &pdev->msi_list, list) {
> +               char *name = kmalloc(20, GFP_KERNEL);
> +               msi_dev_attr = kzalloc(sizeof(*msi_dev_attr), GFP_KERNEL);
> +               if (!msi_dev_attr)
> +                       return -ENOMEM;
> +               sprintf(name, "%d", entry->irq);
> +               msi_dev_attr->attr.name = name;
> +               msi_dev_attr->attr.mode = S_IRUGO;
> +               msi_dev_attr->show = msi_mode_show;
> +               msi_attrs[count] = &msi_dev_attr->attr;
> +               ++count;
> +       }
> +
> +       msi_irq_group = kzalloc(sizeof(*msi_irq_group), GFP_KERNEL);
> +       if (!msi_irq_group)
> +               return -ENOMEM;
> +       msi_irq_group->name = "msi_irqs_2";
> +       msi_irq_group->attrs = msi_attrs;
> +
> +       msi_irq_groups = kzalloc(sizeof(void *) * 2, GFP_KERNEL);
> +       if (!msi_irq_groups)
> +               return -ENOMEM;
> +       msi_irq_groups[0] = msi_irq_group;
> +
> +       ret = sysfs_create_groups(&pdev->dev.kobj, msi_irq_groups);
> +       if (ret)
> +               return ret;
> +       pdev->msi_irq_groups = msi_irq_groups;
> +
>         pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
>         if (!pdev->msi_kset)
>                 return -ENOMEM;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index da172f95..9540110f 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -354,6 +354,7 @@ struct pci_dev {
>  #ifdef CONFIG_PCI_MSI
>         struct list_head msi_list;
>         struct kset *msi_kset;
> +       const struct attribute_group **msi_irq_groups;
>  #endif
>         struct pci_vpd *vpd;
>  #ifdef CONFIG_PCI_ATS
