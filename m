Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3JYIa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:30:57 -0400
Received: from smtprelay0079.b.hostedemail.com ([64.98.42.79]:56648 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751464Ab3JYIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:30:55 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::,RULES_HIT:41:152:355:379:421:467:582:599:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:6261:6630:6691:7903:10004:10226:10400:10848:11026:11232:11658:11914:12043:12050:12438:12517:12519:12740:13160:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wheel45_7c40367d11360
X-Filterd-Recvd-Size: 3140
Date: Fri, 25 Oct 2013 08:30:53 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: torvalds@linux-foundation.org
Cc: fengguang.wu@intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Message-ID: <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07><CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.147.29.47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 25, 2013 02:18:50 PM, Linus Torvalds wrote:
On Fri, Oct 25, 2013 at 8:25 AM, Artem S. Tashkinov wrote:
>>
>> On my x86-64 PC (Intel Core i5 2500, 16GB RAM), I have the same 3.11 kernel
>> built for the i686 (with PAE) and x86-64 architectures. What's really troubling me
>> is that the x86-64 kernel has the following problem:
>>
>> When I copy large files to any storage device, be it my HDD with ext4 partitions
>> or flash drive with FAT32 partitions, the kernel first caches them in memory entirely
>> then flushes them some time later (quite unpredictably though) or immediately upon
>> invoking "sync".
>
>Yeah, I think we default to a 10% "dirty background memory" (and
>allows up to 20% dirty), so on your 16GB machine, we allow up to 1.6GB
>of dirty memory for writeout before we even start writing, and twice
>that before we start *waiting* for it.
>
>On 32-bit x86, we only count the memory in the low 1GB (really
>actually up to about 890MB), so "10% dirty" really means just about
>90MB of buffering (and a "hard limit" of ~180MB of dirty).
>
>And that "up to 3.2GB of dirty memory" is just crazy. Our defaults
>come from the old days of less memory (and perhaps servers that don't
>much care), and the fact that x86-32 ends up having much lower limits
>even if you end up having more memory.
>
>You can easily tune it:
>
>    echo $((16*1024*1024)) > /proc/sys/vm/dirty_background_bytes
>    echo $((48*1024*1024)) > /proc/sys/vm/dirty_bytes
>
>or similar. But you're right, we need to make the defaults much saner.
>
>Wu? Andrew? Comments?
>

My feeling is that vm.dirty_ratio/vm.dirty_background_ratio should _not_ be
percentage based, 'cause for PCs/servers with a lot of memory (say 64GB or
more) this value becomes unrealistic (13GB) and I've already had some
unpleasant effects due to it.

I.e. when I dump a large MySQL database (its dump weighs around 10GB)
- it appears on the disk almost immediately, but then, later, when the kernel
decides to flush it to the disk, the server almost stalls and other IO requests
take a lot more time to complete even though mysqldump is run with ionice -c3,
so the use of ionice has no real effect.

Artem
