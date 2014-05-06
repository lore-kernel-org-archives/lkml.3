Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaEFQwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:52:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45627 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaEFQwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:52:38 -0400
Date: Tue, 6 May 2014 17:52:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140506165233.GR18016@ZenIV.linux.org.uk>
References: <20140502055127.GH18016@ZenIV.linux.org.uk>
 <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
 <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
 <20140502224022.GJ18016@ZenIV.linux.org.uk>
 <20140503042604.GM18016@ZenIV.linux.org.uk>
 <20140503182110.GN18016@ZenIV.linux.org.uk>
 <20140504062915.GQ18016@ZenIV.linux.org.uk>
 <CAJfpegvWOzd01tW5nRfWKW7EoBgPD8rudODJJm5OqxPd5Pd7uA@mail.gmail.com>
 <CA+55aFxeVn2Xfa4Dwt2+GzAL7MxV3UK-jMf-+Nvm2HE9hETS9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxeVn2Xfa4Dwt2+GzAL7MxV3UK-jMf-+Nvm2HE9hETS9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:53:19AM -0700, Linus Torvalds wrote:
> On Tue, May 6, 2014 at 3:17 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > Patches look okay to me.
> >
> > Reviewed-by: Miklos Szeredi <mszeredi@suse.cz>
> >
> >>       dentry_kill(): don't try to remove from shrink list
> >
> > Backport of this to 3.12 was tested by IBM and apparently fixes the
> > issue for them (I didn't backport the cleanup patches only the actual
> > fix)
> 
> Ok, good.
> 
> >>       don't remove from shrink list in select_collect()
> >
> > I've also asked them to test this, although I think this is even
> > harder to trigger.  But at least the non-racy codepaths need to be
> > tested.
> 
> I'll be incommunicado all next week, so I think I should merge this
> all now rather than later.
> 
> Al, mind doing a real pull request?

OK...  There's one more thing I would like to put there, if you are going to
be away for the week.  It has sat in -next for a while, and it could stay
there, except that there's a _lot_ of followups touching stuff all over the
tree and I'd obviously prefer those to go into subsystem trees.  Which
means inter-tree dependencies ;-/  Would you be OK if I included that one
into pull request?  It just turns kvfree() into inline and takes it to
mm.h, next to is_vmalloc_addr(); we have *lots* of open-coded instances of
that all over the place.  As the matter of fact, more than a half of
is_vmalloc_addr() call sites are of that sort...

commit 3c91dc1ce40f973bbceded3d8ce96bda7c4d480c
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 23 10:13:03 2014 -0400

    nick kvfree() from apparmor/lib
    
    too many open-coded instances
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bf9811e..a784964 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -370,6 +370,17 @@ static inline int is_vmalloc_or_module_addr(const void *x)
 }
 #endif
 
+static inline void kvfree(const void *x)
+{
+	/* include order mess... */
+	extern void kfree(const void *);
+	extern void vfree(const void *);
+	if (is_vmalloc_addr(x))
+		vfree(x);
+	else
+		kfree(x);
+}
+
 static inline void compound_lock(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 8fb1488..97130f8 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -66,7 +66,6 @@ extern int apparmor_initialized __initdata;
 char *aa_split_fqname(char *args, char **ns_name);
 void aa_info_message(const char *str);
 void *__aa_kvmalloc(size_t size, gfp_t flags);
-void kvfree(void *buffer);
 
 static inline void *kvmalloc(size_t size)
 {
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 6968992..c1827e0 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -104,17 +104,3 @@ void *__aa_kvmalloc(size_t size, gfp_t flags)
 	}
 	return buffer;
 }
-
-/**
- * kvfree - free an allocation do by kvmalloc
- * @buffer: buffer to free (MAYBE_NULL)
- *
- * Free a buffer allocated by kvmalloc
- */
-void kvfree(void *buffer)
-{
-	if (is_vmalloc_addr(buffer))
-		vfree(buffer);
-	else
-		kfree(buffer);
-}
