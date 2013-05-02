Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3EBFM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:12:58 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:46657 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3EBFMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:12:54 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	<87bo8v42wx.fsf@devron.myhome.or.jp>
	<CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
Date: Thu, 02 May 2013 14:12:45 +0900
In-Reply-To: <CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
	(Namjae Jeon's message of "Thu, 2 May 2013 13:46:00 +0900")
Message-ID: <87vc722cdu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>>> Hm, why d_count == 1 check is needed? Feel strange and racy.
>>> Since, fat_file_release() is called on every close for the file.
>>
>> What is wrong? IIRC, it is what you choose (i.e. for each last close for
>> the file descriptor).
> Yes, this is what we had chosen after discussion. Freeing reserved
> space point being the file release path.
> But if there are multiple accessors for the file then file_release
> will be called by each process.
> Freeing the space in first call will result in wrong file attributes
> for the other points. So, we needed a differentiation of last close
> for the file.
> Am I missing something ?

Then, per-file discard fallocate space sounds like wrong. fallocate
space probably is inode attribute.

>> I know. Question is, why do we need to initialize twice.
>>
>> 1) zeroed for uninitialized area, 2) then copy user data area. We need
>> only either, right? This seems to be doing both for all fallocated area.
> We did not initialize twice. We are using the ‘pos’ as the attribute
> to define zeroing length in case of pre-allocation.
> Zeroing out occurs till the ‘pos’ while actual write occur after ‘pos’.
> If we file size is 100KB and we pre-allocated till 1MB. Next if we try
> to write at 500KB,
> Then zeroing out will occur only for 100KB->500KB, after that there
> will be normal write. There is no duplication for the same space.

Ah. Then write_begin() really initialize after i_size until page cache
boudary for append write? I wonder if this patch works correctly for
mmap.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
