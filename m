Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3FDWnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35788 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab3FDWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:46 -0400
Message-Id: <20130604172133.207497181@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 070/184] staging: comedi: fix memory leak for saved channel
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 list

From: Ian Abbott <abbotti@mev.co.uk>

commit c8cad4c89ee3b15935c532210ae6ebb5c0a2734d upstream.

When `do_cmd_ioctl()` allocates memory for the kernel copy of a channel
list, it frees any previously allocated channel list in
`async->cmd.chanlist` and replaces it with the new one.  However, if the
device is ever removed (or "detached") the cleanup code in
`cleanup_device()` in "drivers.c" does not free this memory so it is
lost.

A sensible place to free the kernel copy of the channel list is in
`do_become_nonbusy()` as at that point the comedi asynchronous command
associated with the channel list is no longer valid.  Free the channel
list in `do_become_nonbusy()` instead of `do_cmd_ioctl()` and clear the
pointer to prevent it being freed more than once.

Note that `cleanup_device()` could be called at an inappropriate time
while the comedi device is open, but that's a separate bug not related
to this this patch.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/comedi_fops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 908f25a..b83c76f 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1035,7 +1035,6 @@ static int do_cmd_ioctl(struct comedi_device *dev, void *arg, void *file)
 		goto cleanup;
 	}
 
-	kfree(async->cmd.chanlist);
 	async->cmd = user_cmd;
 	async->cmd.data = NULL;
 	/* load channel/gain list */
@@ -1759,6 +1758,8 @@ void do_become_nonbusy(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (async) {
 		comedi_reset_async_buf(async);
 		async->inttrig = NULL;
+		kfree(async->cmd.chanlist);
+		async->cmd.chanlist = NULL;
 	} else {
 		printk(KERN_ERR
 		       "BUG: (?) do_become_nonbusy called with async=0\n");
-- 
1.7.12.2.21.g234cd45.dirty



