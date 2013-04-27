Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3D0KLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 06:11:23 -0400
Received: from smtprelay0056.b.hostedemail.com ([64.98.42.56]:40227 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753925Ab3D0KLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 06:11:21 -0400
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::,RULES_HIT:152:355:371:372:379:582:599:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2691:2859:2896:2907:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:6119:6261:6647:7875:7903:9025:9121:9388:10004:10394:10400:10848:11232:11233:11256:11257:11658:11914:12043:12517:12519:12555:12679:12855:13069:13071:13091:13160:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 3350
Date: Sat, 27 Apr 2013 10:10:39 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bhelgaas@google.com
Cc: stern@rowland.harvard.edu, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl
Message-ID: <771333906.75854.1367057440028.JavaMail.mail@webmail08>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
 <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
 <337833384.57445.1361860509194.JavaMail.mail@webmail08>
 <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
 <569718148.80620.1361906088301.JavaMail.mail@webmail13>
 <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com><CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.201.215]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>Did this problem ever get resolved?
>

Hello,

Unfortunately, no. Out of curiosity I've tried booting kernel
3.9-rc8 in EUFI mode but it exhibits the same problem. 

Right after the boot:

[root@localhost ~]# dd if=/dev/zero of=test bs=64M count=3
3+0 records in
3+0 records out
201326592 bytes (201 MB) copied, 1.08544 s, 185 MB/s

After suspend/resume:

# dd if=/dev/zero of=test bs=64M count=3
3+0 records in
3+0 records out
201326592 bytes (201 MB) copied, 66.5392 s, 3.0 MB/s

That's for my primary SATA-3 HDD.

Forgive me my impudence but I believe debugging the USB stack is
tangential to this problem. Something far deeper than USB support
breaks, but so far no one has come even with the slightest clue of
what that might be.

And like I mentioned before this problem doesn't affect Windows - once
I suspended it seven times in a row and it kept on chugging happily.

According to hdparm nothing changes after suspend/resume:

Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = ?
        Advanced power management level: disabled
        Recommended acoustic management value: 208, current value: 0
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns

3MB/sec matches PIO mode 0 which is ridiculous and implausible given
than this HDD is attached via SATA.

Besides hdparm says that:

# hdparm -tT --direct /dev/sda

/dev/sda:
 Timing O_DIRECT cached reads:   862 MB in  2.00 seconds = 430.77 MB/sec
 Timing O_DIRECT disk reads:  520 MB in  3.01 seconds = 173.03 MB/sec

So, only writes are affected.

My dmesg is here: http://ompldr.org/vaThpcA/dmesg
