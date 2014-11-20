Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaKTNub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:50:31 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60457 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaKTNua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:50:30 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v3] Bluetooth: automatically flushable packets aren't allowed on LE links
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141120113813.GA23288@t440s.lan>
Date: Thu, 20 Nov 2014 21:50:18 +0800
Cc: Steven Walter <stevenrwalter@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <80321467-10AB-489E-A47E-44B0ECEE4BE1@holtmann.org>
References: <1416419951-27659-1-git-send-email-stevenrwalter@gmail.com> <20141120113813.GA23288@t440s.lan>
To: Johan Hedberg <johan.hedberg@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

>> The bluetooth spec states that automatically flushable packets may not
>> be sent over a LE-U link.
>> 
>> Signed-off-by: Steven Walter <stevenrwalter@gmail.com>
>> ---
>> net/bluetooth/l2cap_core.c | 14 ++++++++------
>> 1 file changed, 8 insertions(+), 6 deletions(-)
>> 
>> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
>> index 4af3821..7c4350f 100644
>> --- a/net/bluetooth/l2cap_core.c
>> +++ b/net/bluetooth/l2cap_core.c
>> @@ -764,7 +764,7 @@ static void l2cap_send_cmd(struct l2cap_conn *conn, u8 ident, u8 code, u16 len,
>> 	if (!skb)
>> 		return;
>> 
>> -	if (lmp_no_flush_capable(conn->hcon->hdev))
>> +	if (lmp_no_flush_capable(conn->hcon->hdev) || conn->hcon->type == LE_LINK)
>> 		flags = ACL_START_NO_FLUSH;
>> 	else
>> 		flags = ACL_START;
>> @@ -784,7 +784,7 @@ static bool __chan_is_moving(struct l2cap_chan *chan)
>> static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
>> {
>> 	struct hci_conn *hcon = chan->conn->hcon;
>> -	u16 flags;
>> +	u16 flags = ACL_START;
>> 
>> 	BT_DBG("chan %p, skb %p len %d priority %u", chan, skb, skb->len,
>> 	       skb->priority);
>> @@ -798,11 +798,13 @@ static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
>> 		return;
>> 	}
>> 
>> -	if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
>> -	    lmp_no_flush_capable(hcon->hdev))
>> +	if (hcon->type == LE_LINK) {
>> +		/* LE-U does not support auto-flushing packets */
>> 		flags = ACL_START_NO_FLUSH;
>> -	else
>> -		flags = ACL_START;
>> +	} else if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
>> +		    lmp_no_flush_capable(hcon->hdev)) {
>> +		flags = ACL_START_NO_FLUSH;
>> +	}
> 
> I think Marcel was after just providing a clarifying code comment in
> both places - having two branches of an if-statement doing exactly the
> same thing looks a bit weird to me. To make thins completely clear I'd
> suggest adding a simple helper function that you can call from both
> places to get the needed flags, something like the following:

I am actually fine with just adding a comment explaining the complex if statement on why it is correct. It is just a helper for everybody to understand what and why it is done that way.

> static u16 get_acl_flags(struct hci_conn *hcon, struct l2cap_chan *chan)
> {

If we do it with a helper functions, then it should only provide the l2cap_chan since we can get the hci_conn from there.

> 	/* LE-U does not support auto-flushing packets */
> 	if (hcon->type == LE_LINK)
> 		return ACL_START_NO_FLUSH;
> 
> 	/* If non-flushable packets are not supported don't request them */
> 	if (!lmp_no_flush_capable(hcon->hdev))
> 		 return ACL_START;
> 
> 	/* If the chan has requested auto-flushing go with that */
> 	if (chan && test_bit(FLAG_FLUSHABLE, &chan->flags))
> 		return ACL_START;

This seems to be a bit too much. The FLAG_FLUSABLE is only settable if the controller supports it. I wonder why we need the LMP features check here in the first place. Can we not just trust the flag on the channel is set correctly and enforce it before setting the flag.
> 
> 	/* Otherwise go with a non-flushable packet */
>        return ACL_START_NO_FLUSH;
> }
> 
> This way we'd avoid complex if-statements and can clearly document each
> condition independently.

Regards

Marcel

