Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaLIPsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:48:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbaLIPsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:48:33 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 2/5] Tools: hv: remove unused bytes_written from kvp_update_file()
Date: Tue,  9 Dec 2014 16:48:20 +0100
Message-Id: <1418140103-11854-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fwrite() does not actually return the number of bytes written and
this value is being ignored anyway and ferror() is being called to
check for an error. As we assign to this variable and never use it
we get the following compile-time warning:
hv_kvp_daemon.c:149:9: warning: variable ‘bytes_written’ set but not used [-Wunused-but-set-variable]

Remove bytes_written completely.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6a6432a..5a274ca 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -147,7 +147,6 @@ static void kvp_release_lock(int pool)
 static void kvp_update_file(int pool)
 {
 	FILE *filep;
-	size_t bytes_written;
 
 	/*
 	 * We are going to write our in-memory registry out to
@@ -163,8 +162,7 @@ static void kvp_update_file(int pool)
 		exit(EXIT_FAILURE);
 	}
 
-	bytes_written = fwrite(kvp_file_info[pool].records,
-				sizeof(struct kvp_record),
+	fwrite(kvp_file_info[pool].records, sizeof(struct kvp_record),
 				kvp_file_info[pool].num_records, filep);
 
 	if (ferror(filep) || fclose(filep)) {
-- 
1.9.3

