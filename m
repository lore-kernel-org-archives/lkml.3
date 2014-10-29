Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbaJ2Rff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:35:35 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:48955 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934602AbaJ2Rfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:35:33 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] staging: comedi: das16: deschedule timer routine on detach
Date: Wed, 29 Oct 2014 17:35:11 +0000
Message-Id: <1414604112-4362-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414604112-4362-1-git-send-email-abbotti@mev.co.uk>
References: <1414604112-4362-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "das16" driver optionally uses a kernel timer and a DMA channel to
support asynchronous data acquisition, but currently never calls
`del_timer_sync()`.  There is some possibility the timer routine could
still be scheduled to run when the comedi "detach" handler is run to
clean up the device and cause a certain amount of havoc.  Avoid that by
calling `del_time_sync()` in the comedi "detach" handler
`das16_detach()` if the timer was initialized by the "attach" handler
`das16_attach()`.  Use the timer's `data` member to tell whether it was
initialized or not.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/das16.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 5d47d0a..51c4a58 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1226,6 +1226,8 @@ static void das16_detach(struct comedi_device *dev)
 	int i;
 
 	if (devpriv) {
+		if (devpriv->timer.data)
+			del_timer_sync(&devpriv->timer);
 		if (dev->iobase)
 			das16_reset(dev);
 
-- 
2.1.1

