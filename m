Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3BAASz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 19:18:55 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54796 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3BAASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 19:18:52 -0500
Date: Thu, 31 Jan 2013 16:18:41 -0800
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 10/14] dlm: don't use idr_remove_all()
Message-ID: <20130201001841.GP6824@mtj.dyndns.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
 <20130131235320.GN6824@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131235320.GN6824@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Thu, Jan 31, 2013 at 03:53:20PM -0800, Tejun Heo wrote:
> The function description is misleading.  The function does search
> inclusive range and needs explicit cursor increment to make progress.
> Weird that it doesn't work.  Looking into it.  I'll write when I know
> more.

It looks a bit weird to me that ls->ls_recover_list_count is also
incremented by recover_list_add().  The two code paths don't seem to
be interlocke at least upon my very shallow glance.  Is it that only
either the list or idr is in use?

Anyways, can you please apply the following patch and see which IDs
are leaking from the iteration?  The patch too is only compile tested
so I might have done something stupid but it hopefully shouldn't be
too difficult to make it work.

Thanks!
---
 fs/dlm/recover.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -351,6 +351,12 @@ static struct dlm_rsb *recover_idr_find(
 	return r;
 }
 
+static int dlm_dump_idr(int id, void *p, void *data)
+{
+	pr_cont(" %d", id);
+	return 0;
+}
+
 static void recover_idr_clear(struct dlm_ls *ls)
 {
 	struct dlm_rsb *r;
@@ -358,7 +364,9 @@ static void recover_idr_clear(struct dlm
 
 	spin_lock(&ls->ls_recover_idr_lock);
 
+	pr_info("XXX clearing:");
 	idr_for_each_entry(&ls->ls_recover_idr, r, id) {
+		pr_cont(" %d", id);
 		idr_remove(&ls->ls_recover_idr, id);
 		r->res_id = 0;
 		r->res_recover_locks_count = 0;
@@ -366,10 +374,14 @@ static void recover_idr_clear(struct dlm
 
 		dlm_put_rsb(r);
 	}
+	pr_cont("\n");
 
 	if (ls->ls_recover_list_count != 0) {
 		log_error(ls, "warning: recover_list_count %d",
 			  ls->ls_recover_list_count);
+		pr_info("XXX leftovers: ");
+		idr_for_each(&ls->ls_recover_idr, dlm_dump_idr, NULL);
+		pr_cont("\n");
 		ls->ls_recover_list_count = 0;
 	}
 	spin_unlock(&ls->ls_recover_idr_lock);
