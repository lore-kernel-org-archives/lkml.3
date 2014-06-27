Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaF0Tab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:30:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60278 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaF0Ta3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:30:29 -0400
Date: Fri, 27 Jun 2014 12:30:28 -0700 (PDT)
Message-Id: <20140627.123028.1903125579029261105.davem@davemloft.net>
To: zoltan.kiss@schaman.hu
Cc: steffen.klassert@secunet.com, minipli@googlemail.com, dborkman@redhat.com,
        tgraf@suug.ch, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next] pktgen: Fill the payload optionally with a
 pattern
From: David Miller <davem@davemloft.net>
In-Reply-To: <53AD32E3.7030405@schaman.hu>
References: <1403642415-9560-1-git-send-email-zoltan.kiss@citrix.com>
	<20140625.175417.231387590142784357.davem@davemloft.net>
	<53AD32E3.7030405@schaman.hu>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Jun 2014 12:30:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@schaman.hu>
Date: Fri, 27 Jun 2014 10:01:23 +0100

> On 26/06/14 01:54, David Miller wrote:
>> From: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Date: Tue, 24 Jun 2014 21:40:15 +0100
>>
>>> Introduces a new flag called PATTERN, which puts a non-periodic,
>>> predicatble
>>> pattern into the payload. This was useful to reproduce an otherwise
>>> intermittent
>>> bug in xen-netback [1], where checksum checking doesn't help.
>>> The pattern is a repetition of " %lu", a series of increasing numbers
>>> divided by
>>> space. The value of the number is the size of the preceding payload
>>> area. E.g.
>>> " 1 3 5"..." 1000 1005 1010"
>>> If the pattern is used, every frag will have its own page, unlike
>>> before, so it
>>> needs more memory.
>>>
>>> [1] 5837574: xen-netback: Fix grant ref resolution in RX path
>>>
>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> You are changing the page allocation strategy regardless of the
>> pattern
>> setting, this is undesirable.
>>
>> It may be significantly faster to use the same page for all the frags,
>> and this is absolutely critical for pktgen usage where every
>> nanosecond
>> of performance counts.
> If the PATTERN flag is not used, it always using the pages[0] page, so
> it falls back to the original way.

That's now what I see.

If the size exceeds a page, the current code will use the same page over
and over again.

Your new code always increments 'i' and allocates a new page, regardless
of whether the PATTERN flag is set.

Or do I misread your changes?
