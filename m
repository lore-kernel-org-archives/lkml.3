Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaFCHsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:48:00 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:57997 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbaFCHr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:47:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Daniel Phillips <daniel@phunq.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net> <20140602031526.GS14410@dastard>
	<538CD855.90804@phunq.net> <20140603033322.GA14410@dastard>
	<538D72B7.3010700@phunq.net>
Date: Tue, 03 Jun 2014 16:47:52 +0900
In-Reply-To: <538D72B7.3010700@phunq.net> (Daniel Phillips's message of "Tue,
	03 Jun 2014 00:01:11 -0700")
Message-ID: <877g4yv3h3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <daniel@phunq.net> writes:

> Hi Dave,
> On 06/02/2014 08:33 PM, Dave Chinner wrote:
>> On Mon, Jun 02, 2014 at 01:02:29PM -0700, Daniel Phillips wrote:
>>>
>>> Redirty_tail nearly works, but "if (!list_empty(&wb->b_dirty))" is
>>> not correct because the inode needs to end up on the dirty list
>>> whether it was already there or not.
>> redirty_tail() always moves the inode to the end of the dirty
>> list.

It doesn't move inode to end of the dirty if wb.b_dirty is empty
(I.e. it can move from wb.b_io to wb.b_dirty too).

BTW, this is called for like mark inode dirty process, not always
writeback path.

>>> This requirement is analogous to __mark_inode_dirty() and must
>>> tolerate similar races. At the microoptimization level, calling
>>> redirty_tail from inode_writeback_touch would be less efficient
>>> and more bulky. Another small issue is, redirty_tail does not
>>> always update the timestamp, which could trigger some bogus
>>> writeback events.
>> redirty_tail does not update the timestamp when it doesn't need to
>> change. If it needs to be changed because the current value would
>> violate the time ordering requirements of the list, it rewrites it.
>>
>> So there is essentially no functional difference between the new
>> function and redirty_tail....
>
> Hirofumi, would you care to comment?

It has difference.

Say, tail->dirtied_when == 1, inode->dirtied_when == 2, and now == 30
(tail->dirtied_when is expired at 31 with default config). In this case,
redirty_tail() doesn't update ->dirtied_when.

And if inode->dirtied_when is not updated to 30, expire time has
difference. I.e. 32 vs 60.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
