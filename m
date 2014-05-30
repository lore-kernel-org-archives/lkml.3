Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbaE3PXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:23:35 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:42378 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbaE3PXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:23:33 -0400
Message-ID: <5388A27A.7040002@cogentembedded.com>
Date: Fri, 30 May 2014 19:23:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        linux-kernel@vger.kernel.org
CC: "hyungseoung.yoo" <hyungseoung.yoo@samsung.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Jaikumar Ganesh <jaikumarg@android.com>
Subject: Re: [RFC v2] Bluetooth: Keep master role when SCO or eSCO is active
References: <1401431094-2833-1-git-send-email-kiran.kumar@linaro.org>
In-Reply-To: <1401431094-2833-1-git-send-email-kiran.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/30/2014 10:24 AM, Kiran Kumar Raparthy wrote:

> From: "hyungseoung.yoo" <hyungseoung.yoo@samsung.com>

> Preserve the master role when SCO or eSCO is active
> as this improves compatability with lots of
> headset and chipset combinations.

> This is one of the number of patches from the Android AOSP
> common.git tree, which is used on almost all Android devices.
> It looks like it would improve support for compatibility with
> lot of headset,so I wanted to submit it for review to see
> if it should go upstream.

> v2: Fixed formatting issues pointed by Sergei

> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: hyungseoung.yoo <hyungseoung.yoo@samsung.com>
> Signed-off-by: Jaikumar Ganesh <jaikumarg@android.com>
> [kiran: Added context to commit message]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
>   net/bluetooth/hci_event.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)

> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 15010a2..48bc772 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -1915,6 +1915,14 @@ unlock:
>   	hci_conn_check_pending(hdev);
>   }
>
> +static inline bool is_sco_active(struct hci_dev *hdev)
> +{
> +	if (hci_conn_hash_lookup_state(hdev, SCO_LINK, BT_CONNECTED) ||
> +		hci_conn_hash_lookup_state(hdev, ESCO_LINK, BT_CONNECTED))

    The continuation line should start under the next character after ( on the 
previous line, according to the networking coding style. The way you formatted 
it, it visually groups with the following *return* statement...

> +		return true;
> +	return false;
> +}
> +
>   static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
>   {
>   	struct hci_ev_conn_request *ev = (void *) skb->data;
> @@ -1961,7 +1969,9 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
>
>   			bacpy(&cp.bdaddr, &ev->bdaddr);
>
> -			if (lmp_rswitch_capable(hdev) && (mask & HCI_LM_MASTER))
> +			if (lmp_rswitch_capable(hdev) &&
> +				((mask & HCI_LM_MASTER) ||
> +				is_sco_active(hdev)))

    Same comment.

>   				cp.role = 0x00; /* Become master */
>   			else
>   				cp.role = 0x01; /* Remain slave */

WBR, Sergei

