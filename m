Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaLWTYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:24:09 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:12320 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLWTYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:24:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,633,1413270000"; 
   d="scan'208";a="53837970"
Message-ID: <5499C154.3000500@broadcom.com>
Date: Tue, 23 Dec 2014 20:24:04 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Vaishali Thakkar <vthakkar1994@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <lauro.venancio@openbossa.org>,
        <aloisio.almeida@openbossa.org>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] NFC: port100: Introduce the use of function put_unaligned_le16
References: <20141223152747.GA14667@vaishali-Ideapad-Z570>
In-Reply-To: <20141223152747.GA14667@vaishali-Ideapad-Z570>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/14 16:27, Vaishali Thakkar wrote:
> This patch introduces the use of function put_unaligned_le16.
>
> This is done using Coccinelle and semantic patch used is as follows:
>
> @a@
> typedef u16, __le16;
> {u16,__le16} e16;
> identifier tmp;
> expression ptr;
> expression y,e;
> type T;
> @@
>
> - tmp = cpu_to_le16(y);
>
>    <+... when != tmp
> (
> - memcpy(ptr, (T)&tmp, \(2\|sizeof(u16)\|sizeof(__le16)\|sizeof(e16)\));
> + put_unaligned_le16(y,ptr);
> |
> - memcpy(ptr, (T)&tmp, ...);
> + put_unaligned_le16(y,ptr);
> )
>    ...+>
> ? tmp = e
>
> @@ type T; identifier a.tmp; @@
>
> - T tmp;
> ...when != tmp
>
> Signed-off-by: Vaishali Thakkar<vthakkar1994@gmail.com>
> ---
>   drivers/nfc/port100.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
> index 4ac4d31..f7cbca8 100644
> --- a/drivers/nfc/port100.c
> +++ b/drivers/nfc/port100.c
> @@ -18,6 +18,7 @@
>   #include<linux/module.h>
>   #include<linux/usb.h>
>   #include<net/nfc/digital.h>
> +#include<linux/unaligned/access_ok.h>

It is incorrect to use this header file as was pointed out by Johannes 
to me in a brcmfmac driver patch [1]. Unless this driver is architecture 
specific.

Regards,
Arend

[1] 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a1d69c60c44

>   #define VERSION "0.1"
>
> @@ -1136,7 +1137,6 @@ static int port100_in_send_cmd(struct nfc_digital_dev *ddev,
>   {
>   	struct port100 *dev = nfc_digital_get_drvdata(ddev);
>   	struct port100_cb_arg *cb_arg;
> -	__le16 timeout;
>
>   	cb_arg = kzalloc(sizeof(struct port100_cb_arg), GFP_KERNEL);
>   	if (!cb_arg)
> @@ -1145,9 +1145,7 @@ static int port100_in_send_cmd(struct nfc_digital_dev *ddev,
>   	cb_arg->complete_cb = cb;
>   	cb_arg->complete_arg = arg;
>
> -	timeout = cpu_to_le16(_timeout * 10);
> -
> -	memcpy(skb_push(skb, sizeof(__le16)),&timeout, sizeof(__le16));
> +	put_unaligned_le16(_timeout * 10, skb_push(skb, sizeof(__le16)));
>
>   	return port100_send_cmd_async(dev, PORT100_CMD_IN_COMM_RF, skb,
>   				      port100_in_comm_rf_complete, cb_arg);

