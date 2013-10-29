Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3J2Lcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:32:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36324 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3J2Lcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:32:39 -0400
Date: Tue, 29 Oct 2013 07:32:35 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-pci@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, yinghai@kernel.org, Knut_Petersen@t-online.de,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/3] msi: free msi_desc entry only after we've
 released the kobject
Message-ID: <20131029113235.GB24477@neilslaptop.think-freely.org>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
 <1383042632-7102-2-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383042632-7102-2-git-send-email-vfalico@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:30:30AM +0100, Veaceslav Falico wrote:
> Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
> however kobject_put() doesn't guarantee us that it was the last reference
> and that the kobj isn't used currently by someone else, so after we
> kfree(entry) with the struct kobject - other users will begin using the
> freed memory, instead of the actual kobject.
> 
> Fix this by using the kobject->release callback, which is called last when
> the kobject is indeed not used and is cleaned up - it's msi_kobj_release(),
> which can do the kfree(entry) safely (kobject_put/cleanup doesn't use the
> kobj itself after ->release() was called, so we're safe).
> 
> In case we've failed to create the sysfs directories - just kfree()
> it - cause we don't have the kobjects attached.
> 
> Also, remove the same functionality from populate_msi_sysfs(), cause on
> failure we anyway call free_msi_irqs(), which will take care of all the
> kobjects properly.
> 
> And add the forgotten pci_dev_put(pdev) in case of failure to register the
> kobject in populate_msi_sysfs().
> 
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: linux-pci@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

