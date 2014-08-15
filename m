Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaHOQt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:49:58 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41238 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaHOQsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:43 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 05/10] staging/lustre/clio: reorder initialization in cl_req_alloc()
Date: Fri, 15 Aug 2014 12:48:10 -0400
Message-Id: <1408121295-29115-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In cl_req_alloc() ensure that the list heads crq_pages and crq_layers
have been initialized before passing the request to
cl_req_completion(). This fixes an oops in the error path.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/11009
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5290
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/cl_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/cl_io.c b/drivers/staging/lustre/lustre/obdclass/cl_io.c
index 6870ee8..4265821 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_io.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_io.c
@@ -1452,12 +1452,13 @@ struct cl_req *cl_req_alloc(const struct lu_env *env, struct cl_page *page,
 	if (req != NULL) {
 		int result;
 
+		req->crq_type = crt;
+		INIT_LIST_HEAD(&req->crq_pages);
+		INIT_LIST_HEAD(&req->crq_layers);
+
 		OBD_ALLOC(req->crq_o, nr_objects * sizeof(req->crq_o[0]));
 		if (req->crq_o != NULL) {
 			req->crq_nrobjs = nr_objects;
-			req->crq_type = crt;
-			INIT_LIST_HEAD(&req->crq_pages);
-			INIT_LIST_HEAD(&req->crq_layers);
 			result = cl_req_init(env, req, page);
 		} else
 			result = -ENOMEM;
-- 
1.9.3

