Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaKYDCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 22:02:20 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:59908 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKYDCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 22:02:19 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 01/19] mm, thp: drop FOLL_SPLIT
Thread-Topic: [PATCH 01/19] mm, thp: drop FOLL_SPLIT
Thread-Index: AQHP+QfSWbFOdr5ZS0iDGj9k1RQfn5xwLzCA
Date: Tue, 25 Nov 2014 03:01:16 +0000
Message-ID: <20141125030109.GA21716@hori1.linux.bs1.fc.nec.co.jp>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-2-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1415198994-15252-2-git-send-email-kirill.shutemov@linux.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.12]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <C01FDC8EF842D54697B74E053094DEBA@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:49:36PM +0200, Kirill A. Shutemov wrote:
> FOLL_SPLIT is used only in two places: migration and s390.
> 
> Let's replace it with explicit split and remove FOLL_SPLIT.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
...
> @@ -1246,6 +1246,11 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
>  		if (!page)
>  			goto set_status;
>  
> +		if (PageTransHuge(page) && split_huge_page(page)) {
> +			err = -EBUSY;
> +			goto set_status;
> +		}
> +

This check makes split_huge_page() be called for hugetlb pages, which
triggers BUG_ON. So could you do this after if (PageHuge) block below?
And I think that we have "Node already in the right place" check afterward,
so I hope that moving down this check also helps us reduce thp splitting.

Thanks,
Naoya Horiguchi

>  		/* Use PageReserved to check for zero page */
>  		if (PageReserved(page))
>  			goto put_and_set;