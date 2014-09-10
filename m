Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaIJUuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:50:55 -0400
Received: from relay1.sgi.com ([192.48.180.66]:53016 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbaIJUuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:50:54 -0400
Message-ID: <5410B9AD.7050008@sgi.com>
Date: Wed, 10 Sep 2014 15:50:53 -0500
From: Gary Kroening <gfk@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>, Nathan Zimmer <nzimmer@sgi.com>,
        jroedel@suse.de
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] iommu/vt-d: Use the SIRTP when enabling remapping
References: <1410297096-54096-1-git-send-email-nzimmer@sgi.com> <540FF614.8000003@siemens.com> <541004B6.8070800@sgi.com>
In-Reply-To: <541004B6.8070800@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not really a kernel developer and don't know the proper etiquette for
this, but just wanted to say thanks to Jan for the guidance. With your help,
I was able to track our problem down to a much more fundamental problem of
incorrect bit position of the fields in our VT-d GLBCMD register, attributable
to our now-manual process of generating register information from Intel
socket documentation. (We used to used Intel's SoftSDV to determine register
fields, but that's no longer available and we have to use fallible human
eyes! Thousands of registers in each new socket...)

Gary

On 09/10/2014 02:58 AM, Gary Kroening wrote:
> On 9/10/2014 1:56 AM, Jan Kiszka wrote:
>> On 2014-09-09 23:11, Nathan Zimmer wrote:
>>> The previous change (iommu/vt-d: Don't store SIRTP request) to this area
>>> caused a crash in our simulator. In particular is seems that by the time a
>>> UART interrupt is sent through the system, we don't see interrupt remapping
>>> to be enabled.  So the interrupt does not get translated to a logical
>>> interrupt and crashes.
>>>
>>> OR'ing the SIRTP request to make sure it is seen but hopefully not sticky.
>>> This seems like a clean fix, at least on our simulator; if you don't agree,
>>> our simulator guy will take a closer look at our iommu model.
>>
>> Check the VT-d spec (6.7, Set Interrupt Remapping Table Pointer
>> Operation): "Software must always follow the interrupt-remapping table
>> pointer set operation with a global invalidate of the IEC to ensure
>> hardware references the new structures *before* enabling interrupt
>> remapping." There is also (command register description): "If multiple
>> control fields in this register need to be modified, software must
>> serialize the modifications through multiple writes to this register."
>> This, in combination with the command registers description of bits 24
>> and 25 strongly suggests that your model is broken.
>
> Thanks, Jan. I'll read up on it. Still working out some kinks with
> the relatively new IOMMU/interrupt-remapping logic which we added over
> the last 18 months or so. Sorry for any distraction, and thanks for the
> help/info.
> Gary
>
>>
>>>
>>> Found testing on our simulator, not real hardware.
>>
>> Funnily, the original issue was found by the QEMU model of VT-d that
>> used to take the last cited sentence very strictly (I asked to remove it
>> due to the preexisting Linux versions).
>>
>> Jan
>>

