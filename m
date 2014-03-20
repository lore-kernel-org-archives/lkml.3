Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaCTF4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:56:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaCTFz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:55:28 -0400
X-IronPort-AV: E=Sophos;i="4.97,692,1389715200"; 
   d="scan'208";a="9732605"
Message-ID: <532A80B1.5010002@cn.fujitsu.com>
Date: Thu, 20 Mar 2014 13:46:25 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin <bcrl@kvack.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, jmoyer@redhat.com,
        kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
        linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] aio: fix the confliction of read events and migrating
 ring page
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 13:52:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 13:52:28,
	Serialize complete at 2014/03/20 13:52:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we do not have additional protection on the page at the read events
side, so it is possible that the read of the page takes place after the
page has been freed and allocated to another part of the kernel. This
would result in the read returning invalid information.
So here we add a mutex pair before putting old page when migrating page
success to fix the confliction of reading events and migrating page.

Reported-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/aio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 88ad40c..e353085 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -319,6 +319,9 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 	ctx->ring_pages[old->index] = new;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
+	/* Ensure read event is completed before putting old page */
+	mutex_lock(&ctx->ring_lock);
+	mutex_unlock(&ctx->ring_lock);
 	put_page(old);
 
 	return rc;
-- 
1.7.7

