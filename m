Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077Ab3K0CK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:10:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3K0A40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3.4 03/39] libertas: potential oops in debugfs
Date: Tue, 26 Nov 2013 16:56:27 -0800
Message-Id: <20131127005619.287770936@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a497e47d4aec37aaf8f13509f3ef3d1f6a717d88 upstream.

If we do a zero size allocation then it will oops.  Also we can't be
sure the user passes us a NUL terminated string so I've added a
terminator.

This code can only be triggered by root.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/libertas/debugfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -913,7 +913,10 @@ static ssize_t lbs_debugfs_write(struct
 	char *p2;
 	struct debug_data *d = f->private_data;
 
-	pdata = kmalloc(cnt, GFP_KERNEL);
+	if (cnt == 0)
+		return 0;
+
+	pdata = kmalloc(cnt + 1, GFP_KERNEL);
 	if (pdata == NULL)
 		return 0;
 
@@ -922,6 +925,7 @@ static ssize_t lbs_debugfs_write(struct
 		kfree(pdata);
 		return 0;
 	}
+	pdata[cnt] = '\0';
 
 	p0 = pdata;
 	for (i = 0; i < num_of_items; i++) {


