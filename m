Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab3IYA5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:57:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3IYAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gera Kazakov <gkazakov@msn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 087/110] target: Fix >= v3.9+ regression in PR APTPL + ALUA metadata write-out
Date: Tue, 24 Sep 2013 17:15:25 -0700
Message-Id: <20130925001332.852596527@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gera Kazakov <gkazakov@msn.com>

commit f730f9158f6ee7b5c4d892af6b51a72194445ea4 upstream.

This patch fixes a >= v3.9+ regression in __core_scsi3_write_aptpl_to_file()
+ core_alua_write_tpg_metadata() write-out, where a return value of -EIO was
incorrectly being returned upon success.

This bug was originally introduced in:

commit 0e9b10a90f1c30f25dd6f130130240745ab14010
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Feb 23 15:22:43 2013 -0500

    target: writev() on single-element vector is pointless

However, given that the return of core_scsi3_update_and_write_aptpl()
was not used to determine if a command should be returned with non GOOD
status, this bug was not being triggered in PR logic until v3.11-rc1 by
commit:

commit 459f213ba162bd13e113d6f92a8fa6c780fd67ed
Author: Andy Grover <agrover@redhat.com>
Date:   Thu May 16 10:41:02 2013 -0700

    target: Allocate aptpl_buf inside update_and_write_aptpl()

So, go ahead and only return -EIO if kernel_write() returned a
negative value.

Reported-by: Gera Kazakov <gkazakov@msn.com>
Signed-off-by: Gera Kazakov <gkazakov@msn.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_alua.c |    2 +-
 drivers/target/target_core_pr.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -730,7 +730,7 @@ static int core_alua_write_tpg_metadata(
 	if (ret < 0)
 		pr_err("Error writing ALUA metadata file: %s\n", path);
 	fput(file);
-	return ret ? -EIO : 0;
+	return (ret < 0) ? -EIO : 0;
 }
 
 /*
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1987,7 +1987,7 @@ static int __core_scsi3_write_aptpl_to_f
 		pr_debug("Error writing APTPL metadata file: %s\n", path);
 	fput(file);
 
-	return ret ? -EIO : 0;
+	return (ret < 0) ? -EIO : 0;
 }
 
 static int


