Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab3K2RLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:11:11 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34119 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab3K2RLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:11:07 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: fix potential NULL pointer dereference
Date: Fri, 29 Nov 2013 18:10:59 +0100
Message-Id: <1385745059-10408-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The rest of the code seem to imply that rmf_dumper may indeed be
NULL.  Change the code so that dumping is not even considered if
rmf_dumper callback is not set.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/staging/lustre/lustre/ptlrpc/layout.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 4d6ac686..f7b383c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -1829,8 +1829,11 @@ swabber_dumper_helper(struct req_capsule *pill,
 	else
 		do_swab = 0;
 
+	if (!field->rmf_dumper)
+		dump = 0;
+
 	if (!(field->rmf_flags & RMF_F_STRUCT_ARRAY)) {
-		if (dump && field->rmf_dumper) {
+		if (dump) {
 			CDEBUG(D_RPCTRACE, "Dump of %sfield %s follows\n",
 			       do_swab ? "unswabbed " : "", field->rmf_name);
 			field->rmf_dumper(value);
@@ -1856,7 +1859,7 @@ swabber_dumper_helper(struct req_capsule *pill,
 	for (p = value, i = 0, n = len / field->rmf_size;
 	     i < n;
 	     i++, p += field->rmf_size) {
-		if (dump && field->rmf_dumper) {
+		if (dump) {
 			CDEBUG(D_RPCTRACE, "Dump of %sarray field %s, "
 			       "element %d follows\n",
 			       do_swab ? "unswabbed " : "", field->rmf_name, i);
@@ -1865,7 +1868,7 @@ swabber_dumper_helper(struct req_capsule *pill,
 		if (!do_swab)
 			continue;
 		swabber(p);
-		if (dump && field->rmf_dumper) {
+		if (dump) {
 			CDEBUG(D_RPCTRACE, "Dump of swabbed array field %s, "
 			       "element %d follows\n", field->rmf_name, i);
 			field->rmf_dumper(value);
-- 
1.8.4.1

