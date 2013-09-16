Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3IPSkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:40:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab3IPSko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:40:44 -0400
Date: Mon, 16 Sep 2013 14:40:30 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, eparis@redhat.com,
        james.l.morris@oracle.com
Subject: [PATCH] conditionally reschedule while loading selinux policy.
Message-ID: <20130916184030.GA15800@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Linux Kernel <linux-kernel@vger.kernel.org>, eparis@redhat.com,
	james.l.morris@oracle.com
References: <20130916173036.GA17950@redhat.com>
 <52374350.1090403@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52374350.1090403@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a slow machine (with debugging enabled), upgrading selinux policy may take
a considerable amount of time. Long enough that the softlockup detector
gets triggered.

The backtrace looks like this..

 > BUG: soft lockup - CPU#2 stuck for 23s! [load_policy:19045]
 > Call Trace:
 >  [<ffffffff81221ddf>] symcmp+0xf/0x20
 >  [<ffffffff81221c27>] hashtab_search+0x47/0x80
 >  [<ffffffff8122e96c>] mls_convert_context+0xdc/0x1c0
 >  [<ffffffff812294e8>] convert_context+0x378/0x460
 >  [<ffffffff81229170>] ? security_context_to_sid_core+0x240/0x240
 >  [<ffffffff812221b5>] sidtab_map+0x45/0x80
 >  [<ffffffff8122bb9f>] security_load_policy+0x3ff/0x580
 >  [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 >  [<ffffffff810786dd>] ? sched_clock_local+0x1d/0x80
 >  [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 >  [<ffffffff8103096a>] ? __change_page_attr_set_clr+0x82a/0xa50
 >  [<ffffffff810786dd>] ? sched_clock_local+0x1d/0x80
 >  [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 >  [<ffffffff8103096a>] ? __change_page_attr_set_clr+0x82a/0xa50
 >  [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 >  [<ffffffff81534ddc>] ? retint_restore_args+0xe/0xe
 >  [<ffffffff8109c82d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
 >  [<ffffffff81279a2e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 >  [<ffffffff810d28a8>] ? rcu_irq_exit+0x68/0xb0
 >  [<ffffffff81534ddc>] ? retint_restore_args+0xe/0xe
 >  [<ffffffff8121e947>] sel_write_load+0xa7/0x770
 >  [<ffffffff81139633>] ? vfs_write+0x1c3/0x200
 >  [<ffffffff81210e8e>] ? security_file_permission+0x1e/0xa0
 >  [<ffffffff8113952b>] vfs_write+0xbb/0x200
 >  [<ffffffff811581c7>] ? fget_light+0x397/0x4b0
 >  [<ffffffff81139c27>] SyS_write+0x47/0xa0
 >  [<ffffffff8153bde4>] tracesys+0xdd/0xe2
 
Stephen Smalley suggested:

 > Maybe put a cond_resched() within the ebitmap_for_each_positive_bit()
 > loop in mls_convert_context()?

That seems to do the trick. Tested by downgrading and re-upgrading selinux-policy-targeted.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index 40de8d3..9ef8e51 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -500,6 +500,8 @@ int mls_convert_context(struct policydb *oldp,
 			rc = ebitmap_set_bit(&bitmap, catdatum->value - 1, 1);
 			if (rc)
 				return rc;
+
+			cond_resched();
 		}
 		ebitmap_destroy(&c->range.level[l].cat);
 		c->range.level[l].cat = bitmap;
