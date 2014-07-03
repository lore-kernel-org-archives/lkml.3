Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaGCRCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbaGCRCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:02:54 -0400
Date: Thu, 3 Jul 2014 19:01:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: __trace_remove_event_dirs() leaks file->filter ? (Was:
	probe_event_disable()->synchronize_sched())
Message-ID: <20140703170109.GA10208@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com> <53B4EE21.2040203@hitachi.com> <20140703162211.GB5610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703162211.GB5610@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Oleg Nesterov wrote:
>
> Hmm. Off-topic, but it seems that instance_rmdir() leaks the memory? Say,
> file->filter?

Perhaps I am totally confused, but don't we need something like the patch
below? I'll try to recheck later...

Better yet, we can probably move destroy_preds() from event_remove() to
remove_event_file_dir()... not sure, need to recheck.

Oleg.

--- x/kernel/trace/trace_events.c
+++ x/kernel/trace/trace_events.c
@@ -470,6 +470,7 @@ static void remove_event_file_dir(struct ftrace_event_file *file)
 
 	list_del(&file->list);
 	remove_subsystem(file->system);
+	destroy_file_preds(file);
 	kmem_cache_free(file_cachep, file);
 }
 

