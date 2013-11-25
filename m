Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3KYX3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:29:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KYX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:29:37 -0500
Date: Mon, 25 Nov 2013 15:29:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>, linux-pci@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, yinghai@kernel.org,
        Knut_Petersen@t-online.de, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v3 1/3] msi: free msi_desc entry only after we've
 released the kobject
Message-ID: <20131125232936.GA31746@kroah.com>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
 <1383042632-7102-2-git-send-email-vfalico@redhat.com>
 <20131125231248.GB4034@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125231248.GB4034@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:12:48PM -0700, Bjorn Helgaas wrote:
> On Tue, Oct 29, 2013 at 11:30:30AM +0100, Veaceslav Falico wrote:
> > Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
> > however kobject_put() doesn't guarantee us that it was the last reference
> > and that the kobj isn't used currently by someone else, so after we
> > kfree(entry) with the struct kobject - other users will begin using the
> > freed memory, instead of the actual kobject.
> > 
> > Fix this by using the kobject->release callback, which is called last when
> > the kobject is indeed not used and is cleaned up - it's msi_kobj_release(),
> > which can do the kfree(entry) safely (kobject_put/cleanup doesn't use the
> > kobj itself after ->release() was called, so we're safe).
> > 
> > In case we've failed to create the sysfs directories - just kfree()
> > it - cause we don't have the kobjects attached.
> > 
> > Also, remove the same functionality from populate_msi_sysfs(), cause on
> > failure we anyway call free_msi_irqs(), which will take care of all the
> > kobjects properly.
> > 
> > And add the forgotten pci_dev_put(pdev) in case of failure to register the
> > kobject in populate_msi_sysfs().
> > 
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Neil Horman <nhorman@tuxdriver.com>
> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > CC: linux-pci@vger.kernel.org
> > CC: linux-kernel@vger.kernel.org
> > Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> 
> I'm still hoping that Greg (or somebody else; Greg already posted the bulk
> of the work) will finish up the conversion to attributes, and that Neil
> will confirm that works with no changes to irqbalance.  So I'm going to
> drop these patches for now.  Poke me if we need to revive them.

Ah, sorry about that.  I'll redo my series, dropping the existing format
and using the attribute-only code.  Give me a day or so, thanks for the
reminder.

greg k-h
