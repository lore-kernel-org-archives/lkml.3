Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaHGL63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:58:29 -0400
Received: from ozlabs.org ([103.22.144.67]:52245 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbaHGL61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:58:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the modules tree
In-Reply-To: <20140807132017.2ec9e2ad@canb.auug.org.au>
References: <20140807132017.2ec9e2ad@canb.auug.org.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 07 Aug 2014 21:07:20 +0930
Message-ID: <87tx5ocyz3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> After merging the modules tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> arch/powerpc/platforms/powernv/opal-elog.c:85:28: error: macro "__ATTR_RO" passed 2 arguments, but takes just 1
>   __ATTR_RO(id, elog_id_show);

Ah, crap.  I really hate that macro magic :(

I amended to the minimal fix, so we can pretend that never happened.

Cheers,
Rusty.

commit 6656c21ca10e54a84673d0ec2f0cf5f676e66a40
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 6 10:15:36 2014 +0930

    arch/powerpc/platforms/powernv/opal-elog.c: fix world-writable sysfs files
    
    If you don't have a store function, you're not writable anyway!
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Stewart Smith <stewart@linux.vnet.ibm.com>

diff --git a/arch/powerpc/platforms/powernv/opal-elog.c b/arch/powerpc/platforms/powernv/opal-elog.c
index 10268c41d830..925bad993e30 100644
--- a/arch/powerpc/platforms/powernv/opal-elog.c
+++ b/arch/powerpc/platforms/powernv/opal-elog.c
@@ -82,9 +82,9 @@ static ssize_t elog_ack_store(struct elog_obj *elog_obj,
 }
 
 static struct elog_attribute id_attribute =
-	__ATTR(id, 0666, elog_id_show, NULL);
+	__ATTR(id, S_IRUGO, elog_id_show, NULL);
 static struct elog_attribute type_attribute =
-	__ATTR(type, 0666, elog_type_show, NULL);
+	__ATTR(type, S_IRUGO, elog_type_show, NULL);
 static struct elog_attribute ack_attribute =
 	__ATTR(acknowledge, 0660, elog_ack_show, elog_ack_store);
 
