Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaFFICa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:02:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:28403 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaFFIC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,987,1392192000"; 
   d="scan'208";a="550702844"
Message-ID: <53917870.8050604@linux.intel.com>
Date: Fri, 06 Jun 2014 11:14:40 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 07/10] xhci: Use command structures when queuing commands
 on the command ring
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>	<1399566363-25837-8-git-send-email-mathias.nyman@linux.intel.com> <CAA9_cmfhm_OEqk_5dX=j_9mFFmXZCPQmgszYeyQkKmBUgr-pRw@mail.gmail.com>
In-Reply-To: <CAA9_cmfhm_OEqk_5dX=j_9mFFmXZCPQmgszYeyQkKmBUgr-pRw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 01:16 AM, Dan Williams wrote:
> Hi Mathias, hit a small issue playing with -next:
> 
> On Thu, May 8, 2014 at 9:26 AM, Mathias Nyman
> <mathias.nyman@linux.intel.com> wrote:
>> To create a global command queue we require that each command put on the
>> command ring is submitted with a command structure.
>>
>> Functions that queue commands and wait for completion need to allocate a command
>> before submitting it, and free it once completed. The following command queuing
>> functions need to be modified.
>>
>> xhci_configure_endpoint()
>> xhci_address_device()
>> xhci_queue_slot_control()
>> xhci_queue_stop_endpoint()
>> xhci_queue_new_dequeue_state()
>> xhci_queue_reset_ep()
>> xhci_configure_endpoint()
>>
>> xhci_configure_endpoint() could already be called with a command structure,
>> and only xhci_check_maxpacket and xhci_check_bandwidth did not do so. These
>> are changed and a command structure is now required. This change also simplifies
>> the configure endpoint command completion handling and the "goto bandwidth_change"
>> handling code can be removed.
>>
>> In some cases the command queuing function is called in interrupt context.
>> These commands needs to be allocated atomically, and they can't wait for
>> completion. These commands will in this patch be freed directly after queuing,
>> but freeing will be moved to the command completion event handler in a later
>> patch once we get the global command queue up.(Just so that we won't leak
>> memory in the middle of the patch set)
>>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>  drivers/usb/host/xhci-hub.c  |  21 +++--
>>  drivers/usb/host/xhci-ring.c | 107 +++++++++++++-----------
>>  drivers/usb/host/xhci.c      | 194 ++++++++++++++++++++++++++++---------------
>>  drivers/usb/host/xhci.h      |  31 +++----
>>  4 files changed, 216 insertions(+), 137 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
>> index 1ad6bc1..3ce9c0a 100644
>> --- a/drivers/usb/host/xhci-hub.c
>> +++ b/drivers/usb/host/xhci-hub.c
>> @@ -20,7 +20,8 @@
>>   * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>   */
>>
>> -#include <linux/gfp.h>
>> +
>> +#include <linux/slab.h>
>>  #include <asm/unaligned.h>
>>
>>  #include "xhci.h"
>> @@ -284,12 +285,22 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
>>
>>         spin_lock_irqsave(&xhci->lock, flags);
>>         for (i = LAST_EP_INDEX; i > 0; i--) {
>> -               if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue)
>> -                       xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
>> +               if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue) {
>> +                       struct xhci_command *command;
>> +                       command = xhci_alloc_command(xhci, false, false,
>> +                                                    GFP_NOIO);
> 
> ...this needs to be GFP_NOWAIT, or move it outside the lock.
> 

That's right, thanks, I'll fix it.

-Mathias

