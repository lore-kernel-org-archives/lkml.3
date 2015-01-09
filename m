Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbbAIIeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:34:37 -0500
Received: from fortimail.online.lv ([81.198.164.220]:53607 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbbAIIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:34:36 -0500
Message-ID: <54AF9297.1070603@apollo.lv>
Date: Fri, 09 Jan 2015 10:34:31 +0200
From: Raimonds Cicans <ray@apollo.lv>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0)
 Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Help needed: complex case bisection (TBS6981)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
DomainKey-Status: no signature
DKIM-Status: no signature
X-AXIGEN-DK-Result: No records
X-AXIGEN-DKIM-Result: No records
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I would like to receive comments, suggestions and criticism
on my plan to bisect following problem.

History of problem:
1) I own computer based on AMD Athlon(tm) II X2 240e Processor on Asus 
M5A97 LE R2.0 motherboard
2) I own TBS6981 card (Dual DVB-S/S2 PCIe receiver, in kernel driver)
3) I used kernel 3.13.something
4) everything was fine
5) time to time I tried to upgrade to newer kernels
     but I got AMD IOMMU driver regression
     (AMD-Vi: Completion-Wait loop timed out)
6) I tried to disable IOMMU, but this lead to problems with NIC and USB 
controller
7) I was forced to upgrade to newer kernel (I needed all new fixes for 
BTRFS file system)
8) I bought TBS6285 (Quad DVB-T/T2 PCIe receiver)
9) I upgraded to kernel 3.17.7
     AMD IOMMU driver regression disappeared
     but appeared two IOMMU related problems with TBS6981:

WARNING: CPU: 0 PID: 13204 at drivers/iommu/amd_iommu.c:2625 
dma_ops_domain_unmap.part.9+0x4d/0x56()

and

AMD-Vi: Event logged [IO_PAGE_FAULT device=08:00.0 domain=0x001c 
address=0x0000000001355000 flags=0x0000]

As I understand first message mean "we tried to unmap same dma region twice"
and second mean "we tried to dma to/from region that do not exist"

IMHO this mean that cause for those messages can be single commit

Hypotheses:
1) Bug(s) in motherboard's hardware/BIOS (why it worked before?)
2) TBS6981 conflicts with TBS6285
3) Bug(s) in TBS6981 driver
4) Bug(s) in media subsystem (video buffer dma part)
5) Bug(s) in AMD IOMMU driver


Bisection plan:
0. take out from computer all unnecessary hardware (including TBS6285)
1. install latest known good kernel (3.13.something)
     I will use this kernel because I want to rule out AMD IOMMU regression
2. cold reboot and test everything is working
3. take linux-media tree and compile drivers from HEAD
4. cold reboot and test
     if everything is working, then
                     a) problem is fixed in HEAD
                         or
                     b) compatibility problem with TBS6285
                         or
                     c) problem is related to AMD IOMMU driver 
regression in
                         newer kernels
                     to distinguish between this cases I should build
                     newest kernel with HEAD media drivers
                     if everything is working then case a) or b)
                             and I must put TBS6285 back and test again
                     else this is case c) and I should bisect 
linux-kernel tree for this problem
                             (git bisect start; git bisect bad v3.14; 
git bisect good v3.13)

                     end of testing

     if TBS6981 driver misbehaves, then I should git bisect linux-media tree

5. bisect linux-media tree
     (git bisect start -- drivers/media; git bisect bad v3.17; git 
bisect good v3.13)

     if I find single commit that is cause for both messages then stop

     if at some commit only one message appear, then I should write down
     good/bad region and continue with first message and then do
     new bisection for other message but on reduced region


Thank you.


Raimonds Cicans

