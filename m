Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3KAMiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:38:20 -0400
Received: from collab.rosalab.ru ([195.19.76.181]:37082 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3KAMiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:38:19 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 08:38:18 EDT
Message-ID: <52739E2F.9030605@rosalab.ru>
Date: Fri, 01 Nov 2013 16:27:27 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>
CC: Alexander Usyskin <alexander.usyskin@intel.com>,
        =?ISO-8859-1?Q?Nicol?= =?ISO-8859-1?Q?=F2_Costanza?= 
	<abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mei: cancel stall timers in mei_reset
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In case my previous mail went to /dev/null, it is all about the flood of 
error messages in the system log, like these:

mei_me 0000:00:16.0: reset: wrong host start response
mei_me 0000:00:16.0: unexpected reset: dev_state = INIT_CLIENTS
mei_me 0000:00:16.0: reset: unexpected enumeration response hbm.
mei_me 0000:00:16.0: unexpected reset: dev_state = INIT_CLIENTS

Even after the patches (https://lkml.org/lkml/2013/9/2/162) that went 
into kernel 3.10.15, the problem still shows up occasionally on my 
Lenovo X230 laptop with kernels 3.10.15, 3.10.16 and 3.11.6. It seems to 
be retated to IRQ handling now.

When the problem occurs, mei_reset() is called repeatedly and the system 
logs grow rapidly until they consume all free disk space.

Most of the messages are output by mei_hbm_dispatch().

I added debug prints to the code of mei_hbm_dispatch() and found the 
following:

1. When HOST_START_RES_CMD response is being handled, dev->hbm_state is 
0x2 sometimes, that is, MEI_HBM_ENUM_CLIENTS (!) rather than 
MEI_HBM_START what it probably should be. That's why the error message 
is printed and mei_reset() is called again.

2. When HOST_ENUM_RES_CMD response is being handled, dev->hbm_state is 
0x1 (MEI_HBM_START) while it should be MEI_HBM_ENUM_CLIENTS. This also 
results in an error message and mei_reset().

That is, dev->hbm_state contains a wrong value in both cases. I haven't 
figured out so far why it happens.

Do you know how to fix that?

Messages from the system log related to MEI:
-----------------
13:30:42 systemd-sleep[9364]: System resumed.
13:30:42 kernel: mei_me 0000:00:16.0: reset: properties response hbm 
wrong status.
13:30:42 kernel: mei_me 0000:00:16.0: unexpected reset: dev_state = 
INIT_CLIENTS
<...>
13:30:47 kernel: mei_me 0000:00:16.0: wait hw ready failed. status = -110
<...>
13:31:17 kernel: mei_me 0000:00:16.0: reset: init clients timeout 
hbm_state = 1.
13:31:17 kernel: mei_me 0000:00:16.0: unexpected reset: dev_state = 
INIT_CLIENTS
13:31:17 kernel: mei_me 0000:00:16.0: reset: wrong host start response 
(dev_state: 0x1, hbm_state: 0x2)
13:31:17 kernel: mei_me 0000:00:16.0: unexpected reset: dev_state = 
INIT_CLIENTS
13:31:17 kernel: mei_me 0000:00:16.0: reset: unexpected enumeration 
response hbm (dev_state: 0x1, hbm_state: 0x1)
13:31:17 kernel: mei_me 0000:00:16.0: unexpected reset: dev_state = 
INIT_CLIENTS
13:31:17 kernel: mei_me 0000:00:16.0: reset: wrong host start response 
(dev_state: 0x1, hbm_state: 0x2)
13:31:17 kernel: mei_me 0000:00:16.0: unexpected reset: dev_state = 
INIT_CLIENTS
13:31:17 kernel: mei_me 0000:00:16.0: reset: unexpected enumeration 
response hbm (dev_state: 0x1, hbm_state: 0x1)
13:31:17 kernel: mei_me 0000:00:16.0: unexpected reset: dev_state = 
INIT_CLIENTS
-----------------

By the way, here is MEI hw info from lspci output:
-----------------
00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210 
Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at f2535000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
	Kernel modules: mei_me
-----------------

If you need other info, please let me know.

Regards,
Eugene

-- 
Eugene Shatokhin, ROSA Laboratory.
www.rosalab.com
