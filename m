Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3LMNWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:22:23 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42056 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3LMNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:22:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX8XXkwbhhuNhCF-pHdc_3or_dMEH-VN5NBSEV_eXE-Pg@mail.gmail.com>
References: <529E5C0E.80903@gmail.com> <20131212224407.GL4699@google.com> <CAE9FiQX8XXkwbhhuNhCF-pHdc_3or_dMEH-VN5NBSEV_eXE-Pg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 13 Dec 2013 06:21:59 -0700
Message-ID: <CAErSpo5BsaLNrny3T1sYknz3wo4hN0SKJk0_u6eNyEd6qq5o=g@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pciehp: Use link change notifications for hot-plug
 and removal
To: Yinghai Lu <yinghai@kernel.org>
Cc: Rajat Jain <rajatjain.linux@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Rajat Jain <rajatjain@juniper.net>, Rajat Jain <rajatxjain@gmail.com>,
        Guenter Roeck <groeck@juniper.net>, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Dec 12, 2013 at 2:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

>>> * Define and use interrupt events for linkup / linkdown.
>>
>> This seems like a reasonable idea.
>>
>> In the ExpressCard Standard (Rel 2.0, Feb 2009), Section 6.3.1 and Figure
>> 6-2 talk about a "Link Detect" or "Link Train Detected" interrupt being
>> used to trigger the ACPI hotplug flow for a non-PCIe-aware OS.  I'm not
>> sure what interrupt this refers to.  The Slot Control Data Link Layer State
>> Changed interrupt (which you're using) sounds similar, but my guess is that
>> "Link Detect" is a generic term for chipset-specific functionality to
>> generate an SMI for hotplug events.
>>
>> But then Section 6.3.1.1 suggests that a PCIe-aware OS would use "Presence
>> Detect Changed" instead.  I don't know why a different mechanism would be
>> suggested, although DLLSC was added after PCIe 1.0, so older hardware
>> wouldn't have a PCIe-standard link detection mechanism.
>>
>> In any event, I think having the Link Status Data Link Layer Link Active
>> bit set would certainly imply that a device is present, so it seems
>> reasonable to use DLLLA in addition to Presence Detect State.
>
> Yes, if Attention attention is not there and Surprise removal is supported.

I'm not convinced that it's a good idea to make link state support
conditional on the attention button and surprise removal bits.  That
might cover Rajat's particular case, but I don't think there's a
logical connection between link state and those bits, so making it
conditional might just make the code more complicated and less general
for no good reason.

>>> @@ -620,13 +610,10 @@ int pciehp_power_off_slot(struct slot * slot)
>>>       u16 cmd_mask;
>>>       int retval;
>>>
>>> -     /* Disable the link at first */
>>> -     pciehp_link_disable(ctrl);
>>> -     /* wait the link is down */
>>> -     if (ctrl->link_active_reporting)
>>> -             pcie_wait_link_not_active(ctrl);
>>> -     else
>>> -             msleep(1000);
>>
>> 2debd9289997 ("PCI: pciehp: Disable/enable link during slot power off/on")
>> added this code that disables the link to fix problems.  So we need to make
>> sure we don't reintroduce those problems by leaving the link enabled.
>>
>> One problem was spurious "card present/not present" messages.  I suspect
>> that topology has an attention button, and I'm not sure it makes sense to
>> enable the presence detect interrupt in that case.  As far as I can tell,
>> if there's an attention button, the OS should not do anything on card
>> insertion or removal; it should only do something when the attention button
>> is pressed.  So maybe we can deal with the message issue that way.
>
> Agreed.
>
>>
>> The changelog also hints that disabling the link might be needed to allow a
>> repeater to be reset, but I don't know the details.  I don't remember any
>> spec language that requires the link to be disabled on hotplug; maybe this
>> is a platform-specific quirk.
>
> yes, that is workaround to to reset repeater in between.

What does the "other OS" do about this repeater?  Did you verify that
it disables the link when powering off the slot?  If we were smarter
about presence detect, I wonder if that would be enough.

> Also we can get rid of annoying aer during power off slot.

I don't know the details of this issue.  It may be possible to avoid
the AER in some way other than turning off the link.

> Also at least other os will turn on link after turn on the power,
> as hotplug is working if BIOS have link disabled when boot system
> without card inserted.

If the link is disabled after turning on power, it certainly makes
sense to me to enable the link.  I don't think Rajat changed the
pciehp_power_on_slot() path, so this part should still work.

> I suggest that link event handling will be enabled automatically when
> attention button is not there and surprise removal is supported.
> And when that enabled, should disable Present event handling.

I think it should be as simple as possible, i.e., if we have an
attention button, ignore presence detect.  If we make it more
complicated that necessary, we run the risk of enforcing assumptions
that may not hold in the future.

Bjorn
