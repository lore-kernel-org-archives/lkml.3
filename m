Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaGBVOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:14:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56645 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaGBVOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:14:41 -0400
Message-ID: <53B47621.6090307@ti.com>
Date: Wed, 2 Jul 2014 16:14:09 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 03/15] hwspinlock/core: maintain a list of registered
 hwspinlock banks
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-4-git-send-email-s-anna@ti.com> <CAK=WgbakGbTaYz+4K24aT3vyRkDYwPKCm6XrcJvH667NMMfTTA@mail.gmail.com>
In-Reply-To: <CAK=WgbakGbTaYz+4K24aT3vyRkDYwPKCm6XrcJvH667NMMfTTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 07/01/2014 07:26 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Thu, May 1, 2014 at 3:34 AM, Suman Anna <s-anna@ti.com> wrote:
>>
>> The hwspinlock_device structure is used for registering a bank of
>> locks with the driver core. The structure already contains the
>> necessary members to identify the bank of locks. The core does not
>> maintain the hwspinlock_devices itself, but maintains only a radix
>> tree for all the registered locks. A specific lock can be requested
>> by users using a global lock id, and any device-specific fields
>> can be retrieved through a reference to the hwspinlock_device in
>> each lock.
>>
>> The global lock id, however, is not friendly to be requested for
>> users using the device-tree model. The device-tree representation
>> will typically have each of the hwspinlock devices represented as
>> a DT node, and a specific lock can be requested using the device's
>> phandle and a lock specifier. Add support to the core therefore to
>> maintain all the registered hwspinlock_devices, so that a device
>> can be looked up and a specific lock belonging to the device
>> requested through a phandle + args approach.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
> 
> I'm not sure we need this patch.

This patch is needed if we use the controller-phandle + args specifier
for requesting hwlocks by a client, as we need to translate
controller-phandle to the corresponding hwspinlock_device.

Looks like we still don't have a closure on the semantics of how
clients have to request a lock in DT. You are suggesting something like
    hwlocks = <global_lock1 global_lock2 ...>;

whereas this patch is built to support based on comments from
DT-maintainers,
    hwlocks = <controller-phandle lock-specifier1>, <controller-phandle
lock-specifier2>...;

Mark, Kumar,
We need your input here as DT maintainers. Some of the discussion is on
the v4 cover-letter thread [1].

Kumar, Josh,
How does this fit with the MSM spinlock driver?

> It seems to me that the global lock id can be the base_id + lock
> index, where the former should be a property of the parent dt node,
> and the latter can just be the phandle argument. Then, with the global
> lock id in hand, drivers could just use the existing
> hwspin_lock_request_specific API.
> 
> If future hardware will bring a more complex scenario, we could then
> introduce the xlate proposal to resolve it. As long as we're not
> changing the dt data, and this is all handled by kernel code, 

Once we define dt data one way, how can we support a different mechanism
later on? Are you implying that we support both controller-phandle +
specifier and global-lock convention somehow through driver changes?

> then I'd
> prefer opting for less code now as long as it addresses the
> requirements.
> 
> Please let me know if currently there is a use case that can't be
> addressed using this simpler model.

This is just a question of DT semantics for the longer term, it can be
done both ways. I have started out the series with exactly what you are
suggesting here.

regards
Suman

[1] https://lkml.org/lkml/2014/3/17/576

