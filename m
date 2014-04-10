Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935813AbaDJXRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 19:17:47 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58037 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935788AbaDJXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 19:17:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140410204525.GC21815@beardog.cce.hp.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	<1397084904.9519.62.camel@dabdike>
	<1397085044.9519.63.camel@dabdike>
	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	<1397087425.9519.67.camel@dabdike>
	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
	<20140410204525.GC21815@beardog.cce.hp.com>
Date: Thu, 10 Apr 2014 17:17:44 -0600
Message-ID: <CAKocOONaqGAaiesf_MUFXEOMDtX8R8kYuPQYAxLBfth7nAx3Jg@mail.gmail.com>
Subject: Re: hpsa driver bug crack kernel down!
From: Shuah Khan <shuahkhan@gmail.com>
To: scameron@beardog.cce.hp.com
Cc: Davidlohr Bueso <davidlohr@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Baoquan He <bhe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 2:45 PM,  <scameron@beardog.cce.hp.com> wrote:
>> > 3f583bc21977 BAD ("Merge tag 'iommu-updates-v3.15'")
>>
>> Yes, specifically (finally done bisecting):
>>
>> commit 2e45528930388658603ea24d49cf52867b928d3e
>> Author: Jiang Liu <jiang.liu@linux.intel.com>
>> Date:   Wed Feb 19 14:07:36 2014 +0800
>>
>>     iommu/vt-d: Unify the way to process DMAR device scope array
>>
>>     Now we have a PCI bus notification based mechanism to update DMAR
>>     device scope array, we could extend the mechanism to support boot
>>     time initialization too, which will help to unify and simplify
>>     the implementation.
>>
>>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>     Signed-off-by: Joerg Roedel <joro@8bytes.org>
>
> My git bisect appears to be converging on something else, something
> within the hpsa patches that I sent up recently, unfortunately for
> me.  Will let you all know when it converges.
>

This smells very much like the problem that was solved couple of years
ago for SI domain. It is likely that path is broken with the DMAR
device scope array change. Please take a look to see if the following
no longer occurs. Looks like BIOS could be expecting this RMRR to be
still mapped.

               /*
                 * We want to prevent any device associated with an RMRR from
                 * getting placed into the SI Domain. This is done because
                 * problems exist when devices are moved in and out of domains
                 * and their respective RMRR info is lost. We exempt USB devices
                 * from this process due to their usage of RMRRs that are known
                 * to not be needed after BIOS hand-off to OS.
                 */
                if (device_has_rmrr(dev) &&
                    (pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
                        return 0;

-- Shuah
