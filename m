Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3DYPgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:36:48 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41920 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758811Ab3DYPgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:36:47 -0400
Date: Thu, 25 Apr 2013 10:36:46 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -v6 2/5] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130425153646.GX3658@sgi.com>
References: <1366802333-8890-1-git-send-email-holt@sgi.com>
 <1366802333-8890-3-git-send-email-holt@sgi.com>
 <20130424151749.30b0680dc9392b110537bcd5@linux-foundation.org>
 <20130425065704.GE7806@gmail.com>
 <20130425002939.208fcb91.akpm@linux-foundation.org>
 <20130425073437.GA12868@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425073437.GA12868@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 09:34:37AM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 25 Apr 2013 08:57:04 +0200 Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > > PF_THREAD_BOUND was removed/replaced in linux-next's a9ab775bc
> > > > ("workqueue: directly restore CPU affinity of workers from CPU_ONLINE")
> > > 
> > > I don't see PF_THREAD_BOUND being removed by commit a9ab775bc. Did you 
> > > mean some other commit?
> > 
> > commit 14a40ffccd6163bbcd1d6f32b28a88ffe6149fc6
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Tue Mar 19 13:45:20 2013 -0700
> > 
> >     sched: replace PF_THREAD_BOUND with PF_NO_SETAFFINITY
> 
> I don't think much action is needed: whenever someone integrates the 
> workqueue tree with these reboot changes, or the workqueue changes hit 
> upstream, a s/PF_THREAD_BOUND/PF_NO_SETAFFINITY should do the trick, 
> right?
> 
> Btw., if that's true then the workqueue tree should probably grow this 
> helper:
> 
> 	#define PF_THREAD_BOUND PF_NO_SETAFFINITY

Andrew, how about I add:
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -155,6 +155,9 @@ static int __init reboot_setup(char *str)
 }
 __setup("reboot=", reboot_setup);
 
+#ifndef PF_THREAD_BOUND
+#define PF_THREAD_BOUND PF_NO_SETAFFINITY
+#endif
 
 static void migrate_to_reboot_cpu(void)
 {

to this patch and then add another patch to the series to remove those.
That will make the stable pull more clear and accomplish the same final
outcome.

Thanks,
Robin
