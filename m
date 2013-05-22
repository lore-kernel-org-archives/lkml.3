Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3EVNjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:39:06 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:51883 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705Ab3EVNjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:39:04 -0400
Message-ID: <519CCA72.7000005@hurleysoftware.com>
Date: Wed, 22 May 2013 09:38:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: stephan.gatzka@gmail.com, linux1394-devel@lists.sourceforge.net,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org> <519BA6AC.1080600@hurleysoftware.com> <20130521231346.1fec9142@stein>
In-Reply-To: <20130521231346.1fec9142@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 05:13 PM, Stefan Richter wrote:
>> FWIW, I still believe that we should revert to the original bus reset
>> as tasklet and redo the TI workaround to use TI-workaround-specific versions
>> of non-sleeping PHY accesses.
>>
>> Regards,
>> Peter Hurley
>
> I am a friend of the self-ID-complete worklet, for two reasons:
>    - Even if there was no need for the TI TSB41BA3D workaround (e.g. even
>      if we simply stopped supporting TSB41BA3D), it would still be
>      worthwhile to have at least the self-ID-complete IRQ BH performed in
>      a non-atomic context.  We should try to move as much of the
>      firewire-core self-ID-complete handler as possible out of the currently
>      spinlock protected section in order make more of this stuff
>      preemptible and replace a few GFP_ATOMIC slab allocations by GFP_NOFS
>      ones.  (Could be GFP_KERNEL in absence of firewire-sbp2.)
>      I would have liked to work on this already long ago, but such is life.

Sure. I understand reducing the card->lock critical section is desirable
(although even more care would be required when switching the work item).

>    - How do you propose to access the PHY registers without sleeping?
>      Or more to the point:  How do you propose to mix sleeping and
>      non-sleeping PHY register accesses?  (Since we can't get rid of
>      the sleeping ones.)  If the accesses are not fully serialized, you will
>      get corrupt PHY reg reads or writes.  If they are fully serialized, the
>      non-sleeping PHY reg accesses need to go a try-lock route and will be
>      forced to error out during periods when a sleeping PHY reg access goes
>      on, without even the ability to reschedule if it is done in a tasklet
>      context.

Although this point is largely irrelevant now, I wasn't suggesting mixing
sleeping and non-sleeping PHY access -- simply that the TI quirk would
require non-sleeping PHY access and every other host controller would
use sleeping PHY access.

Regards,
Peter Hurley
