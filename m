Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3KOPFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:05:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3KOPEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:04:44 -0500
Date: Fri, 15 Nov 2013 10:03:56 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: David Rientjes <rientjes@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Message-ID: <1384527836-981jfadg-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <alpine.DEB.2.02.1311141509390.30112@chino.kir.corp.google.com>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1376025702-14818-5-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130928172602.GA6191@pd.tnic>
 <1380553263-lqp3ggll-mutt-n-horiguchi@ah.jp.nec.com>
 <20130930160450.GA20030@pd.tnic>
 <1380557324-v44mpchd-mutt-n-horiguchi@ah.jp.nec.com>
 <20131112115633.GA16700@pd.tnic>
 <1384444050-v86q6ypr-mutt-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.02.1311141509390.30112@chino.kir.corp.google.com>
Subject: Re: [PATCH] mm/migrate.c: take returned value
 ofisolate_huge_page()(Re: [PATCH 4/9] migrate: add hugepage migration code
 tomove_pages())
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <alpine.DEB.2.02.1311141509390.30112@chino.kir.corp.google.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 03:11:21PM -0800, David Rientjes wrote:
> On Thu, 14 Nov 2013, Naoya Horiguchi wrote:
> 
> > Introduces a cosmetic substitution of the returned value of isolate_huge_page()
> > to suppress a build warning when !CONFIG_HUGETLBFS. No behavioral change.
> > 
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Tested-by: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > ---
> >  mm/migrate.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 4cd63c2..4a26042 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -1168,7 +1168,7 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
> >  			goto put_and_set;
> >  
> >  		if (PageHuge(page)) {
> > -			isolate_huge_page(page, &pagelist);
> > +			err = isolate_huge_page(page, &pagelist);
> >  			goto put_and_set;
> >  		}
> >  
> 
> I think it would be better to just fix hugetlb.h to do
> 
> 	static inline bool isolate_huge_page(struct page *page, struct list_head *list)
> 	{
> 		return false;
> 	}
> 
> for the !CONFIG_HUGETLB_PAGE variant.

Right. I confirmed that it fixes the warning with Borislav's .config.
Here is new one. Could you add some credit tag?

Thanks,
Naoya
---
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date: Fri, 15 Nov 2013 09:00:15 -0500
Subject: [PATCH] mm/migrate.c: take returned value of isolate_huge_page()

Introduces a cosmetic substitution of the returned value of isolate_huge_page()
to suppress a build warning when !CONFIG_HUGETLBFS. No behavioral change.

Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/hugetlb.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index acd2010328f3..25cdb9b285a9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -137,7 +137,10 @@ static inline int dequeue_hwpoisoned_huge_page(struct page *page)
 	return 0;
 }
 
-#define isolate_huge_page(p, l) false
+static inline bool isolate_huge_page(struct page *page, struct list_head *list)
+{
+	return false;
+}
 #define putback_active_hugepage(p)	do {} while (0)
 #define is_hugepage_active(x)	false
 static inline void copy_huge_page(struct page *dst, struct page *src)
-- 
1.8.3.1

