Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaLDBv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:51:58 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:64054 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaLDBv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:51:57 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hugh Dickins" <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: shmem: avoid overflowing in shmem_fallocate
Thread-Topic: [PATCH] mm: shmem: avoid overflowing in shmem_fallocate
Thread-Index: AQHQD2TPMqZEAd4qU0mtvy1pFC2HGA==
Date: Thu, 4 Dec 2014 01:51:25 +0000
Message-ID: <20141204015120.GA2522@hori1.linux.bs1.fc.nec.co.jp>
References: <1417652657-1801-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1417652657-1801-1-git-send-email-sasha.levin@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.29]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <45D0DB6519F4164CA50E8EAA753C59A7@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 07:24:07PM -0500, Sasha Levin wrote:
> "offset + len" has the potential of overflowing. Validate this user input
> first to avoid undefined behaviour.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  mm/shmem.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 185836b..5a0e344 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2098,6 +2098,9 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  	}
>  
>  	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
> +	error = -EOVERFLOW;
> +	if ((u64)len + offset < (u64)len)
> +		goto out;

Hi Sasha,

It seems to me that we already do some overflow check in common path,
do_fallocate():

        /* Check for wrap through zero too */
        if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
                return -EFBIG;

Do we really need another check?

And this patch changes the return value of fallocate(2), so you need
update man document.

BTW, when I'm reading your patch, I noticed that returning -EOVERFLOW
(rather than -EFBIG) looks better when ((offset + len) < 0) in
do_fallocate() is true.

Thanks,
Naoya Horiguchi