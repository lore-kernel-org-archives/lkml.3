Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaCNULV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:11:21 -0400
Received: from www.meduna.org ([92.240.244.38]:35018 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbaCNULU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:11:20 -0400
Message-ID: <5323625B.4010203@meduna.org>
Date: Fri, 14 Mar 2014 21:11:07 +0100
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: mxs-auart gives data from previous run after close and reopen
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-03-14 21:11:15
X-Connected-IP: 95.105.163.217:6849
X-Message-Linecount: 59
X-Body-Linecount: 45
X-Message-Size: 2393
X-Body-Size: 1793
X-Received-Count: 1
X-Recipient-Count: 4
X-Local-Recipient-Count: 4
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

following scenario:

- a Freescale i.MX28 machine
- RS232 AUART looped back Rx - Tx or two different ports cross-connected
- a test program sending data in one thread and receiving in the other:
  thread A periodically sends "Quick brown fox jumps over the lazy dog",
  thread B receives
- stop the program using ctrl-C
- restart

=> sometimes the receiving thread gets "dogQuick", receiving
   characters from the previous transmission

The extra characters definitely come from the receiver - the transmission
is OK. This was verified by a scope.

My theory is that this behaviour is caused by mxs_auart_shutdown
function gating and mxs_auart_startup reenabling the clock instead
of doing a soft reset. If the clock is gated while the AUART already
has something in the FIFO, but did not generate the interrupt yet,
the internal state machine is frozen in this state. As soon as it
is reenabled, the characters are delivered to a new user.

I am using a 3.4.77 kernel, but the relevant code looks the same in
the recent kernels (when not using DMA). I also backported patches
waiting for the transmission FIFO to clear at mxs_auart_shutdown.

I did not find any possibility to fully clear the receiver - even
if one disables the AUART and reads everything from the FIFO,
the character currently in transmit might be still somewhere (the
reference manual states that disabling is effective after the
current character is received). Which might be 1 ms at 9600 and one
has no clue whether it is the case.

Also note that the function mxs_auart_reset is in fact not doing
a reset - it just makes sure that the AUART comes out of one after
the initialization. Maybe a full reset at startup is the solution...

Pleas Cc: me when answering.

Regards
-- 
                                Stano
