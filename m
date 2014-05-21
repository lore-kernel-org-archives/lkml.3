Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaEURFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:05:11 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:7370 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaEURFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:05:09 -0400
Message-ID: <537CDCC2.6020209@hp.com>
Date: Wed, 21 May 2014 13:05:06 -0400
From: Linda Knippers <linda.knippers@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/intel: Exclude devices using RMRRs from IOMMU API
 domains
References: <20140514192620.7767.43842.stgit@bling.home>	<1400668716.13839.66.camel@shinybook.infradead.org> <1400678426.3289.396.camel@ul30vt.home>
In-Reply-To: <1400678426.3289.396.camel@ul30vt.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2014 9:20 AM, Alex Williamson wrote:
> On Wed, 2014-05-21 at 11:38 +0100, David Woodhouse wrote:
>> On Wed, 2014-05-14 at 13:27 -0600, Alex Williamson wrote:
>>> The user of the IOMMU API domain expects to have full control of
>>> the IOVA space for the domain.  RMRRs are fundamentally incompatible
>>> with that idea.  We can neither map the RMRR into the IOMMU API
>>> domain, nor can we guarantee that the device won't continue DMA with
>>> the area described by the RMRR as part of the new domain.  Therefore
>>> we must prevent such devices from being used by the IOMMU API.
>>
>> Ick, ick, ick. The more the ramifications of RMRRs become apparent, the
>> more I wish we'd just done the Right Thing™ and declared that firmware
>> SHALL NOT leave any device doing (IOMMU-visible) DMA after the OS takes
>> over. That way, if they wanted this kind of abomination then they'd have
>> to come up with a way of doing it differently. Hell, can't you do PCIe
>> transactions which claim to be already translated, and thus just bypass
>> the IOMMU?
>>
>> OK, rant over... 
>>
>> Why can't we map the RMRR into the IOMMU API domain? If we're setting up
>> a VM guest, that basically means we'd want to poke a hole in its memory
>> map and mark the RMRR-afflicted range as reserved or absent. It's
>> horrible, but *everything* about RMRRs is horrible. It's not impossible,
>> and it would allow us to give these devices away to guests. Don't we
>> sometimes *have* devices that we want to give to guests, that are
>> afflicted with RMRRs?
> 
> You're right, it is possible to assign devices with RMRRs, but in order
> to do so we'd need to expose the RMRR areas for a device beyond the
> inner workings of intel-iommu and mark those ranges as reserved in the
> guest.  That alone makes hotplug of such devices into a guest
> impossible.
> 
> Enabling such a use case also potentially provides an untrusted guest
> with direct access to regions of platform memory that potentially allows
> for untold platform specific exploits.
> 
> We currently have no visibility to RMRRs from the IOMMU API, so we can't
> even attempt to do the above, nor can we guarantee that we have any
> ability to make a device discontinue use of an RMRR area when it is
> assigned to a VM domain.  Therefore the only safe thing to do is prevent
> use of such devices by a VM domain.
> 
>> There are discussions about RMRRs being (ab)used for more than their
>> existing brain-damaged purpose. Where we have a peripheral device that
>> will (mis)interpret certain address ranges as "local" rather than
>> forwarding transactions up towards main memory, we need to ensure that
>> such ranges are never used as virtual addresses. This has largely been
>> an invisible problem until we found a device where the affected range
>> matched the IOVA our DMA API uses by default. Using an RMRR has been
>> proposed as a simple way to achieve that... which means that you end up
>> not being able to assign *those* devices to IOMMU domains either.
>>
>> I do suspect it's going to lead to complaints... but I'm just not sure I
>> can bring myself to care. Sane designs don't require RMRRs. If someone
>> comes to me and complains that their HP storage controller or whatever
>> can't be assigned to a guest, I'm quite prepared to tell them to replace
>> it with something non-broken. Will you back me up when it happens?
> 
> Exactly, I have a hard time bringing myself to care about supporting
> such devices.  Vendors that proliferate RMRR usage need to be aware of
> the implications of RMRRs for all use cases of a device.  First and
> foremost, we need to lock out devices with RMRRs because we have no
> ability to either honor or disable RMRRs when used by the IOMMU API.  If
> vendors that rely on RMRRs want to make such devices assignable by
> providing interfaces to describe and map the area into a VM, or even a
> mechanism to disable the RMRR, more power to them.  The current
> situation is simply unsafe and needs to be prevented.  

I care but I think this patch should go in until there is a better
solution.

-- ljk

> Thanks,
> 
> Alex
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 

