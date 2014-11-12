Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaKLPFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:05:06 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36726 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKLPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:05:04 -0500
Message-ID: <5463771C.1070603@acm.org>
Date: Wed, 12 Nov 2014 09:05:00 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Dmitry Rakhchev <rda@pigeonpoint.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Rocky Craig <rocky.craig@hp.com>
Subject: Re: [PATCH 1/1] Prevent the ipmi_bt_sm driver from attempting to
 send larger messages than hardware accept
References: <2675118.GcFULK9BJq@rda_note>
In-Reply-To: <2675118.GcFULK9BJq@rda_note>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably a good idea, but I would expect that the BMC would
respond with a "Request data field length limit exceeded. (C8h)"
completion code in this case instead of being silent.  Though as far as
I can tell there's nothing in the spec that says what should happen in
this case.

Rocky, what do you think?

-corey

On 11/11/2014 04:40 AM, Dmitry Rakhchev wrote:
> While testing our IPMC implementation for maximal message size I've
> encountered hardware buffer overflow in BT driver.
>
> The problem is visible as a timeout on the driver side, and our IPMC received
> garbage instead of message.
>
> To reproduce:
> # ipmitool raw 0xa 0x12 0x0 0x0 0x0   0x01 0x00 0x00 0x01 0x08 0x10 0x00 0xe6 0x01 0x07 0x19 0x00 0x26 0x70 0xc3 0x50 0x50 0x53 0xd0 0x42 0x4d 0x52 0x2d 0x41 0x32 0x46 0x2d 0x41 0x54 0x43 0x41 0x2d 0x42 0x54 0x52 0xca 0x50 0x50 0x53 0x78 0x78 0x78 0x78 0x78 0x78 0x78 0xc2 0x41 0x20 0xcc 0x66 0x72 0x75 0x2d 0x69 0x6e 0x66 0x01
> Unable to send RAW command (channel=0x0 netfn=0xa lun=0x0 cmd=0x12 rsp=0xc3): 
> Timeout
>
> From dmesg:
> [  353.844011] IPMI BT: timeout in RD_WAIT [ ] 1 retries left
> [  355.845011] IPMI BT: timeout in RD_WAIT [ ] 
> [  355.845017] failed 2 retries, sending error response
>
> Dump of messages on IPMC:
> <B>: <-- { 18 35 01 }
> <B>: --> { 1C 35 01 00 12 80 01 20 02 2D 0A 40 00 DA BB }
> <B>: <-- { B0 36 00 00 }
> <B>: --> { B4 36 00 00 00 32 01 00 }
> <B>: <-- { B0 37 01 00 }
> <B>: --> { B4 37 01 00 00 42 84 FF 00 00 00 }
> <B>: <-- { 28 }
> <B>: <-- { 28 }
>
> Last two messages are the corrupted raw message from ipmitool above (extra 0x01 byte overwrite the length).
>
> Maximum message size check in bt_start_transaction shall respect maximum 
> request size reported by Get BT Capabilities.
>
> Solution: store the size returned from IPMC and use it to check maximal 
> allowed message size. Use minimal value 63 required by IPMI until the real
> maximum is known.
>
> Changes tested on 3.15.10-200.fc20.i686+PAE.
>
> Signed-off-by: Dmitry Rakhchev <rda@pigeonpoint.com>
> ---
>  drivers/char/ipmi/ipmi_bt_sm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
> index 61e7161..c64ad02 100644
> --- a/drivers/char/ipmi/ipmi_bt_sm.c
> +++ b/drivers/char/ipmi/ipmi_bt_sm.c
> @@ -58,6 +58,7 @@ MODULE_PARM_DESC(bt_debug, "debug bitmask, 1=enable, 2=messages, 4=states");
>  #define BT_NORMAL_TIMEOUT	5	/* seconds */
>  #define BT_NORMAL_RETRY_LIMIT	2
>  #define BT_RESET_DELAY		6	/* seconds after warm reset */
> +#define BT_MINIMAL_MESSAGE_SIZE	63	/* Does not include the length byte */
>  
>  /*
>   * States are written in chronological order and usually cover
> @@ -105,6 +106,7 @@ struct si_sm_data {
>  	int		nonzero_status;	/* hung BMCs stay all 0 */
>  	enum bt_states	complete;	/* to divert the state machine */
>  	int		BT_CAP_outreqs;
> +	int		BT_CAP_inbufsz;
>  	long		BT_CAP_req2rsp;
>  	int		BT_CAP_retries;	/* Recommended retries */
>  };
> @@ -203,6 +205,7 @@ static unsigned int bt_init_data(struct si_sm_data *bt, struct si_sm_io *io)
>  	bt->complete = BT_STATE_IDLE;	/* end here */
>  	bt->BT_CAP_req2rsp = BT_NORMAL_TIMEOUT * USEC_PER_SEC;
>  	bt->BT_CAP_retries = BT_NORMAL_RETRY_LIMIT;
> +	bt->BT_CAP_inbufsz = BT_MINIMAL_MESSAGE_SIZE;
>  	/* BT_CAP_outreqs == zero is a flag to read BT Capabilities */
>  	return 3; /* We claim 3 bytes of space; ought to check SPMI table */
>  }
> @@ -229,7 +232,7 @@ static int bt_start_transaction(struct si_sm_data *bt,
>  
>  	if (size < 2)
>  		return IPMI_REQ_LEN_INVALID_ERR;
> -	if (size > IPMI_MAX_MSG_LENGTH)
> +	if ((size + 1) > bt->BT_CAP_inbufsz)
>  		return IPMI_REQ_LEN_EXCEEDED_ERR;
>  
>  	if (bt->state == BT_STATE_LONG_BUSY)
> @@ -651,6 +654,7 @@ static enum si_sm_result bt_event(struct si_sm_data *bt, long time)
>  		bt_init_data(bt, bt->io);
>  		if ((i == 8) && !BT_CAP[2]) {
>  			bt->BT_CAP_outreqs = BT_CAP[3];
> +			bt->BT_CAP_inbufsz = BT_CAP[4];
>  			bt->BT_CAP_req2rsp = BT_CAP[6] * USEC_PER_SEC;
>  			bt->BT_CAP_retries = BT_CAP[7];
>  		} else

