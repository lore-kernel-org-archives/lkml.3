Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab3EHQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872Ab3EHQMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:12:48 -0400
Date: Wed, 08 May 2013 12:12:32 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-ID: <1368029552-dzvitovl-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130508143411.GD30955@pd.tnic>
References: <20130508143411.GD30955@pd.tnic>
Subject: =?UTF-8?Q?Re:_ipc/shm.c:494:18:_warning:_unused_variable?=
 =?UTF-8?Q?_=E2=80=98hs=E2=80=99_[-Wunused-variable]?=
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130508143411.GD30955@pd.tnic>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Wed, May 08, 2013 at 04:34:11PM +0200, Borislav Petkov wrote:
> Hi,
> 
> looks like this warning came in with
> af73e4d9506d3b797509f3c030e7dcd554f7d9c4 and fires in the
> 
> # CONFIG_HUGETLB_PAGE is not set
> 
> case because
> 
> 	struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
>                                         & SHM_HUGE_MASK);
> 
> becomes
> 
> 	struct hstate *hs = ((void *)0)
> 
> due to
> 
> #define hstate_sizelog(s) NULL
> 
> Hmmm, I don't have a quick solution off the top of my head from staring
> at the code.

Thank you for the report.
I believe we can fix it with this one.
---
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date: Wed, 8 May 2013 11:48:01 -0400
Subject: [PATCH] ipc/shm.c: don't use auto variable hs in newseg()

This patch fixes "warning: unused variable 'hs'" when !CONFIG_HUGETLB_PAGE
introduced by commit af73e4d9506d "hugetlbfs: fix mmap failure in unaligned
size request".

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 ipc/shm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index e316cb9..9ff741a 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -491,9 +491,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
-		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
-						& SHM_HUGE_MASK);
-		size_t hugesize = ALIGN(size, huge_page_size(hs));
+		size_t hugesize = ALIGN(size, huge_page_size(hstate_sizelog(
+				(shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK)));
 
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
-- 
1.7.11.7
