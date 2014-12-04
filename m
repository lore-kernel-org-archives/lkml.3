Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaLDCd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:33:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45442 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaLDCdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:33:55 -0500
Message-ID: <547FC807.6040000@oracle.com>
Date: Wed, 03 Dec 2014 21:33:43 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: shmem: avoid overflowing in shmem_fallocate
References: <1417652657-1801-1-git-send-email-sasha.levin@oracle.com> <20141204015120.GA2522@hori1.linux.bs1.fc.nec.co.jp>
In-Reply-To: <20141204015120.GA2522@hori1.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 08:51 PM, Naoya Horiguchi wrote:
> On Wed, Dec 03, 2014 at 07:24:07PM -0500, Sasha Levin wrote:
>> > "offset + len" has the potential of overflowing. Validate this user input
>> > first to avoid undefined behaviour.
>> > 
>> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> > ---
>> >  mm/shmem.c |    3 +++
>> >  1 file changed, 3 insertions(+)
>> > 
>> > diff --git a/mm/shmem.c b/mm/shmem.c
>> > index 185836b..5a0e344 100644
>> > --- a/mm/shmem.c
>> > +++ b/mm/shmem.c
>> > @@ -2098,6 +2098,9 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>> >  	}
>> >  
>> >  	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
>> > +	error = -EOVERFLOW;
>> > +	if ((u64)len + offset < (u64)len)
>> > +		goto out;
> Hi Sasha,
> 
> It seems to me that we already do some overflow check in common path,
> do_fallocate():
> 
>         /* Check for wrap through zero too */
>         if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
>                 return -EFBIG;
> 
> Do we really need another check?

It looks like we actually need to fix this snippet you pasted rather than shmem_fallocate().

We can't check for ((offset + len) < 0) since both offset and length are signed integers. I'll
send a patch to deal with that rather that this shmem specific one. Thanks!


Thanks,
Sasha
