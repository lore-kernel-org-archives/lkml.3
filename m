Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab3HORzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:55:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:41730 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759135Ab3HORz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,886,1367996400"; 
   d="scan'208";a="363217762"
Message-ID: <520D160A.10405@intel.com>
Date: Thu, 15 Aug 2013 10:55:22 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/pgtable: Fix continue to preallocate pmds even
 if failure occurrence
References: <1376526703-2081-1-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1376526703-2081-1-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 05:31 PM, Wanpeng Li wrote:
> preallocate_pmds will continue to preallocate pmds even if failure 
> occurrence, and then free all the preallocate pmds if there is 
> failure, this patch fix it by stop preallocate if failure occurrence
> and go to free path.

I guess there are a billion ways to do this, but I'm not sure we even
need 'failed':

--- arch/x86/mm/pgtable.c.orig	2013-08-15 10:52:15.145615027 -0700
+++ arch/x86/mm/pgtable.c	2013-08-15 10:52:47.509614081 -0700
@@ -196,21 +196,18 @@
 static int preallocate_pmds(pmd_t *pmds[])
 {
 	int i;
-	bool failed = false;

 	for(i = 0; i < PREALLOCATED_PMDS; i++) {
 		pmd_t *pmd = (pmd_t *)__get_free_page(PGALLOC_GFP);
 		if (pmd == NULL)
-			failed = true;
+			goto err;
 		pmds[i] = pmd;
 	}

-	if (failed) {
-		free_pmds(pmds);
-		return -ENOMEM;
-	}
-
 	return 0;
+err:
+	free_pmds(pmds);
+	return -ENOMEM;
 }

I don't have a problem with what you have, though.  It's better than
what was there, so:

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
