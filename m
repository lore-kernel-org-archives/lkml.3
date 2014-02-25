Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaBYH4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:56:20 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37258 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBYH4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:56:19 -0500
Message-ID: <530C4C9B.7050104@gmail.com>
Date: Tue, 25 Feb 2014 09:56:11 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        kvalo@qca.qualcomm.com, linville@tuxdriver.com
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
References: <52FD08D1.3030405@gmail.com> <20140213182105.GN13576@mudshark.cambridge.arm.com> <52FD1243.9040706@gmail.com> <20140213192909.GO13576@mudshark.cambridge.arm.com> <52FE407C.3080002@gmail.com> <20140214162458.GF21986@mudshark.cambridge.arm.com>
In-Reply-To: <20140214162458.GF21986@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 14.02.2014 18:24, Will Deacon wrote:
> You could try putting back the UNALIGNED_ACCESS in net/mac80211/rx.c and
> commenting out the skb->len = desc->length  - PLCP_HEADER_LENGTH;  line
> above.
>

the following patch

diff --git a/drivers/net/wireless/ti/wl1251/rx.c 
b/drivers/net/wireless/ti/wl1251/rx.c
index 123c4bb..cde0eaf 100644
--- a/drivers/net/wireless/ti/wl1251/rx.c
+++ b/drivers/net/wireless/ti/wl1251/rx.c
@@ -180,7 +180,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
         wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);

         /* The actual length doesn't include the target's alignment */
-       skb->len = desc->length  - PLCP_HEADER_LENGTH;
+       skb_trim(skb, desc->length - PLCP_HEADER_LENGTH);

         fc = (u16 *)skb->data;

seems to fix the issue, including those "corrupt probe response" 
messages in dmesg log (I took that 'skb_trim' from the original Nokia 
kernel). Will send a properly formatted patch shortly.

Thanks,
Ivo
