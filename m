Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935088Ab3E2HTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:19:46 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40715 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935045Ab3E2HTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:19:45 -0400
MIME-Version: 1.0
From: =?KOI8-U?B?4c7E0sXKIPPPzM/az8LP1w==?= <andrei.solozobov@gmail.com>
Date: Wed, 29 May 2013 10:19:24 +0300
Message-ID: <CAGiC5RN=78F4=nOby8n-voCADQWb_H154kNNGOBmP_wTu-c-Vw@mail.gmail.com>
Subject: Loose source routing option in IP headers is processed incorrectly
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm a student and while doing my course work experiments I found out
this problem:

I found that loose source routing option in IP headers is processed
incorrectly (I think that correct way is explained in RFC791
http://tools.ietf.org/html/rfc791#page-18). It don't replace the
destination address with new one from rote and don't increment the
option pointer.

I made an experiment:

Three hosts 10.0.1.1, 10.0.1.2, 10.0.1.3 - all are running under
Ubuntu 12.10 quantal Linux 3.5.0-17-generic #28-Ubuntu SMP Tue Oct 9
19:32:08 UTC 2012 i686
10.0.1.1 and 10.0.1.2 connected by Ethernet cable
10.0.1.2 and 10.0.1.3 connected by WiFi ad hoc connection
10.0.1.2 has network bridge between wireless network connection and
local area connection
10.0.1.2 has Routing and Remote Access service running and in windows
register folder

/etc/sysctl.conf on 10.0.1.2 and 10.0.1.3 got entries:

net.ipv4.ip_forward = 1

net.ipv4.conf.all.accept_source_route = 1
net.ipv4.conf.lo.accept_source_route = 1
net.ipv4.conf.eth0.accept_source_route = 1
net.ipv4.conf.default.accept_source_route = 1

net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.lo.log_martians = 1
net.ipv4.conf.eth0.log_martians = 1

Example of ping ICMP request processing (Ethernet frame captures made
with Wireshark):

sent by 10.0.1.1
0000  00 04 00 01 00 06 00 22  4d 4f a0 9d 00 00 08 00   ......." MO......
0010  47 00 00 5c 00 00 40 00  40 01 0e 16 0a 00 01 01   G..\..@. @.......
0020  0a 00 01 02 01 83 07 04  0a 00 02 02 08 00 5d 08   ........ ......].
0030  3c 83 00 01 18 d8 a0 51  b9 46 01 00 08 09 0a 0b   <......Q .F......
0040  0c 0d 0e 0f 10 11 12 13  14 15 16 17 18 19 1a 1b   ........ ........
0050  1c 1d 1e 1f 20 21 22 23  24 25 26 27 28 29 2a 2b   .... !"# $%&'()*+
0060  2c 2d 2e 2f 30 31 32 33  34 35 36 37               ,-./0123 4567

received by 10.0.1.2
0000  00 00 00 01 00 06 00 22  4d 4f a0 9d 00 00 08 00   ......." MO......
0010  47 00 00 5c 00 00 40 00  40 01 0e 16 0a 00 01 01   G..\..@. @.......
0020  0a 00 01 02 01 83 07 04  0a 00 02 02 08 00 5d 08   ........ ......].
0030  3c 83 00 01 18 d8 a0 51  b9 46 01 00 08 09 0a 0b   <......Q .F......
0040  0c 0d 0e 0f 10 11 12 13  14 15 16 17 18 19 1a 1b   ........ ........
0050  1c 1d 1e 1f 20 21 22 23  24 25 26 27 28 29 2a 2b   .... !"# $%&'()*+
0060  2c 2d 2e 2f 30 31 32 33  34 35 36 37               ,-./0123 4567

sent by 10.0.2.1 (destination IP  and next IP from option not swapped,
option pointer not moved (must be 8), but packet sent to 10.0.2.2)
0000  00 04 00 01 00 06 14 d6  4d 0e ec d8 00 00 08 00   ........ M.......
0010  47 00 00 5c 00 00 40 00  3f 01 0f 16 0a 00 01 01   G..\..@. ?.......
0020  0a 00 01 02 01 83 07 04  0a 00 02 02 08 00 5d 08   ........ ......].
0030  3c 83 00 01 18 d8 a0 51  b9 46 01 00 08 09 0a 0b   <......Q .F......
0040  0c 0d 0e 0f 10 11 12 13  14 15 16 17 18 19 1a 1b   ........ ........
0050  1c 1d 1e 1f 20 21 22 23  24 25 26 27 28 29 2a 2b   .... !"# $%&'()*+
0060  2c 2d 2e 2f 30 31 32 33  34 35 36 37               ,-./0123 4567

received by 10.0.2.2 and not processed
0000  00 00 00 01 00 06 14 d6  4d 0e ec d8 00 00 08 00   ........ M.......
0010  47 00 00 5c 00 00 40 00  3f 01 0f 16 0a 00 01 01   G..\..@. ?.......
0020  0a 00 01 02 01 83 07 04  0a 00 02 02 08 00 5d 08   ........ ......].
0030  3c 83 00 01 18 d8 a0 51  b9 46 01 00 08 09 0a 0b   <......Q .F......
0040  0c 0d 0e 0f 10 11 12 13  14 15 16 17 18 19 1a 1b   ........ ........
0050  1c 1d 1e 1f 20 21 22 23  24 25 26 27 28 29 2a 2b   .... !"# $%&'()*+
0060  2c 2d 2e 2f 30 31 32 33  34 35 36 37               ,-./0123 4567

10.0.2.2 writes to /var/log/syslog record:
"May 25 19:24:57 student4 kernel: [ 1464.555708] ip_forward(): Argh!
Destination lost!" (I found that it's /net/ipv4/ip_options.c module
http://lxr.free-electrons.com/source/net/ipv4/ip_options.c?v=3.5#L550
record). It's right that there is no destination Address in the LSRR
list, because it must be replaced with emitting interface address.

Is it a bug or a feature?

Andrew Solozobov
