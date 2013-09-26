Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3IZWQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:16:20 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:50898 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3IZWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:16:19 -0400
Date: Thu, 26 Sep 2013 16:16:13 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] msi: add forgotten pci_dev_put(pdev) to
 populate_msi_sysfs()
Message-ID: <20130926221613.GA24611@google.com>
References: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
 <1379382464-7920-2-git-send-email-vfalico@redhat.com>
 <CAErSpo6+AQhpO2WvoKCSw7WokDiex_E43oi9xpuka7biPEx=7Q@mail.gmail.com>
 <20130925232300.GA7368@neilslaptop.think-freely.org>
 <CAErSpo6coKuf4f3j3zMwMNp7Uj3btN9UQyHpLPdq84aU-s=5UA@mail.gmail.com>
 <20130926122552.GB4783@redhat.com>
 <20130926140751.GC4783@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926140751.GC4783@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Russell]

On Thu, Sep 26, 2013 at 04:07:51PM +0200, Veaceslav Falico wrote:
> On Thu, Sep 26, 2013 at 02:25:52PM +0200, Veaceslav Falico wrote:
> >On Wed, Sep 25, 2013 at 05:35:54PM -0600, Bjorn Helgaas wrote:
> >>On Wed, Sep 25, 2013 at 5:23 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >>>On Wed, Sep 25, 2013 at 03:08:05PM -0600, Bjorn Helgaas wrote:
> >>>>On Mon, Sep 16, 2013 at 7:47 PM, Veaceslav Falico <vfalico@redhat.com> wrote:
...
> >As an update - I've found an interesting case why exactly that
> >kobject_del() might be needed:
> >
> >in kobject_del() it removes instantly the link to kset - via
> >kobj_kset_leave(), so that our kset remains without links and, thus, might
> >be instantly removed.
> >
> >So, with kobject_del(), our kset (msi_irqs sysfs dir) remains instantly
> >without any links (i.e. other kobjects) and, when we call kset_unregister()
> >- it exits instantly (if it's not being hold somewhere elsewhere...).
> >
> >Without it, kset_unregister() will wait till all the kobjects will be gone.

I don't see any waiting in kset_unregister(); all it does is a
kobject_put().

> >Now, the fun part starts - if we quickly call pci_disable_msi() and,
> >afterwards, pci_enable_msi() - we might fail because the msi_irqs kset is
> >still there, waiting to unregister, and the sysfs dir is still active.
> >
> >It's used, for example, in tg3_open/tg3_close, which are ndo_open/close,
> >and are called on enslave/deslave in bonding.
> >
> >What I get:
> >[   60.458319] WARNING: CPU: 0 PID: 5552 at fs/sysfs/dir.c:526 sysfs_add_one+0xbb/0xe0()
> >[   60.458350] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1c.5/0000:3f:00.0/msi_irqs'
> >
> >I'll take a deeper look at the issue, though any feedback/advise is
> >welcome. And I'll hold on with the patchset that removes pci_dev_get/put
> >and kobject_del.
> 
> Ok, this is only reproducible with CONFIG_DEBUG_KOBJECT_RELEASE, with or
> without removing kobject_del() (though it's harder to reproduce). I could
> not trigger it without CONFIG_DEBUG_KOBJECT_RELEASE, even with constantly
> poking /sys/class/net/tg3_device/device/msi_irqs/* . Though it's,
> obviously, possible, with and without cleanup and my previous bugfix.
> 
> I'll then send now the cleanup, however this theoretical issue was, is and
> won't be fixed by it :-/. And I don't know how can we possible fix it
> without something like kobject_put_wait().

I still think we should remove the kobject_del().  We don't want to
make a race harder to hit; we want to remove it completely.  What we
really want is to make races *easier* to hit so we can find them,
which seems to be the point of KOBJECT_RELEASE :)

That said, I think I see why you see the warning in this case.
You're calling pci_enable_msi(), pci_disable_msi(), pci_enable_msi()
as in this call chain:

  pci_enable_msi
    msi_capability_init
      populate_msi_sysfs
        dev->msi_kset = kset_create_and_add("msi_irqs", ...)
        list_for_each_entry(entry, &dev->msi_list, ...)
          kobj->kset = dev->msi_kset
          kobject_init_and_add(kobj, &msi_irq_ktype, NULL, ...)
            kobject_add_internal
              kobject_get(&kobj->kset->kobj)    # dev->msi_kset

  pci_disable_msi
    free_msi_irqs
      list_for_each_entry_safe(entry, ..., &dev->msi_list, ...)
        kobject_put(&entry->kobj)
          kobject_release
            ... <delayed> ...
              kobject_cleanup
                kobject_del
                  kobj_kset_leave
                    kset_put(kobj->kset)        # dev->msi_kset
                      kobject_put	# happens AFTER pci_enable_msi() below
                t->release
        list_del(&entry->list)
    kset_unregister(dev->msi_kset)
      kobject_put
        kobject_release
          ... <delayed> ...
            kobject_cleanup		# happens AFTER pci_enable_msi() below
    dev->msi_kset = NULL

  pci_enable_msi
    msi_capability_init
      populate_msi_sysfs
        dev->msi_kset = kset_create_and_add("msi_irqs", ...)
          "sysfs: cannot create duplicate filename .../msi_irqs"

When we kset_create_and_add("msi_irqs") the second time, the delayed
kobject_cleanups() for the msi_desc entries and the msi_kset have
not yet occurred, so the msi_desc entries still hold references to
the msi_kset, etc.

I'm not sure if this is a design problem in the way PCI manages
msi_kset and msi_desc entries, or if there's something wrong in
the way KOBJECT_RELEASE is implemented.  I could imagine changing
it so the bulk of kobject_cleanup(), including the sysfs cleanup,
is executed immediately when the last reference is dropped, but
the kobj_type->release() function itself is delayed.

Calling kobject_del() explicitly sort of side-steps this problem
by doing the sysfs cleanup before the last put.  But it is quite
subtle, and it feels error-prone to rely on that.

Bjorn
