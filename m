Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3H0BKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:10:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3H0BHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 48/74] staging: comedi: bug-fix NULL pointer dereference on failed attach
Date: Mon, 26 Aug 2013 18:08:46 -0700
Message-Id: <20130827010434.547436778@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 3955dfa8216f712bc204a5ad2f4e51efff252fde upstream.

Commit dcd7b8bd63cb81c5b973bf86510ca3c80bbbd162 ("staging: comedi: put
module _after_ detach" by myself) reversed a couple of calls in
`comedi_device_attach()` when recovering from an error returned by the
low-level driver's 'attach' handler.  Unfortunately, that introduced a
NULL pointer dereference bug as `dev->driver` is NULL after the call to
`comedi_device_detach()`.   We still have a pointer to the low-level
comedi driver structure in the `driv` variable, so use that instead.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -464,7 +464,7 @@ int comedi_device_attach(struct comedi_d
 		ret = comedi_device_postconfig(dev);
 	if (ret < 0) {
 		comedi_device_detach(dev);
-		module_put(dev->driver->module);
+		module_put(driv->module);
 	}
 	/* On success, the driver module count has been incremented. */
 	return ret;


