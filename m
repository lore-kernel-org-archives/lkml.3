Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaBMQ5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:57:20 -0500
Received: from mx0.aculab.com ([213.249.233.131]:43170 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751538AbaBMQ5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:57:18 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Emil Goode'" <emilgoode@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Oliver Neukum <oneukum@suse.de>,
        =?Windows-1252?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Freddy Xin <freddy@asix.com.tw>, Eric Dumazet <edumazet@google.com>,
        Ming Lei <ming.lei@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Liu Junliang <liujunliang_ljl@163.com>,
        Octavian Purdila <octavian.purdila@intel.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] usbnet: remove generic hard_header_len check
Thread-Topic: [PATCH v2] usbnet: remove generic hard_header_len check
Thread-Index: AQHPKNtcE98IdcPLXUm0k0U9/GtxE5qzZj1Q
Date: Thu, 13 Feb 2014 16:56:58 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6BEF3A@AcuExch.aculab.com>
References: <1392310219-5719-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1392310219-5719-1-git-send-email-emilgoode@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Emil Goode
> This patch removes a generic hard_header_len check from the usbnet
> module that is causing dropped packages under certain circumstances
> for devices that send rx packets that cross urb boundaries.
> 
> One example is the AX88772B which occasionally send rx packets that
> cross urb boundaries where the remaining partial packet is sent with
> no hardware header. When the buffer with a partial packet is of less
> number of octets than the value of hard_header_len the buffer is
> discarded by the usbnet module.
...
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index d6f64da..955df81 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1118,6 +1118,10 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  	u16 hdr_off;
>  	u32 *pkt_hdr;
> 
> +	/* This check is no longer done by usbnet */
> +	if (skb->len < dev->net->hard_header_len)
> +		return 0;
> +

The ax88179 driver can also receive ethernet frames that cross the
end of rx URB.
It should have the code to save the last fragment (of a urb) until
the next data arrives, and then correctly merge the fragments.

It is likely that any sub-driver that sets the receive urb length
to a multiple of 1k (rather than leaving it at hard_hdr+mtu) can defrag
rx data that crosses urb boundaries.

	David



