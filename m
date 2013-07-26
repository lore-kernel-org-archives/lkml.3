Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab3GZARP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:17:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:51963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab3GZARJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:17:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,746,1367996400"; 
   d="scan'208";a="337034474"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "minyard@acm.org" <minyard@acm.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: RE: [PATCH 03/13] ACPI/IPMI: Fix race caused by the unprotected
 ACPI IPMI transfers
Thread-Topic: [PATCH 03/13] ACPI/IPMI: Fix race caused by the unprotected
 ACPI IPMI transfers
Thread-Index: AQHOh3wQ2mCt+ewJ/06ynzhP2RS7T5lz+KeAgAC35UCAABk4AIAAZj4AgADqUHA=
Date: Fri, 26 Jul 2013 00:16:55 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802435A78@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
 <1520893.BbRK6T3F73@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E88024357A9@SHSMSX101.ccr.corp.intel.com>
 <76401540.gtU1MiBxPY@vostro.rjw.lan> <51F16A96.6040706@acm.org>
In-Reply-To: <51F16A96.6040706@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q0HjcK008113

> From: Corey Minyard [mailto:tcminyard@gmail.com]
> Sent: Friday, July 26, 2013 2:13 AM
> 
> On 07/25/2013 07:06 AM, Rafael J. Wysocki wrote:
> > On Thursday, July 25, 2013 03:09:35 AM Zheng, Lv wrote:
> >> -stable according to the previous conversation.
> >>
> >>> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> >>> Sent: Thursday, July 25, 2013 7:38 AM
> >>>
> >>> On Tuesday, July 23, 2013 04:09:15 PM Lv Zheng wrote:
> >>>> This patch fixes races caused by unprotected ACPI IPMI transfers.
> >>>>
> >>>> We can see the following crashes may occur:
> >>>> 1. There is no tx_msg_lock held for iterating tx_msg_list in
> >>>>     ipmi_flush_tx_msg() while it is parellel unlinked on failure in
> >>>>     acpi_ipmi_space_handler() under protection of tx_msg_lock.
> >>>> 2. There is no lock held for freeing tx_msg in acpi_ipmi_space_handler()
> >>>>     while it is parellel accessed in ipmi_flush_tx_msg() and
> >>>>     ipmi_msg_handler().
> >>>>
> >>>> This patch enhances tx_msg_lock to protect all tx_msg accesses to
> >>>> solve this issue.  Then tx_msg_lock is always held around
> >>>> complete() and tx_msg accesses.
> >>>> Calling smp_wmb() before setting msg_done flag so that messages
> >>>> completed due to flushing will not be handled as 'done' messages
> >>>> while their contents are not vaild.
> >>>>
> >>>> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> >>>> Cc: Zhao Yakui <yakui.zhao@intel.com>
> >>>> Reviewed-by: Huang Ying <ying.huang@intel.com>
> >>>> ---
> >>>>   drivers/acpi/acpi_ipmi.c |   10 ++++++++--
> >>>>   1 file changed, 8 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
> >>>> index
> >>>> b37c189..527ee43 100644
> >>>> --- a/drivers/acpi/acpi_ipmi.c
> >>>> +++ b/drivers/acpi/acpi_ipmi.c
> >>>> @@ -230,11 +230,14 @@ static void ipmi_flush_tx_msg(struct
> >>> acpi_ipmi_device *ipmi)
> >>>>   	struct acpi_ipmi_msg *tx_msg, *temp;
> >>>>   	int count = HZ / 10;
> >>>>   	struct pnp_dev *pnp_dev = ipmi->pnp_dev;
> >>>> +	unsigned long flags;
> >>>>
> >>>> +	spin_lock_irqsave(&ipmi->tx_msg_lock, flags);
> >>>>   	list_for_each_entry_safe(tx_msg, temp, &ipmi->tx_msg_list, head) {
> >>>>   		/* wake up the sleep thread on the Tx msg */
> >>>>   		complete(&tx_msg->tx_complete);
> >>>>   	}
> >>>> +	spin_unlock_irqrestore(&ipmi->tx_msg_lock, flags);
> >>>>
> >>>>   	/* wait for about 100ms to flush the tx message list */
> >>>>   	while (count--) {
> >>>> @@ -268,13 +271,12 @@ static void ipmi_msg_handler(struct
> >>> ipmi_recv_msg *msg, void *user_msg_data)
> >>>>   			break;
> >>>>   		}
> >>>>   	}
> >>>> -	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
> >>>>
> >>>>   	if (!msg_found) {
> >>>>   		dev_warn(&pnp_dev->dev,
> >>>>   			 "Unexpected response (msg id %ld) is returned.\n",
> >>>>   			 msg->msgid);
> >>>> -		goto out_msg;
> >>>> +		goto out_lock;
> >>>>   	}
> >>>>
> >>>>   	/* copy the response data to Rx_data buffer */ @@ -286,10
> >>>> +288,14 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg,
> >>>> void
> >>> *user_msg_data)
> >>>>   	}
> >>>>   	tx_msg->rx_len = msg->msg.data_len;
> >>>>   	memcpy(tx_msg->data, msg->msg.data, tx_msg->rx_len);
> >>>> +	/* tx_msg content must be valid before setting msg_done flag */
> >>>> +	smp_wmb();
> >>> That's suspicious.
> >>>
> >>> If you need the write barrier here, you'll most likely need a read
> >>> barrier somewhere else.  Where's that?
> >> It might depend on whether the content written before the smp_wmb() is
> used or not by the other side codes under the condition set after the
> smp_wmb().
> >>
> >> So comment could be treated as 2 parts:
> >> 1. do we need a paired smp_rmb().
> >> 2. do we need a smp_wmb().
> >>
> >> For 1.
> >> If we want a paired smp_rmb(), then it will appear in this function:
> >>
> >> 186 static void acpi_format_ipmi_response(struct acpi_ipmi_msg *msg,
> >> 187                 acpi_integer *value, int rem_time)
> >> 188 {
> >> 189         struct acpi_ipmi_buffer *buffer;
> >> 190
> >> 191         /*
> >> 192          * value is also used as output parameter. It represents the
> response
> >> 193          * IPMI message returned by IPMI command.
> >> 194          */
> >> 195         buffer = (struct acpi_ipmi_buffer *)value;
> >> 196         if (!rem_time && !msg->msg_done) {
> >> 197                 buffer->status = ACPI_IPMI_TIMEOUT;
> >> 198                 return;
> >> 199         }
> >> 200         /*
> >> 201          * If the flag of msg_done is not set or the recv length is zero,
> it
> >> 202          * means that the IPMI command is not executed correctly.
> >> 203          * The status code will be ACPI_IPMI_UNKNOWN.
> >> 204          */
> >> 205         if (!msg->msg_done || !msg->rx_len) {
> >> 206                 buffer->status = ACPI_IPMI_UNKNOWN;
> >> 207                 return;
> >> 208         }
> >> +         smp_rmb();
> >> 209         /*
> >> 210          * If the IPMI response message is obtained correctly, the
> status code
> >> 211          * will be ACPI_IPMI_OK
> >> 212          */
> >> 213         buffer->status = ACPI_IPMI_OK;
> >> 214         buffer->length = msg->rx_len;
> >> 215         memcpy(buffer->data, msg->rx_data, msg->rx_len);
> >> 216 }
> >>
> >> If we don't then there will only be msg content not correctly read from
> msg->rx_data.
> >> Note that the rx_len is 0 during initialization and will never exceed the
> sizeof(buffer->data), so the read is safe.
> >>
> >> Being without smp_rmb() is also OK in this case, since:
> >> 1. buffer->data will never be used when buffer->status is not
> >> ACPI_IPMI_OK and 2. the smp_rmb()/smp_wmb() added in this patch will be
> deleted in [PATCH 07].
> >>
> >> So IMO, we needn't add the smp_rmb(), what do you think of this?
> >>
> >> For 2.
> >> If we don't add smp_wmb() in the ipmi_msg_handler(), then the codes
> running on other thread in the acpi_format_ipmi_response() may read wrong
> msg->rx_data (a timeout triggers this function, but when
> acpi_format_ipmi_response() is entered, the msg->msg_done flag could be
> seen as 1 but the msg->rx_data is not ready), this is what we want to avoid in
> this quick fix.
> > Using smp_wmb() without the complementary smp_rmb() doesn't makes
> > sense, because each of them prevents only one flow of control from
> > being speculatively reordered, either by the CPU or by the compiler.
> > If only one of them is used without the other, then the flow of
> > control without the barrier may be reordered in a way that will
> > effectively cancel the effect of the barrier in the second flow of control.
> >
> > So, either we need *both* smp_wmb() and smp_rmb(), or we don't need
> them at all.
> 
> If I understand this correctly, the problem would be if:
> 
> rem_time = wait_for_completion_timeout(&tx_msg->tx_complete,
>                                          IPMI_TIMEOUT);
> 
> returns on a timeout, then checks msg_done and races with something setting
> msg_done.  If that is the case, you would need the smp_rmb() before checking
> msg_done.
> 
> However, the timeout above is unnecessary.  You are using
> ipmi_request_settime(), so you can set the timeout when the IPMI command
> fails and returns a failure message.  The driver guarantees a return message
> for each request.  Just remove the timeout from the completion, set the
> timeout and retries in the ipmi request, and the completion should handle the
> barrier issues.

It's just difficult for me to determine retry count and timeout value, maybe retry=0, timeout=IPMI_TIMEOUT is OK.
The code of the timeout completion is already there, I think the quick fix code should not introduce this logic.
I'll add a new patch to apply your comment.

> 
> Plus, from a quick glance at the code, it doesn't look like it will properly handle a
> situation where the timeout occurs and is handled then the response comes in
> later.

PATCH 07 fixed this issue.
Here we just need the smp_rmb() or holding tx_msg_lock() around the acpi_format_ipmi_response().

Thanks for commenting.

Best regards
-Lv

> 
> -corey
> 
> >
> > Thanks,
> > Rafael
> >
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
