Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaDWSYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:24:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaDWSYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:24:43 -0400
Date: Wed, 23 Apr 2014 11:24:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        nacc@linux.vnet.ibm.com, Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2014-04-22-15-20 uploaded (uml 32- and 64-bit defconfigs)
Message-Id: <20140423112442.5a5c8f23d580a65575e0c5fc@linux-foundation.org>
In-Reply-To: <20140423141600.4a303d95@redhat.com>
References: <20140422222121.2FAB45A431E@corp2gmr1-2.hot.corp.google.com>
	<5357F405.20205@infradead.org>
	<20140423134131.778f0d0a@redhat.com>
	<5357FCEB.2060507@infradead.org>
	<20140423141600.4a303d95@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 14:16:00 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> On Wed, 23 Apr 2014 10:48:27 -0700
> > >>> You will need quilt to apply these patches to the latest Linus release (3.x
> > >>> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > >>> http://ozlabs.org/~akpm/mmotm/series
> > >>>
> > >>
> > >> include/linux/hugetlb.h:468:9: error: 'HPAGE_SHIFT' undeclared (first use in this function)
> > > 
> > > The patch adding HPAGE_SHIFT usage to hugetlb.h in current mmotm is this:
> > > 
> > > http://www.ozlabs.org/~akpm/mmotm/broken-out/hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch
> > > 
> > > But I can't reproduce the issue to be sure what the problem is. Are you
> > > building the kernel on 32bits? Can you provide the output of
> > > "grep -i huge .config" or send your .config in private?
> > > 
> > 
> > [adding Richard to cc:]
> > 
> > 
> > As in $subject, if I build uml x86 32-bit or 64-bit defconfig, the build fails with
> > this error.
> 
> Oh, I missed the subject info completely. Sorry about that.
> 
> So, the issue really seems to be introduced by patch:
> 
>  hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch
> 
> And the problem is that UML doesn't define HPAGE_SHIFT. The following patch
> fixes it, but I'll let Nishanth decide what to do here.

I'll try moving hugepages_supported() into the #ifdef
CONFIG_HUGETLB_PAGE section.

--- a/include/linux/hugetlb.h~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix
+++ a/include/linux/hugetlb.h
@@ -412,6 +412,16 @@ static inline spinlock_t *huge_pte_lockp
 	return &mm->page_table_lock;
 }
 
+static inline bool hugepages_supported(void)
+{
+	/*
+	 * Some platform decide whether they support huge pages at boot
+	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
+	 * there is no such support
+	 */
+	return HPAGE_SHIFT != 0;
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -460,14 +470,4 @@ static inline spinlock_t *huge_pte_lock(
 	return ptl;
 }
 
-static inline bool hugepages_supported(void)
-{
-	/*
-	 * Some platform decide whether they support huge pages at boot
-	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
-	 * there is no such support
-	 */
-	return HPAGE_SHIFT != 0;
-}
-
 #endif /* _LINUX_HUGETLB_H */
_

