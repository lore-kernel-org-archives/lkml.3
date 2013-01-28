Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3A1Nvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:51:46 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:58141 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab3A1Nvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:51:44 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
	<CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
	<CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
	<87623ydnvq.fsf@devron.myhome.or.jp>
	<CAKYAXd8GgrG+cMN_wQDFLiuXoBPbR7c6N9eZqGCrK-OH3HpuZA@mail.gmail.com>
	<CAKYAXd9OhKDh5r6O=ACyDez1B2S=DB0Eo2-cSNuM1vaURmFNoQ@mail.gmail.com>
	<877gobn7fy.fsf@devron.myhome.or.jp>
	<CAKYAXd8SB7tz82Y57TKcngZC8vzvy1S=SAhzurA92jyobaVtNg@mail.gmail.com>
	<87obhnlmkt.fsf@devron.myhome.or.jp>
	<87k3sblmj2.fsf@devron.myhome.or.jp>
	<CAKYAXd-7kq9EoBE7e5sGXBeA8u914moz15-ubFimczGyiznUCA@mail.gmail.com>
	<87r4lgxgee.fsf@devron.myhome.or.jp>
	<CAKYAXd_Lg8twC3XVX8S3Ncm0ghicvXD0Q75-8amuO2Lz40v8Rw@mail.gmail.com>
	<8738xoshed.fsf@devron.myhome.or.jp>
	<CAKYAXd-pNnnDBeTw4s05vMdmeTcBwMMT7L7=NNUj2vLxwHYWWg@mail.gmail.com>
Date: Mon, 28 Jan 2013 22:51:38 +0900
In-Reply-To: <CAKYAXd-pNnnDBeTw4s05vMdmeTcBwMMT7L7=NNUj2vLxwHYWWg@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 28 Jan 2013 16:43:56 +0900")
Message-ID: <87wquxpg9h.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> Although checking several routines to check hang case you said, I
>>> didn't find anything.
>>> And There is no any race on test result also. Am I missing something ?
>>> Let me know your opinion.
>>
>> Hm, it's read-only. So, there may not be race for now, I'm sure there is
>> race on write path though.
> Yes, right. We checked/tested on read-only.
> Maybe have you found race with rename and unlink ?
> If yes, I think we can fix this issue with lock like this.
>
> +                       mutex_lock(&MSDOS_SB(sb)->s_lock);
>                          parent_inode = fat_rebuild_parent(sb, parent_logstart);
> +                       mutex_unlock(&MSDOS_SB(sb)->s_lock);

It is any changes to directory. ->s_lock is not preferred. We need only
per-directory lock (i.e. dir->i_mutex).

To do this, we need more bigger changes though. E.g. register temporary
inode to central list. Then, find it when building real inode. If found
temporary, grab it, and make update it as real inode.

Yes, this is a bit complex. But we would need something like this for
write support.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
