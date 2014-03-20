Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbaCTXlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:41:07 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.8]:54429 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759365AbaCTXlF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:41:05 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 19:41:04 EDT
X-Env-Sender: Seth.Bollinger@digi.com
X-Msg-Ref: server-13.tower-28.messagelabs.com!1395358452!24818141!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Bollinger, Seth" <Seth.Bollinger@digi.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>
Subject: Re: Possible software flow problem in serial_core
Thread-Topic: Possible software flow problem in serial_core
Thread-Index: AQHPREKU9KCJrmW7V0KAljYo9hJjt5rq7RmA//+0KoA=
Date: Thu, 20 Mar 2014 23:34:11 +0000
Message-ID: <CF50E0EB.6E95%seth.bollinger@digi.com>
References: <CF505B08.6E64%seth.bollinger@digi.com>
 <532B743F.2030705@hurleysoftware.com>
In-Reply-To: <532B743F.2030705@hurleysoftware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [172.26.1.22]
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <40F4F7B38E5B9E4FBEB8209D6928AC71@digi.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>What hardware is this?

We¹re using the Freescale mxs-auart driver (i.mx28).
 
>A 16550 transmitter doesn't shut-off at uart->stop_tx(), so the remaining
>data in the transmitter FIFO is still transmitted.

Ok, I just reviewed the 8250 driver and you¹re correct, it appears the
transmitter is only disabled on the 16C950.  I misread before (incorrectly
saw 16C550)...

>Some hardware has (relatively) big FIFOs and allows the transmitter to be
>shutoff, but these should unconditionally re-enable the transmitter
>without
>clearing the xmit fifo.

Do you have a driver that would be a good example of this?  From looking
at serial_core.c:uart_start(), is seems that start_tx() is only called if
the serial_core ring buffer is not empty.  If we don¹t stop the
transmitter, we slew too many characters.

>Are you seeing lost data? Maybe it's because soft flow-control is to
>slow to shutoff the sender?

No dropped bytes, but we do see a few bytes trapped in the fifo because we
received an XOFF.  When we receive the XON, start_tx() is never called
because the serial_core ring buffer is empty, and we have no more data to
transmit.  When we enable the transmitter manually, these bytes will pop
out.

Thanks for all of your help!

Seth

