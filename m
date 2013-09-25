Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3IYWLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab3IYWK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:10:59 -0400
Date: Thu, 26 Sep 2013 00:09:00 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] msi: add forgotten pci_dev_put(pdev) to
 populate_msi_sysfs()
Message-ID: <20130925220900.GA26965@redhat.com>
References: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
 <1379382464-7920-2-git-send-email-vfalico@redhat.com>
 <CAErSpo6+AQhpO2WvoKCSw7WokDiex_E43oi9xpuka7biPEx=7Q@mail.gmail.com>
 <CAErSpo6jXzbgZUDbbo74vW-aSUD8MgtK5iNieFGUk=fxho102A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAErSpo6jXzbgZUDbbo74vW-aSUD8MgtK5iNieFGUk=fxho102A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 03:30:14PM -0600, Bjorn Helgaas wrote:
>On Wed, Sep 25, 2013 at 3:08 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Also, I think it is incorrect that free_msi_irqs() does this:
>>
>>                 if (entry->kobj.parent) {
>>                         kobject_del(&entry->kobj);
>>                         kobject_put(&entry->kobj);
>>                 }
>>
>>                 list_del(&entry->list);
>>                 kfree(entry);
>>
>> I think the "kfree(entry)" should be in msi_kobj_release() instead.
>
>Oh, I see you fixed this in patch 3/3.  I hadn't read that far yet :)
>
>Did you find these problems by inspection, or is there some easy way
>to trigger bad behavior?  Just wondering if this is some way I can
>reproduce the problem.

Hi,

I've first found it by building with CONFIG_DEBUG_KOBJECT_RELEASE and
CONFIG_DEBUG_OBJECTS - it shows that it's freeing an object in an active
state (I'm just running insmod/rmmod tg3 concurently, but I guess it's
reproducible with any driver that uses msi/x).

Without CONFIG_DEBUG_OBJECTS it's also reproducible, and without
CONFIG_DEBUG_KOBJECT_RELEASE it's really hard to reproduce, but still
reproducible (I've hit it with tg3 as a slave of bonding and concurently
running rmmod bonding/ifup bond0 - though it's really hard). It just panics
in kobject_put(), iirc.

So, with those CONFIG_DEBUG_* it's easily triggerable, without - quite
hard.

Hope that helps.

p.s. I'll adress your other comments tomorrow already, it's quite late here
and I don't want to do something stupid now :).

Thanks a lot!

>
>Bjorn
