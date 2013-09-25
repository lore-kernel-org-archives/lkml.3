Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3IYQCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:02:43 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34550 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3IYQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:02:42 -0400
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
From: Lin Ming <minggr@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <5242C960.7050506@hurleysoftware.com>
References: <20130913005133.GA32479@localhost>
	 <20130913010936.GA1291@localhost>	<5238767D.1080606@hurleysoftware.com>
	 <20130917232214.GA11390@localhost>	<5238F252.5070905@hurleysoftware.com>
	 <CAF1ivSbYg296oHhO0_UXwkos8Ui_1C93pUnXPzow4qLWyAa2kg@mail.gmail.com>
	 <5242C960.7050506@hurleysoftware.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 26 Sep 2013 00:02:24 +0800
Message-ID: <1380124944.27676.1.camel@monkey32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 07:30 -0400, Peter Hurley wrote:
> On 09/25/2013 05:04 AM, Lin Ming wrote:
> > On Wed, Sep 18, 2013 at 8:22 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> > [snip]
> >>
> >> Looking over vmalloc.c, the critical section footprint of the vmap_area_lock
> >> could definitely be reduced (even nearly eliminated), but that's a project
> >> for
> >> another day :)
> >
> > Hi Peter,
> >
> > I also looked over vmallo.c, but didn't find obvious way to reduce the
> > critical section footprint.
> > Could you share some hints how to do this?
> 
> vmap_area_list is an RCU list.
> get_vmalloc_info() doesn't need to take the vmap_area_lock at all.
> Look at __purge_vmap_area_lazy() for a howto.

Would you like below patch?

From: Lin Ming <minggr@gmail.com>
Date: Wed, 25 Sep 2013 23:48:19 +0800
Subject: [PATCH] mm/vmalloc.c: eliminate vmap_area_lock in get_vmalloc_info()

vmap_area_list is an RCU list.
get_vmalloc_info() doesn't need to take the vmap_area_lock at all.
Use RCU to protect list scan.

Signed-off-by: Lin Ming <minggr@gmail.com>
---
 mm/vmalloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 13a5495..4523c9c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2684,14 +2684,14 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 
 	prev_end = VMALLOC_START;
 
-	spin_lock(&vmap_area_lock);
+	rcu_read_lock();
 
 	if (list_empty(&vmap_area_list)) {
 		vmi->largest_chunk = VMALLOC_TOTAL;
 		goto out;
 	}
 
-	list_for_each_entry(va, &vmap_area_list, list) {
+	list_for_each_entry_rcu(va, &vmap_area_list, list) {
 		unsigned long addr = va->va_start;
 
 		/*
@@ -2718,7 +2718,7 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 		vmi->largest_chunk = VMALLOC_END - prev_end;
 
 out:
-	spin_unlock(&vmap_area_lock);
+	rcu_read_unlock();
 }
 #endif
 
-- 
1.7.2.5



> 
> Regards,
> Peter Hurley
> 


