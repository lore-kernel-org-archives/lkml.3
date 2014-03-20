Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbaCTNvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:51:42 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:16002 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757555AbaCTNvk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:51:40 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 09:51:40 EDT
X-Env-Sender: Seth.Bollinger@digi.com
X-Msg-Ref: server-8.tower-45.messagelabs.com!1395323098!29999746!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Bollinger, Seth" <Seth.Bollinger@digi.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Possible software flow problem in serial_core
Thread-Topic: Possible software flow problem in serial_core
Thread-Index: AQHPREKU9KCJrmW7V0KAljYo9hJjtw==
Date: Thu, 20 Mar 2014 13:44:57 +0000
Message-ID: <CF505B08.6E64%seth.bollinger@digi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.10.80.99]
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean
Content-Type: text/plain; charset="utf-7"
Content-ID: <9FD5FBF13B197A438C3BE4CB23BEB732@digi.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

We+IBk-ve recently run into a possible problem with software flow control
handling in the serial+AF8-core layer.

Here is the scenario:

1. Transmit from uart to remote device
2. Remote device sends us an XOFF
3. The tty layer receives the XOFF
4. stop+AF8-tty() - The uart transmitter is stopped (ops-+AD4-stop+AF8-tx) just as the
serial+AF8-core ring is cleared (this could trap a few bytes in the fifo).
5. Remote device sends us an XON
6. The tty layer receives the XON
7. start+AF8-tty() - However, the serial+AF8-core ring is empty, so the call to
start the uart transmitter (uart+AF8-start:ops-+AD4-start+AF8-tx) is skipped

Any window, however small, could leave bytes stuck in the transmitter
forever -- particularly if there will be no further transmission until
receiving a response.

I can't find any functionality in the drivers that accounts for this
possibility.  Can you help me find how Linux serial drivers manage this
eventuality?

Thanks,

Seth

