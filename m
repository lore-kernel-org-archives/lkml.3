Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbaJUN7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:59:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685AbaJUN7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:59:34 -0400
Message-ID: <544658CE.8050704@redhat.com>
Date: Tue, 21 Oct 2014 14:59:58 +0200
From: =?UTF-8?B?TWF0ZWogTXXFvmlsYQ==?= <mmuzila@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: kys@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tools: hv: fcopy_daemon: Check buffer limits
References: <5446482C.1000003@redhat.com> <20141021131357.3677c4a5@alan.etchedpixels.co.uk>
In-Reply-To: <20141021131357.3677c4a5@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sizeof(__u8) is by definition 1 so it's perhaps surplus ?
Now the size is now determined from the structure definition in
include/uapi/linux/hyperv.h

> - C style comments for coding style
Fixed

> Also your patch block is devoid of a few thins like the file name...
I'm sorry, the (missing) filename mistake occured in copy-paste process.


Here is the patch as it (I hope) should look like:
---
From: Matej Mužila <mmuzila@redhat.com>

Check if cpmsg->size is in limits of DATA_FRAGMENT

Signed-off-by: Matej Mužila <mmuzila@redhat.com>
---
If corrupted data are read from /dev/vmbus/hv_fcopy, pwrite can
read from memory outside of the buffer (defined at line 138).
Added check. 
---
diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index 6f27e2f..1fc2dc2 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -104,6 +104,10 @@ static int hv_copy_data(struct hv_do_fcopy *cpmsg)
 {
 	ssize_t bytes_written;
 
+	/* Check if the cpmsg->size is in limits of DATA_FRAGMENT */
+	if (cpmsg->size > sizeof(cpmsg->data)) 
+		return HV_E_FAIL;
+
 	bytes_written = pwrite(target_fd, cpmsg->data, cpmsg->size,
 				cpmsg->offset);

