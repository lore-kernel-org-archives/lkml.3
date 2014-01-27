Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaA0UQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:16:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaA0UQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bernd Porr <mail@berndporr.me.uk>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.13 02/10] staging: comedi: fix result of memdup_user for user chanlist
Date: Mon, 27 Jan 2014 12:17:05 -0800
Message-Id: <20140127201535.520608166@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140127201535.350372282@linuxfoundation.org>
References: <20140127201535.350372282@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Porr <mail@berndporr.me.uk>

commit e56b1401056288a725d50942ef300dcbed5e519a upstream.

If the channel list is not set in userspace we get an error at
PTR_ERR(async->cmd.chanlist). However, do_become_nonbusy(dev, s) cleans
up this pointer which causes a kernel ooops. Setting the channel list in
async to NULL and checking this in do_become_nonbusy prevents the oops.

[Ian Abbott] Also do the same for the chanlist allocated in
do_cmdtest_ioctl().

Signed-off-by: Bernd Porr <mail@berndporr.me.uk>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1425,6 +1425,7 @@ static int do_cmd_ioctl(struct comedi_de
 					  async->cmd.chanlist_len * sizeof(int));
 	if (IS_ERR(async->cmd.chanlist)) {
 		ret = PTR_ERR(async->cmd.chanlist);
+		async->cmd.chanlist = NULL;
 		DPRINTK("memdup_user failed with code %d\n", ret);
 		goto cleanup;
 	}
@@ -1547,6 +1548,7 @@ static int do_cmdtest_ioctl(struct comed
 				       cmd.chanlist_len * sizeof(int));
 		if (IS_ERR(chanlist)) {
 			ret = PTR_ERR(chanlist);
+			chanlist = NULL;
 			DPRINTK("memdup_user exited with code %d", ret);
 			goto cleanup;
 		}


