Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3DWWMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:12:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3DWVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [ 34/42] userns: Changing any namespace id mappings should require privileges
Date: Tue, 23 Apr 2013 14:52:32 -0700
Message-Id: <20130423215208.947820089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 41c21e351e79004dbb4efa4bc14a53a7e0af38c5 upstream.

Changing uid/gid/projid mappings doesn't change your id within the
namespace; it reconfigures the namespace.  Unprivileged programs should
*not* be able to write these files.  (We're also checking the privileges
on the wrong task.)

Given the write-once nature of these files and the other security
checks, this is likely impossible to usefully exploit.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -576,10 +576,10 @@ static ssize_t map_write(struct file *fi
 	if (map->nr_extents != 0)
 		goto out;
 
-	/* Require the appropriate privilege CAP_SETUID or CAP_SETGID
-	 * over the user namespace in order to set the id mapping.
+	/*
+	 * Adjusting namespace settings requires capabilities on the target.
 	 */
-	if (cap_valid(cap_setid) && !ns_capable(ns, cap_setid))
+	if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
 		goto out;
 
 	/* Get a buffer */


