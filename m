Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3C0PUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:20:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42283 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3C0PUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:20:33 -0400
Date: Wed, 27 Mar 2013 15:20:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yet another pipe related oops.
Message-ID: <20130327152030.GY21522@ZenIV.linux.org.uk>
References: <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk>
 <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
 <20130327135127.GB1738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327135127.GB1738@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 09:51:27AM -0400, Dave Jones wrote:

> Could be that Al's patches refactored this bug away, or it could just be
> that I've been lucky the last few weeks, and just haven't had the right
> entropy to get the sequence of events right..
> 
> thoughts ?

Actually, that's my fault - check lost in patch reordering.  My apologies ;-/
Eventually, we want that in fs/splice.c side of things (no point repeating it
for every buffer, after all), but for now this is the obvious minimal fix.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/read_write.c b/fs/read_write.c
index f7b5a23..e6ddc8d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -424,6 +424,9 @@ ssize_t __kernel_write(struct file *file, const char *buf, size_t count, loff_t
 	const char __user *p;
 	ssize_t ret;
 
+	if (!file->f_op || (!file->f_op->write && !file->f_op->aio_write))
+		return -EINVAL;
+
 	old_fs = get_fs();
 	set_fs(get_ds());
 	p = (__force const char __user *)buf;
