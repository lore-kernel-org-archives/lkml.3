Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaAUJjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:39:11 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49601 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaAUJjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:39:07 -0500
Date: Tue, 21 Jan 2014 17:38:59 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: [RFC] restore user defined min_free_kbytes when disabling thp
Message-ID: <20140121093859.GA7546@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
	linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
	David Rientjes <rientjes@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012109-9332-0000-0000-000002D50FDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The testcase 'thp04' of LTP will enable THP, do some testing, then
disable it if it wasn't enabled. But this will leave a different value
of min_free_kbytes if it has been set by admin. So I think it's better
to restore the user defined value after disabling THP.

---

thp increases the value of min_free_kbytes in initialization. This will
change the user defined value of min_free_kbytes. So try to restore the
value when disabling thp.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 94a824f..276180b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -164,6 +164,15 @@ static int start_khugepaged(void)
 	} else if (khugepaged_thread) {
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
+
+		if (user_min_free_kbytes >= 0) {
+			pr_info("restore min_free_kbytes from %d to user "
+				"defined %d when stopping khugepaged\n",
+				min_free_kbytes, user_min_free_kbytes);
+
+			min_free_kbytes = user_min_free_kbytes;
+			setup_per_zone_wmarks();
+		}
 	}
 
 	return err;
-- 
1.7.7.6

