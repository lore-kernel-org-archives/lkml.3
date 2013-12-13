Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3LMVOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:14:32 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59849 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3LMVOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:14:30 -0500
MIME-Version: 1.0
In-Reply-To: <428d664592c2466c9e5e6b393df9d690@DM2PR05MB671.namprd05.prod.outlook.com>
References: <529E5C0E.80903@gmail.com> <20131212224407.GL4699@google.com>
 <CAE9FiQX8XXkwbhhuNhCF-pHdc_3or_dMEH-VN5NBSEV_eXE-Pg@mail.gmail.com>
 <CAErSpo5BsaLNrny3T1sYknz3wo4hN0SKJk0_u6eNyEd6qq5o=g@mail.gmail.com> <428d664592c2466c9e5e6b393df9d690@DM2PR05MB671.namprd05.prod.outlook.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 13 Dec 2013 14:14:10 -0700
Message-ID: <CAErSpo5NjOCqkao03Ea=98gunVEaUUitq8mGLarpKW_DQoDF8g@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pciehp: Use link change notifications for hot-plug
 and removal
To: Rajat Jain <rajatjain@juniper.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Rajat Jain <rajatjain.linux@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:04 PM, Rajat Jain <rajatjain@juniper.net> wrote:
>> On Thu, Dec 12, 2013 at 11:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Thu, Dec 12, 2013 at 2:44 PM, Bjorn Helgaas <bhelgaas@google.com>

> Also, I think the device removal should _always_ be initiated (if not done already) whenever the Link goes down for any reason (irrespective of whether the attention button is implemented or not, or whether the surprise events are supported or not). I think this is logical as it makes no sense for the software to think the device is accessible when in reality it is not. In fact I think we should also remove the checks in pciehp_disable_slot() that ensure that the adapter should be populated and latch should be closed.

I agree.

>> What does the "other OS" do about this repeater?  Did you verify that it
>> disables the link when powering off the slot?  If we were smarter about
>> presence detect, I wonder if that would be enough.
>>
>> > Also we can get rid of annoying aer during power off slot.
>>
>> I don't know the details of this issue.  It may be possible to avoid the
>> AER in some way other than turning off the link.
>
> Sorry, I could not understand what we are talking about here. I'd appreciate if you could elaborate if you see this as a problem related to the patch?

I assume Yinghai means that when we power off the slot, if AER is
still enabled, it may report errors caused by the link going down.
PCIe r3.0 sec. 3.2.1 says some of these cases must not be considered
errors if the link is disabled, the port is associated with a
hot-pluggable slot, etc.  Maybe his platform doesn't follow those
rules, or maybe there's some other AER error that's not covered by
them.

It's related to your patch because you are removing the link disable,
and Yinghai says that if we leave the link enabled, he gets unwanted
AER errors when powering off the slot.  Sorry if this was all obvious
to you.  I don't know any more details.  It'd be nice to know the
exact AER errors and the PCIe capability info.  Then we might be able
to figure out a way to leave the link enabled while still suppressing
the AER errors.

> Once again: the way I interpret this is:
> * Always enable Link events.
> * Disable presence events if attention button is present.

That sounds like a good plan to me.

I'm also dubious about this use of presence detect:

    pciehp_power_thread
      pciehp_enable_slot
        pciehp_get_adapter_status
          pciehp_readw(ctrl, PCI_EXP_SLTSTA, &slot_status)
          *status = !!(slot_status & PCI_EXP_SLTSTA_PDS)
        board_added
          pciehp_power_on_slot

because we apparently look at PCI_EXP_SLTSTA_PDS when the slot is
powered off.  Only in-band presence detection is required by spec, and
in-band detection only works when power is applied.  So I think this
pciehp_get_adapter_status() call should probably just be removed.

Bjorn
