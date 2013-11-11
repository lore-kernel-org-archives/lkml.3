Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3KKLWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:22:00 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62502 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3KKLVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:21:53 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned to maxpacketsize
In-Reply-To: <5280567C.2060004@linux.intel.com>
Organization: http://mina86.com/
References: <1384102237-19784-1-git-send-email-mpn@google.com> <1384102237-19784-2-git-send-email-mpn@google.com> <5280567C.2060004@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::Z+4xjiXFSAF8HhfK:0000000000000000000000000000000000000FX6
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::HwIfexCwUGkUO1il:000000000000000000000000000000000CIz
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::hFwt3u73VSLMbGzo:00000000000000000000000000000000000011O6
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::Dxnl2ffYeU6/clMk:0000000000000000000000000000000001NTs
Date: Mon, 11 Nov 2013 12:21:49 +0100
Message-ID: <xa1t8uwvyyia.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
to pad epout buffer to match above condition if quirk is found.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

> On 11/10/2013 08:50 AM, Michal Nazarewicz wrote:
>> @@ -787,6 +788,13 @@ static ssize_t ffs_epfile_io(struct file *file,
>>  
>>  	/* Allocate & copy */
>>  	if (!halt) {
>> +		/*
>> +		 * Controller requires buffer size to be aligned to
>> +		 * maxpacketsize of an out endpoint.
>> +		 */
>> +		data_len = read && gadget->quirk_ep_out_aligned_size ?
>> +			usb_ep_align_maxpacketsize(ep->ep, len) : len;
>> +
>>  		data = kmalloc(len, GFP_KERNEL);

On Mon, Nov 11 2013, David Cohen <david.a.cohen@linux.intel.com> wrote:
> Shouldn't this kmalloc() allocate 'data_len' bytes, instead of 'len'?

Yes, of coures.

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index e496b72..fd769a8 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -753,8 +753,9 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
-	ssize_t ret;
+	ssize_t ret, data_len;
 	char *data;
 	int halt;
 
@@ -787,7 +788,14 @@ static ssize_t ffs_epfile_io(struct file *file,
 
 	/* Allocate & copy */
 	if (!halt) {
-		data = kmalloc(len, GFP_KERNEL);
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		data_len = read && gadget->quirk_ep_out_aligned_size ?
+			usb_ep_align_maxpacketsize(ep->ep, len) : len;
+
+		data = kmalloc(data_len, GFP_KERNEL);
 		if (unlikely(!data))
 			return -ENOMEM;
 
@@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
 		req->context  = &done;
 		req->complete = ffs_epfile_io_complete;
 		req->buf      = data;
-		req->length   = len;
+		req->length   = data_len;
 
 		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
 
@@ -836,9 +844,16 @@ static ssize_t ffs_epfile_io(struct file *file,
 			ret = -EINTR;
 			usb_ep_dequeue(ep->ep, req);
 		} else {
+			/*
+			 * XXX We may end up silently droping data here.
+			 * Since data_len (i.e. req->length) may be bigger
+			 * than len (after being rounded up to maxpacketsize),
+			 * we may end up with more data then user space has
+			 * space for.
+			 */
 			ret = ep->status;
 			if (read && ret > 0 &&
-			    unlikely(copy_to_user(buf, data, ret)))
+			    unlikely(copy_to_user(buf, data, min(ret, len))))
 				ret = -EFAULT;
 		}
 	}
-- 
1.8.4.1

