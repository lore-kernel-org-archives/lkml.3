Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3EHSny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:43:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33467 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3EHSnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:43:53 -0400
Date: Wed, 8 May 2013 20:45:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: ipc/shm.c:494:18: warning: =?utf-8?Q?u?=
 =?utf-8?B?bnVzZWQgdmFyaWFibGUg4oCYaHPigJk=?= [-Wunused-variable]
Message-ID: <20130508184524.GF30955@pd.tnic>
References: <20130508143411.GD30955@pd.tnic>
 <1368029552-dzvitovl-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368029552-dzvitovl-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 12:12:32PM -0400, Naoya Horiguchi wrote:
> Thank you for the report.
> I believe we can fix it with this one.
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Wed, 8 May 2013 11:48:01 -0400
> Subject: [PATCH] ipc/shm.c: don't use auto variable hs in newseg()
> 
> This patch fixes "warning: unused variable 'hs'" when !CONFIG_HUGETLB_PAGE
> introduced by commit af73e4d9506d "hugetlbfs: fix mmap failure in unaligned
> size request".
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  ipc/shm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index e316cb9..9ff741a 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -491,9 +491,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  
>  	sprintf (name, "SYSV%08x", key);
>  	if (shmflg & SHM_HUGETLB) {
> -		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
> -						& SHM_HUGE_MASK);
> -		size_t hugesize = ALIGN(size, huge_page_size(hs));
> +		size_t hugesize = ALIGN(size, huge_page_size(hstate_sizelog(
> +				(shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK)));

Yeah, it fixes the warning alright but makes the code more unreadable.
Which makes me wonder which is worse - to have an innocuous warning or
have unreadable code.

You could also do the below. The line sticks out but it kills the
warning. Readability is hmm, not optimal still though. :)

--
diff --git a/ipc/shm.c b/ipc/shm.c
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -491,9 +491,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
-		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
-						& SHM_HUGE_MASK);
-		size_t hugesize = ALIGN(size, huge_page_size(hs));
+		unsigned long hsz = huge_page_size(hstate_sizelog((shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK));
+		size_t hugesize = ALIGN(size, hsz);
 
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
--

Yeah, you decide.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
