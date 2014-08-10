Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaHJHkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:40:47 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36434 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:40:46 -0400
MIME-Version: 1.0
Date: Sun, 10 Aug 2014 11:40:44 +0400
Message-ID: <CAHjPQwNFr5gA-vcQa0nk98U0yPgEdCj+iXWeP0_mXpjXdrW+sA@mail.gmail.com>
Subject: iSCSI target stops sending responses to login requests
From: Evgenii Lepikhin <johnlepikhin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have several NAS servers with kernels 3.4.xx-3.13.xx. We've got a
problem: after 1..4 months of work target servers stops responding to
login requests.

I made tcpdump on NAS when problem appears.
 1. TCP session has been established, server receives login request
several times (in iSCSI protocol header: immediate marker bit = 1,
opcode = 0x03, text dataload submited)
 2. Target sends response: TCP packet with incorrect checksum(!)
 3. Handshake starts again, also without success
 4. We reboot the target. Problem disappears for 1..4 months.

The dump:

17:34:56.671179 IP (tos 0x0, ttl 128, id 14261, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.1.44.1212 > 10.0.2.22.3260: Flags [S], cksum 0xedb0
(correct), seq 3581240112, win 8192, options [mss 1460,nop,wscale
8,nop,nop,sackOK], length 0
        0x0000:  4500 0034 37b5 4000 8006 abcd 0a00 012c  E..47.@........,
        0x0010:  0a00 0216 04bc 0cbc d575 6330 0000 0000  .........uc0....
        0x0020:  8002 2000 edb0 0000 0204 05b4 0103 0308  ................
        0x0030:  0101 0402                                ....

17:34:56.671195 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
TCP (6), length 52)
    10.0.2.22.3260 > 10.0.1.44.1212: Flags [S.], cksum 0x1768
(incorrect -> 0x534b), seq 418867286, ack 3581240113, win 14600,
options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
        0x0000:  4500 0034 0000 4000 4006 2383 0a00 0216  E..4..@.@.#.....
        0x0010:  0a00 012c 0cbc 04bc 18f7 6856 d575 6331  ...,......hV.uc1
        0x0020:  8012 3908 1768 0000 0204 05b4 0101 0402  ..9..h..........
        0x0030:  0103 0307                                ....

17:34:56.671345 IP (tos 0x0, ttl 128, id 14262, offset 0, flags [DF],
proto TCP (6), length 40)
    10.0.1.44.1212 > 10.0.2.22.3260: Flags [.], cksum 0xcc25
(correct), ack 1, win 256, length 0
        0x0000:  4500 0028 37b6 4000 8006 abd8 0a00 012c  E..(7.@........,
        0x0010:  0a00 0216 04bc 0cbc d575 6331 18f7 6857  .........uc1..hW
        0x0020:  5010 0100 cc25 0000 0000 0000 0000       P....%........

17:34:56.671538 IP (tos 0x0, ttl 128, id 14263, offset 0, flags [DF],
proto TCP (6), length 232)
    10.0.1.44.1212 > 10.0.2.22.3260: Flags [P.], cksum 0xcc18
(correct), seq 1:193, ack 1, win 256, length 192
        0x0000:  4500 00e8 37b7 4000 8006 ab17 0a00 012c  E...7.@........,
        0x0010:  0a00 0216 04bc 0cbc d575 6331 18f7 6857  .........uc1..hW
        0x0020:  5018 0100 cc18 0000 4300 0000 0000 0090  P.......C.......
        0x0030:  4000 0137 0001 0000 0000 0019 0001 0000  @..7............
        0x0040:  0000 0001 0000 0001 0000 0000 0000 0000  ................
        0x0050:  0000 0000 0000 0000 496e 6974 6961 746f  ........Initiato
        0x0060:  724e 616d 653d 6971 6e2e 3139 3931 2d30  rName=iqn.1991-0
        0x0070:  352e 636f 6d2e 6d69 6372 6f73 6f66 743a  5.com.microsoft:
        0x0080:  7334 3400 5365 7373 696f 6e54 7970 653d  s44.SessionType=
        0x0090:  4e6f 726d 616c 0054 6172 6765 744e 616d  Normal.TargetNam
        0x00a0:  653d 6971 6e2e 3230 3033 2d30 312e 6f72  e=iqn.2003-01.or
        0x00b0:  672e 6c69 6e75 782d 6973 6373 692e 6c32  g.linux-iscsi.l2
        0x00c0:  322e 7838 3636 343a 736e 2e39 3665 6239  2.x8664:sn.96eb9
        0x00d0:  3035 6630 6461 6200 4175 7468 4d65 7468  05f0dab.AuthMeth
        0x00e0:  6f64 3d43 4841 5000                      od=CHAP.

17:34:56.981941 IP (tos 0x0, ttl 128, id 14264, offset 0, flags [DF],
proto TCP (6), length 232)
    10.0.1.44.1212 > 10.0.2.22.3260: Flags [P.], cksum 0xcc18
(correct), seq 1:193, ack 1, win 256, length 192
        0x0000:  4500 00e8 37b8 4000 8006 ab16 0a00 012c  E...7.@........,
        0x0010:  0a00 0216 04bc 0cbc d575 6331 18f7 6857  .........uc1..hW
        0x0020:  5018 0100 cc18 0000 4300 0000 0000 0090  P.......C.......
        0x0030:  4000 0137 0001 0000 0000 0019 0001 0000  @..7............
        0x0040:  0000 0001 0000 0001 0000 0000 0000 0000  ................
        0x0050:  0000 0000 0000 0000 496e 6974 6961 746f  ........Initiato
        0x0060:  724e 616d 653d 6971 6e2e 3139 3931 2d30  rName=iqn.1991-0
        0x0070:  352e 636f 6d2e 6d69 6372 6f73 6f66 743a  5.com.microsoft:
        0x0080:  7334 3400 5365 7373 696f 6e54 7970 653d  s44.SessionType=
        0x0090:  4e6f 726d 616c 0054 6172 6765 744e 616d  Normal.TargetNam
        0x00a0:  653d 6971 6e2e 3230 3033 2d30 312e 6f72  e=iqn.2003-01.or
        0x00b0:  672e 6c69 6e75 782d 6973 6373 692e 6c32  g.linux-iscsi.l2
        0x00c0:  322e 7838 3636 343a 736e 2e39 3665 6239  2.x8664:sn.96eb9
        0x00d0:  3035 6630 6461 6200 4175 7468 4d65 7468  05f0dab.AuthMeth
        0x00e0:  6f64 3d43 4841 5000                      od=CHAP.

17:34:57.590302 IP (tos 0x0, ttl 128, id 14307, offset 0, flags [DF],
proto TCP (6), length 232)
    10.0.1.44.1212 > 10.0.2.22.3260: Flags [P.], cksum 0xcc18
(correct), seq 1:193, ack 1, win 256, length 192
        0x0000:  4500 00e8 37e3 4000 8006 aaeb 0a00 012c  E...7.@........,
        0x0010:  0a00 0216 04bc 0cbc d575 6331 18f7 6857  .........uc1..hW
        0x0020:  5018 0100 cc18 0000 4300 0000 0000 0090  P.......C.......
        0x0030:  4000 0137 0001 0000 0000 0019 0001 0000  @..7............
        0x0040:  0000 0001 0000 0001 0000 0000 0000 0000  ................
        0x0050:  0000 0000 0000 0000 496e 6974 6961 746f  ........Initiato
        0x0060:  724e 616d 653d 6971 6e2e 3139 3931 2d30  rName=iqn.1991-0
        0x0070:  352e 636f 6d2e 6d69 6372 6f73 6f66 743a  5.com.microsoft:
        0x0080:  7334 3400 5365 7373 696f 6e54 7970 653d  s44.SessionType=
        0x0090:  4e6f 726d 616c 0054 6172 6765 744e 616d  Normal.TargetNam
        0x00a0:  653d 6971 6e2e 3230 3033 2d30 312e 6f72  e=iqn.2003-01.or
        0x00b0:  672e 6c69 6e75 782d 6973 6373 692e 6c32  g.linux-iscsi.l2
        0x00c0:  322e 7838 3636 343a 736e 2e39 3665 6239  2.x8664:sn.96eb9
        0x00d0:  3035 6630 6461 6200 4175 7468 4d65 7468  05f0dab.AuthMeth
        0x00e0:  6f64 3d43 4841 5000                      od=CHAP.

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
17:34:57.662317 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
TCP (6), length 52)
    10.0.2.22.3260 > 10.0.1.44.1212: Flags [S.], cksum 0x1768
(incorrect -> 0x534b), seq 418867286, ack 3581240113, win 14600,
options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
        0x0000:  4500 0034 0000 4000 4006 2383 0a00 0216  E..4..@.@.#.....
        0x0010:  0a00 012c 0cbc 04bc 18f7 6856 d575 6331  ...,......hV.uc1
        0x0020:  8012 3908 1768 0000 0204 05b4 0101 0402  ..9..h..........
        0x0030:  0103 0307                                ....
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

17:34:57.662396 IP (tos 0x0, ttl 128, id 14309, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.1.44.1212 > 10.0.2.22.3260: Flags [.], cksum 0x92b2
(correct), ack 1, win 256, options [nop,nop,sack 1 {0:1}], length 0
        0x0000:  4500 0034 37e5 4000 8006 ab9d 0a00 012c  E..47.@........,
        0x0010:  0a00 0216 04bc 0cbc d575 63f1 18f7 6857  .........uc...hW
        0x0020:  8010 0100 92b2 0000 0101 050a 18f7 6856  ..............hV
        0x0030:  18f7 6857                                ..hW

[here handshake cycles]

Any ideas?


-- 
UNIX engineer/developer at 1Gb.ru
skype: john.lepikhin / +7(926)1462336
