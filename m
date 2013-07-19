Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab3GSDuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 23:50:07 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62337 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570Ab3GSDuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 23:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1307181004190.1245-100000@iolanthe.rowland.org>
References: <CACVXFVNV-hGZpcy2ANQaca1K5yXJ88EOq1PTkJUEHEkFk9Btvw@mail.gmail.com>
	<Pine.LNX.4.44L0.1307181004190.1245-100000@iolanthe.rowland.org>
Date: Fri, 19 Jul 2013 11:50:04 +0800
Message-ID: <CACVXFVNXAJe363O2OFHJ927BT23hCzedbG1Yt41xbDxV_d_oOg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] EHCI: add to memory barrier to updating hw_next
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Gioh Kim <gioh.kim@lge.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        namhyung.kim@lge.com, Minchan Kim <minchan.kim@lge.com>,
        Chanho Min <chanho.min@lge.com>, Jong-Sung Kim <neidhard.kim@lge.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 10:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 18 Jul 2013, Ming Lei wrote:
>
>> > I guess that HC could have a use-after-free problem like following situation.
>> >
>> > 1. A qtd which is not at the queue head should be removed in qh_completions().
>> > 2. The last->hw_next become be pointing at the next qtd but the hw_next value is delayed in write-buffer.
>> > 3. The qtd is removed in the list.
>> > 4. The qtd is freed into DMA pool and re-allocated for another urb.
>> > 5. HC try to process last->hw_next and it is pointing re-allocated qtd.
>> >
>> > What do you think about it? Is it possible?
>>
>> I understand it might not be possible because:  when 'stopped' is set, that
>> said the HC might not advance the queue. But I don't understand why
>> 'last->hw_next' is patched here under 'stopped' situation.
>
> It should not be possible.  When "stopped" is set, the QH gets unlinked
> and relinked before it can start up again.  Relinking involves some
> memory barriers, so the qTD will not be accessed again by the HC.
>
> last->hw_next gets patched because the qTD might belong to some URB in
> the middle of the queue that is being unlinked.  The URBs before it and
> after it will still be active, so the queue link has to be updated.

'stopped' is set under below situations:

     - unlink over or shutdown
     - halt
     - short packet(URB_SHORT_NOT_OK)

Looks EHCI won't advance the queue(qh) any more on above situations, so I
think last->hw_next might not need patching.

>
>> Even the 'stopped' case may be seldom triggered, do you know under
>> which condition the stopped is triggered in your problem?(stall, short read
>> or others)
>
> I was going to ask the same question.  This particular piece of code
> gets executed _only_ when an URB is unlinked.  Not during any other
> kind of error.

The code may run under 'halt' or short packet(URB_SHORT_NOT_OK) too.
If Gioh's problem falls to these two situations, below patch might be helpful.

Because the qh will be unlinked when there is fault in the endpoint(halt, short
packet), maybe it is safer to complete these URBs after the qh becomes
unlinked,  like what the blew patch does:

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index b637a65..6a65e0a 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -454,6 +454,10 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 			}
 		}

+		/* complete URBs after unlinking */
+		if (stopped && state != QH_STATE_IDLE)
+			goto exit;
+
 		/* unless we already know the urb's status, collect qtd status
 		 * and update count of bytes transferred.  in common short read
 		 * cases with only one data qtd (including control transfers),
@@ -489,15 +493,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 			}
 		}

-		/* if we're removing something not at the queue head,
-		 * patch the hardware queue pointer.
-		 */
-		if (stopped && qtd->qtd_list.prev != &qh->qtd_list) {
-			last = list_entry (qtd->qtd_list.prev,
-					struct ehci_qtd, qtd_list);
-			last->hw_next = qtd->hw_next;
-		}
-
 		/* remove qtd; it's recycled after possible urb completion */
 		list_del (&qtd->qtd_list);
 		last = qtd;
@@ -520,7 +515,7 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)

 		/* Otherwise the caller must unlink the QH. */
 	}
-
+ exit:
 	/* restore original state; caller must unlink or relink */
 	qh->qh_state = state;



Thanks,
-- 
Ming Lei
