Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbbASHmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:42:10 -0500
Received: from ozlabs.org ([103.22.144.67]:36684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbbASHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:42:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: module: fix module_refcount() return when running in a module exit routine
In-Reply-To: <54BC93C3.7010808@hitachi.com>
References: <1421600146.2080.8.camel@HansenPartnership.com> <54BC93C3.7010808@hitachi.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 Jan 2015 16:21:15 +1030
Message-ID: <878ugzco8c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> (2015/01/19 1:55), James Bottomley wrote:
>> From: James Bottomley <JBottomley@Parallels.com>
>> 
>> After e513cc1 module: Remove stop_machine from module unloading,
>> module_refcount() is returning (unsigned long)-1 when called from within
>> a routine that runs in module_exit.  This is confusing the scsi device
>> put code which is coded to detect a module_refcount() of zero for
>> running within a module exit routine and not try to do another
>> module_put.  The fix is to restore the original behaviour of
>> module_refcount() and return zero if we're running inside an exit
>> routine.
>> 
>> Fixes: e513cc1c07e2ab93a4514eec9833e031df3e30bb
>> Reported-by: Bart Van Assche <bvanassche@acm.org>
>> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>> 
>
> Yes, this should be fixed as you said, since it must return "unsigned long" value.

But there are only three non-module callers:

drivers/scsi/scsi.c:1012:	if (module && module_refcount(module) != 0)
drivers/staging/lustre/lustre/obdclass/lu_object.c:1359:			LINVRNT(module_refcount(key->lct_owner) > 0);
include/linux/module.h:447:unsigned long module_refcount(struct module *mod);
kernel/debug/kdb/kdb_main.c:2026:		kdb_printf("%4ld ", module_refcount(mod));
kernel/module.c:775:unsigned long module_refcount(struct module *mod)
kernel/module.c:779:EXPORT_SYMBOL(module_refcount);
kernel/module.c:859:	seq_printf(m, " %lu ", module_refcount(mod));
kernel/module.c:911:	return sprintf(buffer, "%lu\n", module_refcount(mk->mod));

The first one I think should be eliminated, and the second one is simply
an assertion before calling module_put() (which should probably be
eliminated).  The others are just printing information.

Cheers,
Rusty.
