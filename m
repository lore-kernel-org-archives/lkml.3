Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaJAUtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:49:49 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62798 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaJAUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:49:47 -0400
MIME-Version: 1.0
In-Reply-To: <20141001204302.GA7744@svl-evodev-groeck.juniper.net>
References: <CAAVjN7dwS62EKMnuZc_P1UjkbRVk6RXqJ91GwWZ96bbY5Ct-rg@mail.gmail.com>
	<CAAVjN7eUmBVcAGPbcn3qsJ9M9uu2nkFoKHqGhhKGekZSceGiMw@mail.gmail.com>
	<20141001184304.GA6832@svl-evodev-groeck.juniper.net>
	<CAAVjN7edpkXYMHBm+wLegA_pc0hnm_YZf_z=Ni3h=EbDTmfegQ@mail.gmail.com>
	<20141001194115.GA6948@svl-evodev-groeck.juniper.net>
	<CAAVjN7fGRzyu7gxavJUay+K_Mm-0t1T_0Bysk6-sdaqu5=5k5A@mail.gmail.com>
	<20141001202058.GB6948@svl-evodev-groeck.juniper.net>
	<CAAVjN7e4nO579TfAJ5zMNe__Q9yU_-6naq4-0vm1rimespSrsw@mail.gmail.com>
	<20141001204302.GA7744@svl-evodev-groeck.juniper.net>
Date: Wed, 1 Oct 2014 13:49:45 -0700
Message-ID: <CAAVjN7dyiSonvsEfawTSi_bJ9umxMFfmA_WAdwz=Yd6wsN4uzA@mail.gmail.com>
Subject: Re: Fwd: [Proposal] PM sleep children of inactive I2C bus segments
 off Masters in multi-master systems
From: Danielle Costantino <danielle.costantino@gmail.com>
To: Guenter Roeck <groeck@juniper.net>
Cc: linux-i2c <linux-i2c@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I will probably work on error return values for master
selectors and add IRQ support to the pca9541 driver.

On Wed, Oct 1, 2014 at 1:43 PM, Guenter Roeck <groeck@juniper.net> wrote:
> On Wed, Oct 01, 2014 at 01:32:28PM -0700, Danielle Costantino wrote:
>> My goal was to automatically put the devices behind the master
>> selector in a (logical) state where all settings would be verified and
>> if needed corrected and initialized back to how the device was
>> configured prior to giving up the bus.
>>
>
> That kind of reaction could result in a re-configuration war
> if both masters disagree how devices should be configured.
> Also, unless I am missing something, it would require changes
> in pretty much every i2c client driver. That doesn't really sound
> feasible to me.
>
> Maybe you can find an error code which with some level of confidence
> reflects "lost mastership". Then you can implement whatever makes sense
> for your use case in your user space application(s).
>
> Guenter
>
>> The error return is the main issue, but I was hoping to automate
>> multi-master bus re-initialization.
>>
>> On Wed, Oct 1, 2014 at 1:20 PM, Guenter Roeck <groeck@juniper.net> wrote:
>> > On Wed, Oct 01, 2014 at 01:03:59PM -0700, Danielle Costantino wrote:
>> >> On Wed, Oct 1, 2014 at 12:41 PM, Guenter Roeck <groeck@juniper.net> wrote:
>> >> > On Wed, Oct 01, 2014 at 11:44:59AM -0700, Danielle Costantino wrote:
>> >> >> Re-sending Proposal:
>> >> >>
>> >> >> Currently I2C mux devices that support multiple master arbitration are
>> >> >> the i2c-mux-pca9541 and i2c-arb-gpio-challenge drivers. I propose to
>> >> >> add the ability to configure an interrupt pin from the Master Selector
>> >> >> device to indicate that bus ownership has been lost. Once the device
>> >> >> loses ownership, all of its children should enter a pm sleep mode (as
>> >> >> you can't talk to them at this point) until master-ship has been
>> >> >> reacquired.
>> >> >>
>> >> > Not sure I understand what you are proposing here.
>> >>
>> >> Lets say you have a active - standby based multi-master system. If the
>> >> other master forced arbitration (took mastership) the next transation
>> >> on any slaves of that bus would return EAGAIN or EBUSY.
>> >>
>> >> Another point is that once mastership has been lost, the configuration
>> >> of the devices on that bus are no longer known to be valid...therefor
>> >> a re-init of those devices may be needed.
>> >>
>> > Unfortunately that is a generic problem in a multi-master system.
>> > You never know if the other end reconfigured a device or not,
>> > even if there was no error.
>> >
>> >> > A typical use case would be a power supply such as the one supported by
>> >> > drivers/hwmon/lineage-pem.c from both an active and standby system
>> >> > controller. The power supply needs to be accessible from both controllers.
>> >> > If one controller looses access, it can only mean that it did not follow
>> >> > the access protocol. Similar, one controller enforcing access means that
>> >> > it either does not follow the access protocol either, or that the other
>> >> > end did not follow the protocol (or maybe the other end died).
>> >> >
>> >> > In all cases, loss of access does not mean that the end device can or should
>> >> > be put in sleep mode, not even logically. All it means is that there was
>> >> > an access protocol error. Not sure if there is anything that can be done
>> >> > about that, but putting the device into sleep mode does not seem to be
>> >> > an appropriate response to me.
>> >> >
>> >> >> This has come up as an issue when the master loses control over a bus
>> >> >> the return code of all transactions to its lave devices is EIO (not
>> >> >> very helpful).
>> >> >>
>> >> > But, again, doesn't that mean that there was some access protocol error ?
>> >> > Shouldn't it try to re-acquire mastership instead, and block all accesses
>> >> > to slaves until it acquired it ?
>> >>
>> >> EIO is such a generic error it makes finding weather there was a
>> >> problem communicating or is no longer master of the bus segment.
>> >>
>> > AFAICS the only time the pca9541 driver returns -EIO is if a transaction
>> > did not complete. Only possible improvement I could imagine would be to
>> > check if mastership was lost if there was an error, and return something
>> > more useful if that is the case. Both -EBUSY or -EAGAIN might make sense
>> > here; I don't really know what would be better or more appropriate.
>> >
>> > Guenter
>>
>>
>>
>> --
>> - Danielle Costantino



-- 
- Danielle Costantino
