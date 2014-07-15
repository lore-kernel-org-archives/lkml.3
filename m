Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbaGONFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:05:50 -0400
Received: from senator.holtmann.net ([87.106.208.187]:58156 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656AbaGONFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:05:48 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2] Bluetooth: BCSP fails to ACK re-transmitted frames from the peer
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <53C52541.50300@mentor.com>
Date: Tue, 15 Jul 2014 15:06:00 +0200
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Bluetooth mailing list 
	<linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dean_Jenkins@mentor.com
Content-Transfer-Encoding: 7BIT
Message-Id: <65682881-0875-408A-8A7B-C0BFB6C669F0@holtmann.org>
References: <1405417294-24832-1-git-send-email-jiada_wang@mentor.com> <B8E404C6-6A75-41E8-9506-0B05AA4C56D6@holtmann.org> <53C52541.50300@mentor.com>
To: Jiada Wang <jiada_wang@mentor.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiada,

>>> Send an ACK frame with the current txack value in response to
>>> every received reliable frame unless a TX reliable frame is being
>>> sent. This modification allows re-transmitted frames from the remote
>>> peer to be acknowledged rather than ignored. It means that the remote
>>> peer knows which frame number to start re-transmitting from.
>>> 
>>> Without this modification, the recovery time to a missing frame
>>> from the remote peer was unnecessarily being extended because the
>>> headers of the out of order reliable frames were being discarded rather
>>> than being processed. The frame headers of received frames will
>>> indicate whether the local peer's transmissions have been
>>> acknowledged by the remote peer. Therefore, the local peer may
>>> unnecessarily re-transmit despite the remote peer already indicating
>>> that the frame had been acknowledged in out of order reliable frame.
>>> 
>>> Signed-off-by: Dean Jenkins <djenkins@mvista.com>
>>> Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
>>> ---
>>> drivers/bluetooth/hci_bcsp.c | 94 ++++++++++++++++++++++++++++----------------
>>> 1 file changed, 60 insertions(+), 34 deletions(-)
>>> 
>>> diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
>>> index 21cc45b..0f4664d 100644
>>> --- a/drivers/bluetooth/hci_bcsp.c
>>> +++ b/drivers/bluetooth/hci_bcsp.c
>>> @@ -478,13 +478,29 @@ static inline void bcsp_unslip_one_byte(struct bcsp_struct *bcsp, unsigned char
>>> static void bcsp_complete_rx_pkt(struct hci_uart *hu)
>>> {
>>> 	struct bcsp_struct *bcsp = hu->priv;
>>> -	int pass_up;
>>> +	int pass_up = 0;
>>> 
>>> 	if (bcsp->rx_skb->data[0] & 0x80) {	/* reliable pkt */
>>> 		BT_DBG("Received seqno %u from card", bcsp->rxseq_txack);
>>> -		bcsp->rxseq_txack++;
>>> -		bcsp->rxseq_txack %= 0x8;
>>> -		bcsp->txack_req    = 1;
>>> +
>>> +		/* check the rx sequence number is as expected */
>>> +		if ((bcsp->rx_skb->data[0] & 0x07) == bcsp->rxseq_txack) {
>>> +			bcsp->rxseq_txack++;
>>> +			bcsp->rxseq_txack %= 0x8;
>>> +		} else {
>>> +			/*
>>> +			 * handle re-transmitted packet or
>>> +			 * when packet was missed
>>> +			 */
>> 
>> Comment style is wrong.
>> 
>> 	/* aaa
>> 	 * bbb
>> 	 */
>> 
>>> +			BT_ERR ("Out-of-order packet arrived, got %u expected %u",
>>> +				bcsp->rx_skb->data[0] & 0x07, bcsp->rxseq_txack);
>> 
>> It is BT_ERR(" and not BT_ERR (".
>> 
>>> +
>>> +			/* do not process out-of-order packet payload */
>>> +			pass_up = 2;
>>> +		}
>>> +
>>> +		/* send current txack value to all recieved reliable packets */
>>> +		bcsp->txack_req = 1;
>>> 
>>> 		/* If needed, transmit an ack pkt */
>>> 		hci_uart_tx_wakeup(hu);
>>> @@ -493,26 +509,36 @@ static void bcsp_complete_rx_pkt(struct hci_uart *hu)
>>> 	bcsp->rxack = (bcsp->rx_skb->data[0] >> 3) & 0x07;
>>> 	BT_DBG("Request for pkt %u from card", bcsp->rxack);
>>> 
>>> +	/*
>>> +	 * handle recieved ACK indications,
>>> +	 * including those from out-of-order packets
>>> +	 */
>> 
>> Same here. Please fix comment style.
>> 
>>> 	bcsp_pkt_cull(bcsp);
>>> -	if ((bcsp->rx_skb->data[1] & 0x0f) == 6 &&
>>> -			bcsp->rx_skb->data[0] & 0x80) {
>>> -		bt_cb(bcsp->rx_skb)->pkt_type = HCI_ACLDATA_PKT;
>>> -		pass_up = 1;
>>> -	} else if ((bcsp->rx_skb->data[1] & 0x0f) == 5 &&
>>> -			bcsp->rx_skb->data[0] & 0x80) {
>>> -		bt_cb(bcsp->rx_skb)->pkt_type = HCI_EVENT_PKT;
>>> -		pass_up = 1;
>>> -	} else if ((bcsp->rx_skb->data[1] & 0x0f) == 7) {
>>> -		bt_cb(bcsp->rx_skb)->pkt_type = HCI_SCODATA_PKT;
>>> -		pass_up = 1;
>>> -	} else if ((bcsp->rx_skb->data[1] & 0x0f) == 1 &&
>>> -			!(bcsp->rx_skb->data[0] & 0x80)) {
>>> -		bcsp_handle_le_pkt(hu);
>>> -		pass_up = 0;
>>> -	} else
>>> -		pass_up = 0;
>>> -
>>> -	if (!pass_up) {
>>> +
>>> +	if (pass_up != 2) {
>>> +		if ((bcsp->rx_skb->data[1] & 0x0f) == 6 &&
>>> +				bcsp->rx_skb->data[0] & 0x80) {
>> 
>> Fix indentation here.
> 
> Can you tell me what should be the correct indentation.

		if ((bcsp->... &&
		    (bcsp->... )) {

Regards

Marcel

