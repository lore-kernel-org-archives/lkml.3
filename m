Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3KYN4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:56:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab3KYNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:54:04 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Fabian Yamaguchi" <fabs@goesec.de>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Nico Golde" <nico@ngolde.de>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.351537312@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 83/87] uml: check length in exitcode_proc_write()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 201f99f170df14ba52ea4c52847779042b7a623b upstream.

We don't cap the size of buffer from the user so we could write past the
end of the array here.  Only root can write to this file.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/um/kernel/exitcode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -40,9 +40,11 @@ static ssize_t exitcode_proc_write(struc
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char *end, buf[sizeof("nnnnn\0")];
+	size_t size;
 	int tmp;
 
-	if (copy_from_user(buf, buffer, count))
+	size = min(count, sizeof(buf));
+	if (copy_from_user(buf, buffer, size))
 		return -EFAULT;
 
 	tmp = simple_strtol(buf, &end, 0);

