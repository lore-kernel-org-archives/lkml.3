Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaF0Qc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaF0Qc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:32:26 -0400
Date: Fri, 27 Jun 2014 12:31:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com
Subject: Re: [PATCH 09/15] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140627163141.GE13337@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-10-git-send-email-vgoyal@redhat.com>
 <20140626135826.d1679d6eb5b7bd0f82dd7deb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626135826.d1679d6eb5b7bd0f82dd7deb@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 01:58:26PM -0700, Andrew Morton wrote:

[..]
> > +	while (pos < stat.size) {
> > +		bytes = kernel_read(f.file, pos, (char *)(*buf) + pos,
> > +				    stat.size - pos);
> > +		if (bytes < 0) {
> > +			vfree(*buf);
> > +			ret = bytes;
> > +			goto out;
> > +		}
> > +
> > +		if (bytes == 0)
> > +			break;
> 
> Here we can get a short read: (pos < stat.size).  Seems to me that it
> is risky to return this result to the caller as if all is well.

Hi Andrew,

That's a good point. Please find attached the patch which fixes both
the issues.

Thanks
Vivek



Subject: kexec: Return error if file bytes are less then file size 

If number of bytes read from file are not same as file size, return error.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/kexec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2014-06-27 09:55:41.826755422 -0400
+++ linux-2.6/kernel/kexec.c	2014-06-27 10:04:23.409024171 -0400
@@ -343,7 +343,7 @@ out_free_image:
 static int copy_file_from_fd(int fd, void **buf, unsigned long *buf_len)
 {
 	struct fd f = fdget(fd);
-	int ret = 0;
+	int ret;
 	struct kstat stat;
 	loff_t pos;
 	ssize_t bytes = 0;
@@ -387,6 +387,12 @@ static int copy_file_from_fd(int fd, voi
 		pos += bytes;
 	}
 
+	if (pos != stat.size) {
+		ret = -EBADF;
+		vfree(*buf);
+		goto out;
+	}
+
 	*buf_len = pos;
 out:
 	fdput(f);
