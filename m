Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3FCUcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:32:18 -0400
Received: from skprod3.natinst.com ([130.164.80.24]:55666 "EHLO
	us-aus-skprod3.natinst.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757286Ab3FCUcO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:32:14 -0400
X-Greylist: delayed 1551 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2013 16:32:14 EDT
MIME-Version: 1.0
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: 
References: 
Subject: Re: Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work correctly"
From: Karthik Manamcheri <karthik.manamcheri@ni.com>
To: kyle@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, torvalds@linuxfoundation.org,
        linux-serial@vger.kernel.org
Message-ID: <OF9219EF22.9BB86D35-ON86257B7F.006E67B1-86257B7F.006E67B5@ni.com>
Date: Mon, 3 Jun 2013 15:05:55 -0500
X-Mailer: Lotus Domino Web Server Release 8.5.3FP2 HF169 September 14, 2012
X-MIMETrack: Serialize by HTTP Server on US-AUS-MAIL3/AUS/M/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 06/03/2013 03:05:55 PM,
	Serialize complete at 06/03/2013 03:05:55 PM,
	Itemize by HTTP Server on US-AUS-MAIL3/AUS/M/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 06/03/2013 03:05:55 PM,
	Serialize by Router on US-AUS-MAIL3/AUS/M/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 06/03/2013 03:05:55 PM,
	Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 06/03/2013 03:05:55 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 06/03/2013 03:05:55 PM
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-03_05:2013-06-03,2013-06-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No worries, I undertand what Karthik is talking about, so I'll try to
> figure this out.
>
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4

The description for "CONFIG_SERIAL_8250_RUNTIME_UARTS" is "Set this to the maximum number of serial ports you want the kernel to register at boot time."
Setting it to 4 means that you want to use 4 legacy ports! If you do not have any legacy UARTs, you are to set this to 0.

>
> is what was set in my .config, resulting in:
>
> [3.9.y]
> 0: uart:16550A port:00001030 irq:16 tx:16522 rx:0 RTS|CTS|DTR|CD
> 1: uart:unknown port:000002F8 irq:3
> 2: uart:unknown port:000003E8 irq:4
> 3: uart:unknown port:000002E8 irq:3
>
> [3.10-rc2]
> 0: uart:unknown port:000003F8 irq:4
> 1: uart:unknown port:000002F8 irq:3
> 2: uart:unknown port:000003E8 irq:4
> 3: uart:unknown port:000002E8 irq:3
> 4: uart:16550A port:00001030 irq:16 tx:16226 rx:0 RTS|CTS|DTR|CD

You have five ports because you set CONFIG_SERIAL_8250_RUNTIME_UARTS to 4 and then you have to PCI port. This is exactly what my change addressed. We had issues with the ghost ports created in the system. In your case, if you set CONFIG_SERIAL_8250_RUNTIME_UARTS to 0, you'll have just one port which is the working available port.

> There's undeniably something wrong if RUNTIME_UARTS=0 doesn't result
> in his serial ports showing up, I'll try to help debug that, but I
> think the 3.9 behaviour is desireable if no "legacy" uarts are found.

The variable nr_uarts is set to CONFIG_SERIAL_8250_RUNTIME_UARTS and if you set it to 0, then well, nothing will be created since you are looping to nr_uarts time, which is what I changed.

> regards, Kyle

Karthik Manamcheri | Software R&D | Instrument control products | National Instruments | (512) 683 6174