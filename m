Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbaLKVAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:00:30 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60033 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848AbaLKVA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:00:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141211204515.GA4472@svl-evodev-groeck.juniper.net>
References: <546E7120.5080505@gmail.com> <20141211002630.GC22886@google.com>
 <20141211163831.GA2845@svl-evodev-groeck.juniper.net> <CAErSpo62wQ6g74wNYYumgbAVJ3Mneu_dmWOhLBE6NWqQTXsvVQ@mail.gmail.com>
 <20141211204515.GA4472@svl-evodev-groeck.juniper.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Dec 2014 14:00:06 -0700
Message-ID: <CAErSpo4WAbb=n+cNARRgKWPhbn6LZqwL-htB_Uv2OWB9BwTXpw@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: pciehp: Check link state before accessing device
 during removal
To: Guenter Roeck <groeck@juniper.net>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 1:45 PM, Guenter Roeck <groeck@juniper.net> wrote:
> On Thu, Dec 11, 2014 at 01:26:47PM -0700, Bjorn Helgaas wrote:
>> On Thu, Dec 11, 2014 at 9:38 AM, Guenter Roeck <groeck@juniper.net> wrote:
>> > On Wed, Dec 10, 2014 at 05:26:30PM -0700, Bjorn Helgaas wrote:
>> >> On Thu, Nov 20, 2014 at 02:54:24PM -0800, Rajat Jain wrote:

>> >> If we do need it (and it looks like most or all hotplug drivers copied it),
>> >> isn't there still a race?  Can't we have the following sequence?
>> >>
>> >>   - pciehp_check_link_active()                # returns true
>> >>   - Link goes down
>> >>   - pci_read_config_byte()            # fails because link is down
>> >>
>> > I would guess so. Question is how to address it. Read the configuration byte
>> > first, then check if the link is down ? Check if link is still up after reading
>> > the configuration byte ? Add a note that there may be a potential race condition
>> > and do nothing until it is actually seen ?
>>
>> I think we should just read PCI_BRIDGE_CONTROL and look for a 0xff
>> value.  That's not a legal value for the register, so if we see it, it
>> should be pretty safe to assume the link is down or the device is not
>> present at all.
>>
> Something like
>         if (bctl != 0xff && (bctl & PCI_BRIDGE_CTL_VGA)) {
> in addition to Rajat's changes ?
>
> I think it would be good to keep the change Rajat proposed, ie to check
> the link state instead of presence. Question then is if you'd want a new
> revision of Rajat's patch or another patch on top of it with the bctl
> related change.

Why do we need the link state or the presence check?  It seems like
those are sort of a 90% solution, and doing them provides the illusion
of value but without real value.  If we think that checking for 0xff
is a 100% solution, we should rely on that and not bother with
anything else.

Bjorn
