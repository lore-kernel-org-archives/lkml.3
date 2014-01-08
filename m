Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaAHIm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:42:57 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55844 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaAHImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:42:50 -0500
Date: Wed, 8 Jan 2014 16:42:42 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: [RFC] mm: prevent set a value less than 0 to min_free_kbytes
Message-ID: <20140108084242.GA10485@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave.hansen@intel.com>,
	David Rientjes <rientjes@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010808-1344-0000-0000-000004BF06DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If echo -1 > /proc/vm/sys/min_free_kbytes, the system will hang.
Changing proc_dointvec() to proc_dointvec_minmax() in the
min_free_kbytes_sysctl_handler() can prevent this to happen.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
---
 mm/page_alloc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 77937e0..a9dcfd8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5692,7 +5692,12 @@ module_init(init_per_zone_wmark_min)
 int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
 	if (write) {
 		user_min_free_kbytes = min_free_kbytes;
 		setup_per_zone_wmarks();
-- 
1.7.7.6

