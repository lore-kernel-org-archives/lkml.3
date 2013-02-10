Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3BJQq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 11:46:26 -0500
Received: from gmmr1.centrum.cz ([46.255.225.252]:35021 "EHLO gmmr1.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab3BJQqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 11:46:24 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Sun, 10 Feb 2013 17:46:19 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20130206160051.GG10254@dhcp22.suse.cz>, <20130208060304.799F362F@pobox.sk>, <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk>, <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk>, <20130208171012.GH7557@dhcp22.suse.cz>, <20130208220243.EDEE0825@pobox.sk> <20130210150310.GA9504@dhcp22.suse.cz>
In-Reply-To: <20130210150310.GA9504@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130210174619.24F20488@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>stuck in the ptrace code.


But this happens _after_ the cgroup was freezed and i tried to strace one of it's processes (to see what's happening):

Feb  8 01:29:46 server01 kernel: [ 1187.540672] grsec: From 178.40.250.111: process /usr/lib/apache2/mpm-itk/apache2(apache2:18211) attached to via ptrace by /usr/bin/strace[strace:18258] uid/euid:0/0 gid/egid:0/0, parent /usr/bin/htop[htop:2901] uid/euid:0/0 gid/egid:0/0



>> Why are all PIDs waiting on 'mem_cgroup_handle_oom' and there is no
>> OOM message in the log?
>
>I am not sure what you mean here but there are
>$ grep "Memory cgroup out of memory:" kern2.collected.log | wc -l
>16
>
>OOM killer events during the time you were gathering memcg-bug-4 data.
>
>>  Data in memcg-bug-4.tar.gz are only for 2
>> minutes but i let it run for about 15-20 minutes, no single process
>> killed by OOM.
>
>I can see
>$ grep "Memory cgroup out of memory:" kern2.after.log | wc -l
>57
>
>killed after 02:38:47 when you stopped gathering data for memcg-bug-4


I meant no single process was killed inside cgroup 1258 (data from this cgroup are in memcg-bug-4.tar.gz).

Just get data from memcg-bug-4.tar.gz which were taken from cgroup 1258. Almost all processes are in 'mem_cgroup_handle_oom' so cgroup is under OOM. I assume that this is suppose to take only few seconds while kernel finds any process and kill it (and maybe do it again until enough of memory is freed). I was gathering the data for about 2 and a half minutes and NO SINGLE process was killed (just compate list of PIDs from the first and the last directory inside memcg-bug-4.tar.gz). Even more, no single process was killed in cgroup 1258 also after i stopped gathering the data. You can also take the list od PID from memcg-bug-4.tar.gz and you will find only 18211 and 8102 (which are the two stucked processes).

So my question is: Why no process was killed inside cgroup 1258 while it was under OOM? It was under OOM for at least 2 and a half of minutes while i was gathering the data (then i let it run for additional, cca, 10 minutes and then killed processes by hand but i cannot proof this). Why kernel didn't kill any process for so long and ends the OOM?

Btw, processes in cgroup 1258 (memcg-bug-4.tar.gz) are looping in this two tasks (i pasted only first line of stack):
mem_cgroup_handle_oom+0x241/0x3b0
0xffffffffffffffff

Some of them are in 'poll_schedule_timeout' and then they start to loop as above. Is this correct behavior?

For example, do (first line of stack from process 7710 from all timestamps):
for i in */7710/stack; do head -n1 $i; done
