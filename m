Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbaHGOsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:48:30 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40283 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788AbaHGOs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:48:29 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] staging: nokia_h4: merge firmware together so that we can reduce ammount of exports
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140807090733.GC24700@amd.pavel.ucw.cz>
Date: Thu, 7 Aug 2014 07:48:48 -0700
Cc: Greg KH <gregkh@linuxfoundation.org>,
        =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FAB4A38E-6DFE-48FA-9D52-258DD77A39B6@holtmann.org>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com> <20140530123023.GA10549@amd.pavel.ucw.cz> <20140530155959.GA10682@kroah.com> <201405301815.10811@pali> <20140530163604.GA11943@kroah.com> <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org> <20140806213055.GA26046@amd.pavel.ucw.cz> <20140807002532.GB23406@kroah.com> <20140807090733.GC24700@amd.pavel.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> Merge firmware files to nokia_core, so that we can reduce ammount of
> exported functions. Also replace hand-coded check for invalid
> bluetooth address with bacmp.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/staging/nokia_h4p/Makefile b/drivers/staging/nokia_h4p/Makefile
> index 310b0f2..3398a1c 100644
> --- a/drivers/staging/nokia_h4p/Makefile
> +++ b/drivers/staging/nokia_h4p/Makefile
> @@ -1,6 +1,5 @@
> 
> obj-$(CONFIG_BT_NOKIA_H4P)		+= nokia_h4p.o
> -nokia_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o nokia_fw-csr.o \
> -		nokia_fw-bcm.o nokia_fw-ti1273.o
> +nokia_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o
> 
> ccflags-y += -D__CHECK_ENDIAN__
> diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
> index 775e1d0..501be06 100644
> --- a/drivers/staging/nokia_h4p/nokia_core.c
> +++ b/drivers/staging/nokia_h4p/nokia_core.c
> @@ -1191,6 +1191,330 @@ static int hci_h4p_remove(struct platform_device *pdev)
> 	return 0;
> }
> 
> +/* Code specific for BCM firmware -------------------------------- */
> +
> +static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info,
> +				struct sk_buff *skb)
> +{
> +	int i;
> +	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
> +	int not_valid = !bacmp(info->bd_addr, BDADDR_ANY);
> +
> +	if (not_valid) {
> +		dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
> +		/* When address is not valid, use some random but Nokia MAC */
> +		memcpy(info->bd_addr, nokia_oui, 3);
> +		get_random_bytes(info->bd_addr + 3, 3);
> +	}
> +
> +	for (i = 0; i < 6; i++)
> +		skb->data[9 - i] = info->bd_addr[i];
> +
> +	return 0;
> +}
> +
> +void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
> +{
> +	struct sk_buff *fw_skb;
> +	int err;
> +	unsigned long flags;
> +
> +	if (skb->data[5] != 0x00) {
> +		dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
> +			skb->data[5]);
> +		info->fw_error = -EPROTO;
> +	}
> +
> +	kfree_skb(skb);
> +
> +	fw_skb = skb_dequeue(info->fw_q);
> +	if (fw_skb == NULL || info->fw_error) {
> +		complete(&info->fw_completion);
> +		return;
> +	}
> +
> +	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc &&
> +			fw_skb->len >= 10) {
> +		BT_DBG("Setting bluetooth address");
> +		err = hci_h4p_bcm_set_bdaddr(info, fw_skb);
> +		if (err < 0) {
> +			kfree_skb(fw_skb);
> +			info->fw_error = err;
> +			complete(&info->fw_completion);
> +			return;
> +		}
> +	}
> +
> +	skb_queue_tail(&info->txq, fw_skb);
> +	spin_lock_irqsave(&info->lock, flags);
> +	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
> +			UART_IER_THRI);
> +	spin_unlock_irqrestore(&info->lock, flags);
> +}

and as I explained before, this crazy can not continue. Bluetooth drivers can provide a hdev->setup callback for loading firmware and doing other setup details. You can just bring up the HCI transport. We are providing __hci_cmd_sync for easy loading of the firmware. Especially if the firmware just consists of HCI commands. Which is clearly the case with the Nokia firmware files.

In addition with 3.17 you can also provide hdev->set_bdaddr to allow changing the public BD_ADDR. You can also set HCI_QUIRK_INVALID_BDADDR and bring up the controller in an unconfigured state. That way you can have userspace provide the address and avoid the hacking around the missing address issue.

Maybe at some point someone realizes that focusing on the N900 Bluetooth hardware would help in making this code simpler. Adding support for older Maemo devices can be done later.

Regards

Marcel

