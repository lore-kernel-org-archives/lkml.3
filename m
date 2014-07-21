Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbaGUQl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:41:27 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:57706 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbaGUQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:41:25 -0400
Message-ID: <1405960298.30151.10.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 0/11] Support Write-Through mapping on x86
From: Toshi Kani <toshi.kani@hp.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, akpm@linux-foundation.org,
        arnd@arndb.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de
Date: Mon, 21 Jul 2014 10:31:38 -0600
In-Reply-To: <1405546127.28702.85.camel@misato.fc.hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
	 <53C58A69.3070207@zytor.com> <1405459404.28702.17.camel@misato.fc.hp.com>
	 <03d059f5-b564-4530-9184-f91ca9d5c016@email.android.com>
	 <1405546127.28702.85.camel@misato.fc.hp.com>
Content-Type: multipart/mixed; boundary="=-YQymhwtvgXPJ5wMLH1xm"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YQymhwtvgXPJ5wMLH1xm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2014-07-16 at 15:28 -0600, Toshi Kani wrote:
> On Tue, 2014-07-15 at 20:40 -0400, Konrad Rzeszutek Wilk wrote:
> > On July 15, 2014 5:23:24 PM EDT, Toshi Kani <toshi.kani@hp.com> wrote:
> > >On Tue, 2014-07-15 at 13:09 -0700, H. Peter Anvin wrote:
> > >> On 07/15/2014 12:34 PM, Toshi Kani wrote:
>  :
> > >> 
> > >> I have given this piece of feedback at least three times now,
> > >possibly
> > >> to different people, and I'm getting a bit grumpy about it:
> > >> 
> > >> We already have an issue with Xen, because Xen assigned mappings
> > >> differently and it is incompatible with the use of PAT in Linux.  As
> > >a
> > >> result we get requests for hacks to work around this, which is
> > >something
> > >> I really don't want to see.  I would like to see a design involving a
> > >> "reverse PAT" table where the kernel can hold the mapping between
> > >memory
> > >> types and page table encodings (including the two different ones for
> > >> small and large pages.)
> > >
> > >Thanks for pointing this out! (And sorry for making you repeat it three
> > >time...)  I was not aware of the issue with Xen.  I will look into the
> > >email archive to see what the Xen issue is, and how it can be
> > >addressed.
> > 
> > https://lkml.org/lkml/2011/11/8/406
> 
> Thanks Konrad for the pointer!
> 
> Since [__]change_page_attr_set_clr() and __change_page_attr() have no
> knowledge about PAT and simply work with specified PTE flags, they do
> not seem to fit well with additional PAT abstraction table...
> 
> I think the root of this issue is that the kernel ignores the PAT bit.
> Since __change_page_attr() only supports 4K pages, set_memory_<type>()
> can set the PAT bit into the clear mask.
> 
> Attached is a patch with this approach (apply on top of this series -
> not tested).  The kernel still does not support the PAT bit, but it
> behaves slightly better.

Hi Peter, Konrad,

Do you have any comments / suggestions for this approach?

Thanks!
-Toshi




--=-YQymhwtvgXPJ5wMLH1xm
Content-Disposition: attachment; filename="page-ext-mask.patch"
Content-Type: text/x-patch; name="page-ext-mask.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

From: Toshi Kani <toshi.kani@hp.com>

---
 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/mm/pageattr.c               |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 81a3859..a392b09 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -130,6 +130,7 @@
 #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_NUMA)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
+#define _PAGE_CACHE_EXT_MASK	(_PAGE_CACHE_MASK | _PAGE_PAT)
 #define _PAGE_CACHE_WB		(0)
 #define _PAGE_CACHE_WC		(_PAGE_PWT)
 #define _PAGE_CACHE_WT		(_PAGE_PCD | _PAGE_PWT)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index da597d0..348f206 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1446,7 +1446,7 @@ int _set_memory_uc(unsigned long addr, int numpages)
 	 */
 	return change_page_attr_set_clr(&addr, numpages,
 					__pgprot(_PAGE_CACHE_UC_MINUS),
-					__pgprot(_PAGE_CACHE_MASK),
+					__pgprot(_PAGE_CACHE_EXT_MASK),
 					0, 0, NULL);
 }
 
@@ -1493,13 +1493,13 @@ static int _set_memory_array(unsigned long *addr, int addrinarray,
 
 	ret = change_page_attr_set_clr(addr, addrinarray,
 				       __pgprot(_PAGE_CACHE_UC_MINUS),
-				       __pgprot(_PAGE_CACHE_MASK),
+				       __pgprot(_PAGE_CACHE_EXT_MASK),
 				       0, CPA_ARRAY, NULL);
 
 	if (!ret && new_type == _PAGE_CACHE_WC)
 		ret = change_page_attr_set_clr(addr, addrinarray,
 					       __pgprot(_PAGE_CACHE_WC),
-					       __pgprot(_PAGE_CACHE_MASK),
+					       __pgprot(_PAGE_CACHE_EXT_MASK),
 					       0, CPA_ARRAY, NULL);
 	if (ret)
 		goto out_free;
@@ -1532,12 +1532,12 @@ int _set_memory_wc(unsigned long addr, int numpages)
 
 	ret = change_page_attr_set_clr(&addr, numpages,
 				       __pgprot(_PAGE_CACHE_UC_MINUS),
-				       __pgprot(_PAGE_CACHE_MASK),
+				       __pgprot(_PAGE_CACHE_EXT_MASK),
 				       0, 0, NULL);
 	if (!ret) {
 		ret = change_page_attr_set_clr(&addr_copy, numpages,
 					       __pgprot(_PAGE_CACHE_WC),
-					       __pgprot(_PAGE_CACHE_MASK),
+					       __pgprot(_PAGE_CACHE_EXT_MASK),
 					       0, 0, NULL);
 	}
 	return ret;
@@ -1578,7 +1578,7 @@ int _set_memory_wt(unsigned long addr, int numpages)
 {
 	return change_page_attr_set_clr(&addr, numpages,
 					__pgprot(_PAGE_CACHE_WT),
-					__pgprot(_PAGE_CACHE_MASK),
+					__pgprot(_PAGE_CACHE_EXT_MASK),
 					0, 0, NULL);
 }
 
@@ -1611,7 +1611,7 @@ int _set_memory_wb(unsigned long addr, int numpages)
 {
 	return change_page_attr_set_clr(&addr, numpages,
 					__pgprot(_PAGE_CACHE_WB),
-					__pgprot(_PAGE_CACHE_MASK),
+					__pgprot(_PAGE_CACHE_EXT_MASK),
 					0, 0, NULL);
 }
 
@@ -1635,7 +1635,7 @@ int set_memory_array_wb(unsigned long *addr, int addrinarray)
 
 	ret = change_page_attr_set_clr(addr, addrinarray,
 				       __pgprot(_PAGE_CACHE_WB),
-				       __pgprot(_PAGE_CACHE_MASK),
+				       __pgprot(_PAGE_CACHE_EXT_MASK),
 				       0, CPA_ARRAY, NULL);
 	if (ret)
 		return ret;
@@ -1719,7 +1719,7 @@ static int _set_pages_array(struct page **pages, int addrinarray,
 	if (!ret && new_type == _PAGE_CACHE_WC)
 		ret = change_page_attr_set_clr(NULL, addrinarray,
 					       __pgprot(_PAGE_CACHE_WC),
-					       __pgprot(_PAGE_CACHE_MASK),
+					       __pgprot(_PAGE_CACHE_EXT_MASK),
 					       0, CPA_PAGES_ARRAY, pages);
 	if (ret)
 		goto err_out;
@@ -1770,7 +1770,7 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 	int i;
 
 	retval = cpa_clear_pages_array(pages, addrinarray,
-			__pgprot(_PAGE_CACHE_MASK));
+			__pgprot(_PAGE_CACHE_EXT_MASK));
 	if (retval)
 		return retval;
 

--=-YQymhwtvgXPJ5wMLH1xm--

