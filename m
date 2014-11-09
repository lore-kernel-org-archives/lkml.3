Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaKIHup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 02:50:45 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:48935 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaKIHuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 02:50:44 -0500
Date: Sat, 8 Nov 2014 23:50:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] input: alps: For protocol V3, do not process data
 when last packet's bit7 is set
Message-ID: <20141109075039.GA34700@dtor-ws>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
 <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
 <1414884310-19842-4-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414884310-19842-4-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Sun, Nov 02, 2014 at 12:25:09AM +0100, Pali Rohár wrote:
> Sometimes on Dell Latitude laptops psmouse/alps driver receive invalid ALPS
> protocol V3 packets with bit7 set in last byte. More often it can be reproduced
> on Dell Latitude E6440 or E7440 with closed lid and pushing cover above touchpad.
> 
> If bit7 in last packet byte is set then it is not valid ALPS packet. I was told
> that ALPS devices never send these packets. It is not know yet who send those
> packets, it could be Dell EC, bug in BIOS and also bug in touchpad firmware...
> 
> With this patch alps driver does not process those invalid packets and drops it
> with PSMOUSE_FULL_PACKET so psmouse driver does not enter to out of sync state.
> 
> This patch fix problem when psmouse driver still resetting ALPS device when
> laptop lid is closed because of receiving invalid packets in out of sync state.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/input/mouse/alps.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 7c47e97..e802d28 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -1181,6 +1181,16 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
>  		return PSMOUSE_BAD_DATA;
>  	}
>  
> +	if (priv->proto_version == ALPS_PROTO_V3 && psmouse->pktcnt == psmouse->pktsize) {
> +		// For protocol V3, do not process data when last packet's bit7 is set
> +		if (psmouse->packet[psmouse->pktcnt - 1] & 0x80) {
> +			psmouse_dbg(psmouse, "v3 discard packet[%i] = %x\n",
> +				    psmouse->pktcnt - 1,
> +				    psmouse->packet[psmouse->pktcnt - 1]);
> +			return PSMOUSE_FULL_PACKET;
> +		}
> +	}

I wanted to apply it, but I would like some more data. Could you please
send me the dmesg with i8042.debug wit this patch in place?

Thanks!

-- 
Dmitry
