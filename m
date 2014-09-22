Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaIVTWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbaIVTWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:22:36 -0400
Date: Mon, 22 Sep 2014 15:22:14 -0400
From: Rafael Aquini <aquini@redhat.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 4/6] mm: introduce common page state for ballooned
 memory
Message-ID: <20140922192213.GB9708@t510.redhat.com>
References: <20140830163834.29066.98205.stgit@zurg>
 <20140830164120.29066.8857.stgit@zurg>
 <20140912165143.86d5f83dcde4a9fd78069f79@linux-foundation.org>
 <CALYGNiM0Uh1KG8Z6pFEAn=uxZBRPfHDffXjKkKJoG-K0hCaqaA@mail.gmail.com>
 <20140912224221.9ee5888a.akpm@linux-foundation.org>
 <CALYGNiNg5yLbAvqwG3nPqWZHkqXc1-3p4yqdP2Eo2rNJbRo0rg@mail.gmail.com>
 <20140919143520.94f4a17f752398a6c7c927d8@linux-foundation.org>
 <CALYGNiOwrM+LiadZGh+jeFgXCuCA0z_1Vd_kdMxLjqnP9Fnmhw@mail.gmail.com>
 <20140919232348.1a2856c1.akpm@linux-foundation.org>
 <CALYGNiN0OEtWJVy6sTE_sOydMKbyHfRY3HQ3GjYTT-u05XHTfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiN0OEtWJVy6sTE_sOydMKbyHfRY3HQ3GjYTT-u05XHTfg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:40:34PM +0400, Konstantin Khlebnikov wrote:
> On Sat, Sep 20, 2014 at 10:23 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Sat, 20 Sep 2014 09:25:01 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> >
> >> >
> >> > So I'm going to send "fix for
> >> > mm-balloon_compaction-use-common-page-ballooning-v2" to Linus
> >> > separately, but it has no changelog at all.
> >>
> >> Probably it would be better if you drop everything except actually
> >> fixes and stresstest. This is gone too far, now balloon won't compile
> >> in the middle of patchset. Just tell me and I'll redo the rest.
> >
> > I think it's best if I drop everything:
> >
> > mm-balloon_compaction-ignore-anonymous-pages.patch
> > mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
> > mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
> > selftests-vm-transhuge-stress-stress-test-for-memory-compaction.patch
> > mm-introduce-common-page-state-for-ballooned-memory.patch
> > mm-balloon_compaction-use-common-page-ballooning.patch
> > mm-balloon_compaction-general-cleanup.patch
> > mm-balloon_compaction-use-common-page-ballooning-v2-fix-1.patch
> >
> > Please go through it and send out a new version?
> >
> >
> 
> I've found yet another bug in this code. It seems here is a nest.
> balloon_page_dequeue can race with  balloon_page_isolate:
> balloon_page_isolate can remove page from list between
> llist_for_each_entry_safe and trylock_page in balloon_page_dequeue.
> balloon_page_dequeue runs under mutex_lock(&vb->balloon_lock);
> both of them lock page using trylock_page so race is tight but it is
> not impossible.
Plausible to happen if stress testing compaction simultaneously with
freezing/unloading the balloon driver. As you noted, it's quite tight
despite not impossible. Nice catch.


> Probably it's really easier to rewrite it than to fix bugs one by one =/
I'm not against a rewrite, but I don't think that rewriting the code to get rid 
of such bugs changes the fact we still have to address them in the actual placed
code as we go on finding them. That's why I thought your inital changeset fine,
with patches for stable going first and code overhaul for next following them up.

For this race you spotted, I think a simple change like the following
might be enough (not-tested)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 6e45a50..fd3a497 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -93,6 +93,16 @@ struct page *balloon_page_dequeue(struct
balloon_dev_info *b_dev_info)
                 * to be released by the balloon driver.
                 */
                if (trylock_page(page)) {
+                       /*
+                        * Skip dequeue attempt for this page to a later round
+                        * if balloon_page_isolate() has sucessfully isolated
+                        * it just before we got the page lock here.
+                        */
+                       if (page_count(page) != 1) {
+                               unlock_page(page);
+                               continue
+                       }
+
                        spin_lock_irqsave(&b_dev_info->pages_lock, flags);
                        /*
                         * Raise the page refcount here to prevent any
                         * wrong

