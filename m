Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946688Ab3BHP6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:58:11 -0500
Received: from gmmr1.centrum.cz ([46.255.225.252]:34120 "EHLO gmmr1.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946660Ab3BHP6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:58:08 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 08 Feb 2013 16:58:05 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20130205160934.GB22804@dhcp22.suse.cz>, <20130206021721.1AE9E3C7@pobox.sk>, <20130206140119.GD10254@dhcp22.suse.cz>, <20130206142219.GF10254@dhcp22.suse.cz>, <20130206160051.GG10254@dhcp22.suse.cz>, <20130208060304.799F362F@pobox.sk>, <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk> <20130208152402.GD7557@dhcp22.suse.cz>
In-Reply-To: <20130208152402.GD7557@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130208165805.8908B143@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Which means that the oom killer didn't try to kill any task more than
>once which is good because it tells us that the killed task manages to
>die before we trigger oom again. So this is definitely not a deadlock.
>You are just hitting OOM very often.
>$ grep "killed as a result of limit" kern2.log | sed 's@.*\] @@' | sort | uniq -c | sort -k1 -n
>      1 Task in /1091/uid killed as a result of limit of /1091
>      1 Task in /1223/uid killed as a result of limit of /1223
>      1 Task in /1229/uid killed as a result of limit of /1229
>      1 Task in /1255/uid killed as a result of limit of /1255
>      1 Task in /1424/uid killed as a result of limit of /1424
>      1 Task in /1470/uid killed as a result of limit of /1470
>      1 Task in /1567/uid killed as a result of limit of /1567
>      2 Task in /1080/uid killed as a result of limit of /1080
>      3 Task in /1381/uid killed as a result of limit of /1381
>      4 Task in /1185/uid killed as a result of limit of /1185
>      4 Task in /1289/uid killed as a result of limit of /1289
>      4 Task in /1709/uid killed as a result of limit of /1709
>      5 Task in /1279/uid killed as a result of limit of /1279
>      6 Task in /1020/uid killed as a result of limit of /1020
>      6 Task in /1527/uid killed as a result of limit of /1527
>      9 Task in /1388/uid killed as a result of limit of /1388
>     17 Task in /1281/uid killed as a result of limit of /1281
>     22 Task in /1599/uid killed as a result of limit of /1599
>     30 Task in /1155/uid killed as a result of limit of /1155
>     31 Task in /1258/uid killed as a result of limit of /1258
>     71 Task in /1293/uid killed as a result of limit of /1293
>
>So the group 1293 suffers the most. I would check how much memory the
>worklod in the group really needs because this level of OOM cannot
>possible be healthy.



I took the kernel log from yesterday from the same time frame:

$ grep "killed as a result of limit" kern2.log | sed 's@.*\] @@' | sort | uniq -c | sort -k1 -n
      1 Task in /1252/uid killed as a result of limit of /1252
      1 Task in /1709/uid killed as a result of limit of /1709
      2 Task in /1185/uid killed as a result of limit of /1185
      2 Task in /1388/uid killed as a result of limit of /1388
      2 Task in /1567/uid killed as a result of limit of /1567
      2 Task in /1650/uid killed as a result of limit of /1650
      3 Task in /1527/uid killed as a result of limit of /1527
      5 Task in /1552/uid killed as a result of limit of /1552
   1634 Task in /1258/uid killed as a result of limit of /1258

As you can see, there were much more OOM in '1258' and no such problems like this night (well, there were never such problems before :) ). As i said, cgroup 1258 were freezing every few minutes with your latest patch so there must be something wrong (it usually freezes about once per day). And it was really freezed (i checked that), the sypthoms were:
 - cannot strace any of cgroup processes
 - no new processes were started, still the same processes were 'running'
 - kernel was unable to resolve this by it's own
 - all processes togather were taking 100% CPU
 - the whole memory limit was used
(see memcg-bug-4.tar.gz for more info)
Unfortunately i forget to check if killing only few of the processes will resolve it (i always killed them all yesterday night). Don't know if is was in deadlock or not but kernel was definitely unable to resolve the problem. And there is still a mystery of two freezed processes which cannot be killed.

By the way, i KNOW that so much OOM is not healthy but the client simply don't want to buy more memory. He knows about the problem of unsufficient memory limit.

Thank you.


azur
