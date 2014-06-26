Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaFZVOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:14:00 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37567 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFZVN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:13:59 -0400
MIME-Version: 1.0
Date: Thu, 26 Jun 2014 14:13:58 -0700
Message-ID: <CALEwOpovb2aamUp6On4NXhS8Fjuaxfhqc1EyJDG9MayZako8nQ@mail.gmail.com>
Subject: Sporadic ESP payload corruption when using IPSec in NAT-T Transport Mode
From: Evan Gilman <evan@pagerduty.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

We have a couple Ubuntu 10.04 hosts with kernel version 3.14.5 which
are experiencing TCP payload corruption when using IPSec in NAT-T
transport mode. All are running under Xen at third party providers.
When communicating with other hosts using IPSec, we see that these
corrupt TCP PDUs are still being received by the remote listener, even
though the TCP checksum is invalid.

All other checksums (IPSec authentication header and IP checksum) are
good. So, we are thinking that corruption is happening during the ESP
encapsulation and decapsulation phase (IPSec required for
reproduction). The corruption occurs sporadically, and we have not
found any one payload/packet combination that will reliably trigger
it, though we can typically reproduce it in less than 30 minutes. We
can do it very simply by reading from /dev/zero with dd and piping
through netcat. It occurs whenever a 3.14.5 kernel is involved at
either end of the conversation. I can send captures to those who are
interested. Does any of this sound familiar?

Steps and observations so far:
- tcpdump running on both sender and receiver
- ESP looks sane on the outside. TCP payload corruption can be seen
only after decryption
- Once reproduced, you may see only one or two problem packets come through
- Sometimes corruption is witnessed on the wire (suspected
encapsulation corruption)
- Sometimes corruption is _not_ witnessed on the wire, though the test
surfaces corruption (suspected decapsulation corruption)
- Corruption not witnessed over connections without a governing IPSec policy
- Corruption not witnessed after changing previously misbehaving hosts
to kernel version 2.6.32.

You can find the kernel config for the affected host here:
https://gist.github.com/evan2645/2c28d46e81d2b4c8f251

On another note, it seems the assumption that TCP payloads are safe
when encapsulated by ESP, and therefore the checksum need not be
verified, is a false one. It has certainly caused us a great deal of
pain. Is there a significant reason for bypassing TCP checksum
validation when using IPSec Transport Mode?

We are still trying to locate the exact spot in which the corruption
is occurring - any suggestions on how we could do that? We have not
seen this problem under Ubuntu 10.04 with kernel version 2.6.32.
Thanks in advance!
-- 
evan
