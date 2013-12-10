Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab3LJF4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:56:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4881 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab3LJF4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:56:50 -0500
X-IronPort-AV: E=Sophos;i="4.93,863,1378828800"; 
   d="scan'208";a="9227838"
Message-ID: <52A7637E.8080007@cn.fujitsu.com>
Date: Tue, 10 Dec 2013 13:54:54 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A4AED8.3000506@gmail.com> <20131209180705.GB8098@ghostprotocols.net> <52A60705.5030303@gmail.com> <20131209184901.GE8098@ghostprotocols.net> <52A61D43.6020007@gmail.com>
In-Reply-To: <52A61D43.6020007@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 13:56:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 13:56:32,
	Serialize complete at 2013/12/10 13:56:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> NACK. Not needed and breaks the very intent of those 2 options.
>
> David
> -- 

Okey, David, I saw your commit 207b57926 (perf kvm: Fix regression with 
guest machine creation) here. It is applied to fix a bug of SEGFAULT. I 
have to say that it changed the behavior of report and lead to current bug.

commit 207b5792696206663a38e525b9793644895bad3b
Author: David Ahern <dsahern@gmail.com>
Date:   Sun Jul 1 16:11:37 2012 -0600

     perf kvm: Fix regression with guest machine creation


diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c3e399b..56142d0 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -926,7 +926,7 @@ static struct machine *
                 else
                         pid = event->ip.pid;

-               return perf_session__find_machine(session, pid);
+               return perf_session__findnew_machine(session, pid);
         }

         return perf_session__find_host_machine(session);

In original, it uses perf_session__find_machine(), it means we deliver 
symbol to machine which has the same pid, if no machine found, deliver 
it to *default* guest. But if we use perf_session__findnew_machine() 
here, if no machine was found, new machine with pid will be built and 
added. Then the default guest which with pid == 0 will never get a 
symbol, right?

And because the new machine initialized here has no kernel map created, 
the symbol delivered to it will be marked as "unknown".

So, my patch here is to revert commit 207b57926 and fix the SEGFAULT bug 
in another way.

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8a7da6f..1770f2f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -851,6 +851,7 @@ static struct machine *
                                                struct perf_sample *sample)
  {
         const u8 cpumode = event->header.misc & 
PERF_RECORD_MISC_CPUMODE_MASK;
+       struct machine *machine;

         if (perf_guest &&
             ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
@@ -863,7 +864,11 @@ static struct machine *
                 else
                         pid = sample->pid;

-               return perf_session__findnew_machine(session, pid);
+               machine = perf_session__find_machine(session, pid);
+               if (!machine)
+                       machine = perf_session__findnew_machine(session,
+ DEFAULT_GUEST_KERNEL_ID);
+               return machine;
         }

         return &session->machines.host;

If there is a machine for this event or sample, return this machine. If 
no, return *default* guest.

About the SEGFAULT bug you mentioned, it is solved by if (!machine).

Please correct me if I am wrong, thanx !!

- Yang

> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

