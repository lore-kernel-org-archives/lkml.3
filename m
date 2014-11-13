Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbaKMRik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:38:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60046 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616AbaKMRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:38:37 -0500
Message-ID: <5464EC7A.7050603@ti.com>
Date: Thu, 13 Nov 2014 11:38:02 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv6 4/5] hwspinlock/core: add common OF helpers
References: <1410553499-55951-1-git-send-email-s-anna@ti.com> <1410553499-55951-5-git-send-email-s-anna@ti.com> <CAK=WgbamdqAufjC4Xb5moERRBSB-cO6c1RPTE=f+dp75F+Eh7A@mail.gmail.com> <5463B5B6.8040709@ti.com> <CAK=WgbbatPTiz3efDWHVEcuug_UQfkCViMoK0zcfUg3JwB2oTA@mail.gmail.com>
In-Reply-To: <CAK=WgbbatPTiz3efDWHVEcuug_UQfkCViMoK0zcfUg3JwB2oTA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 11/13/2014 04:03 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Wed, Nov 12, 2014 at 9:32 PM, Suman Anna <s-anna@ti.com> wrote:
>>> Is this the validation you mentioned which requires the existence of
>>> "hwspinlock/core: maintain a list of registered hwspinlock banks" ?
>>
>> Well, not exactly. The validation is on the following segment,
>>
>> +       id = of_hwspin_lock_simple_xlate(bank, &args);
>> +       if (id < 0 || id >= bank->num_locks) {
>> +               ret = -EINVAL;
>> +               goto out;
>> +       }
> 
> I'm not entirely convinced that this justifies adding the proposed
> linked list. Can't we can get the base_id and number of locks by
> traversing the DT?

No, not always, because, either of them can be optional between
different platform implementations. For example, on OMAP, the number of
locks is read from an IP register, and not coded in DT. Similarly,
base_id can be optional on SoCs that don't have multiple IP instances.
The only place the hwspinlock core knows both of them for sure is at the
device registration time, but the core only stores the locks and not the
devices at the moment. Any operation on the device is not possible
without knowing the exact global lock we are dealing with, and this API
is about returning that exact global lock id.

> 
>> That said, it is also needed to provide the support for deferred probing
>> without changing the return code conventions on the existing API.
> 
> Here too, adding a data structure maintaining memory objects and
> taking care of it life cycle seems a bit overkill for anything to do
> with return values.

IMHO, this life cycle management is not that complicated, it is managed
alongside the addition/removal of the locks during the device
registration/unregistration time.

> 
>> Yes, and wouldn't that require that the id is validated? It just cannot
>> return any return value, and expect it will be verified somewhere else
>> or in a following API call. Not doing the validation unnecessarily
>> complicates the system usage of a lock as you are sharing an invalid
>> lock to a remote processor and then you have two validation failure
>> paths on different processors.
> 
> Validation is great but I'm still not convinced it can't be done
> without maintaining another data structure.
> 
> Please show me specific technical issues that can't be resolved
> without adding the proposed linked list.

Same as above.

regards
Suman
