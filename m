Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3G2LzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:55:17 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51522 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3G2LzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:55:16 -0400
X-AuditID: 85900ec0-d38c8b900000151e-9a-51f65821f975
Message-ID: <51F6580B.30409@hitachi.com>
Date: Mon, 29 Jul 2013 20:54:51 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, itoukzo@nttdata.co.jp
Subject: Re: Re: [RFC PATCH 0/5] Add a hash value for each line in /dev/kmsg
References: <20130703014616.18745.34699.stgit@localhost.localdomain> <CAPXgP11HzstSBt1PQUgJeGC59yXc=DSYQuruB40LOsm=RZQBZA@mail.gmail.com>
In-Reply-To: <CAPXgP11HzstSBt1PQUgJeGC59yXc=DSYQuruB40LOsm=RZQBZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2013/07/26 21:43), Kay Sievers wrote:> On Wed, Jul 3, 2013 at 3:46 AM, Hidehiro Kawai
> <hidehiro.kawai.ez@hitachi.com> wrote:
>
>> This patch series adds hash values of printk format strings into
>> each line of /dev/kmsg outputs as follows:
>>
>>         6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs
>
> /dev/kmsg is to a certain degree a kernel ABI. Having source code
> locations in exported log records might cause people / userspace tools
> to rely on these strings and expect stability here. The kernel though
> cannot make any promises of its source code layout.

All we have to keep as kABI is <hash>@<filename>:<lineno> of the 5th field.
I regard the 5th field including hash as just a hint; it's not guaranteed
either the hash is unique or filename:lineno is unchanged.  Userspace
tools can use the hash to identify the message quickly, but if a hash
collision occurs, the user space need to do message matching in a
traditional way.  Please note that userspace tools can know which ones
collide from a catalog generated at build time.

As for <filename>:<lineno>, it wouldn't be needed for the most of the cases.
So I think I can introduce an option to suppress the output of
<filename>:<lineno> to reduce memory space.

> The hash is supposed to identify the content of a message, but what if
> someone fixes the string? Maybe someone just fixes a one char typo,
> the hash will change and the message will not be recognizable any
> more.

A catalog file which includes hash, location info, and message is
generated at build time.  Combining this information with diff between
two kernel versions, userspace tools will be able to track where
messages moved and which messages changed.  Then, the userspace tool
updates the message DB managed by it.  So I don't think it's a hard
problem.

> As much as "automated" hash creation sounds simple; I really think
> adding explicit "manually" created random message ids to the bunch of
> messages that are interesting is the better option long-term. It
> shouldn't be that many messages, most of the printk output is not
> really useful for automated inspection or to trigger specific actions.

Yes, as far as the use case goes, it may be true.  But it has some
drawbacks.  Please also see my reply to Joe Perches in another thread
(I resent the patches on July 25th).  Also, I heard about the discussion
at the kernel summit 2 years ago.  According to the article of LWN,
it seems that Linus objected your approach (i.e. adding random bit as
message ID).  Were there some agreements on this issue at the kernel summit?

Regards,
-- 
Hidehiro Kawai
Hitachi, Yokohama Research Laboratory
Linux Technology Center


