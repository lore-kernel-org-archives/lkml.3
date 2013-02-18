Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3BRO7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:59:49 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37800 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3BRO7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:59:47 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Andrew Bartlett <abartlet@samba.org>, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: Read support for fat_fallocate()? (was [v2] fat: editions to support fat_fallocate())
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<1360810114.1727.306.camel@jesse>
	<CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
	<1360825669.1727.337.camel@jesse>
	<CAKYAXd9tVzvP_Oa+BoUwKbpaMoVZKZgesDgrLirqoyk6AHrJ2A@mail.gmail.com>
	<1360900178.1727.393.camel@jesse> <87fw0t26qu.fsf@devron.myhome.or.jp>
	<CAKYAXd-DSo1R7zgu81vc9ckke+5doeEd2QPwqHt54OF-VZo34Q@mail.gmail.com>
Date: Mon, 18 Feb 2013 23:59:43 +0900
In-Reply-To: <CAKYAXd-DSo1R7zgu81vc9ckke+5doeEd2QPwqHt54OF-VZo34Q@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 18 Feb 2013 23:25:11 +0900")
Message-ID: <878v6lzmzk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> Hm. My concerns are compatibility and reliability. Although We can
>> change on-disk format if need, but I don't think it can be compatible
>> and reliable. If so, who wants to use it? I feel there is no reason to
>> use FAT if there is no compatible.
>>
>> Well, anyway, possible solution would be, we can pre-allocate physical
>> blocks via fallocate(2) or something, but discard pre-allocated blocks
>> at ->release() (or before unmount at least). This way would have
>> compatibility (no on-disk change over unmount) and possible breakage
>> would be same with normal extend write patterns on kernel crash
>> (i.e. Windows or fsck will truncate after i_size).
> Hi OGAWA.
> We don't need to consider device unplugging case ?
> If yes, I can rework fat fallocate patch as your suggestion.

In my suggestion, I think, kernel crash or something like unplugging
cases handles has no change from current way.

Any pre-allocated blocks are truncated by fsck as inconsistency state,
like crash before updating i_size for normal extend write.  I.e. across
unmount, nobody care whether pre-allocated or not. IOW, if there is
inconsistent between i_size and cluster chain (includes via
fallocate(2)) across unmount, it should be handled as broken state.

In short, the lifetime of pre-allocated blocks are from fallocate(2) to
->release() only.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
