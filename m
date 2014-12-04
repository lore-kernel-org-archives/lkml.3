Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaLDMXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:23:19 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:34719 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753666AbaLDMXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:23:16 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44501973"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Richard Weinberger" <richard.weinberger@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        "David Howells" <dhowells@redhat.com>
Subject: RE: [PATCH v9 1/3] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCH v9 1/3] procfs: show hierarchy of pid namespace
Thread-Index: AQHQDVbo85P9O1VhQU61c81DpQtueZx/KqRQ
Date: Thu, 4 Dec 2014 12:23:11 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E737803A9@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1417431978-24723-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1417431978-24723-2-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1417431978-24723-2-git-send-email-chenhanxiao@cn.fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB4CNSA5001398



> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Chen
> Hanxiao
> Sent: Monday, December 01, 2014 7:06 PM
> To: Eric W. Biederman; Serge Hallyn; Oleg Nesterov; Richard Weinberger; Andrew
> Morton
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> Mateusz Guzik; David Howells
> Subject: [PATCH v9 1/3] procfs: show hierarchy of pid namespace
> 
> We lack of pid hierarchy information, and this will lead to:
> a) we don't know pids' relationship, who is whose child:
>    /proc/PID/ns/pid only tell us whether two pids live in different ns
> b) bring trouble to nested lxc container check/restore/migration
> c) bring trouble to pid translation between containers;
> 
> This patch will show the hierarchy of pid namespace
> by pidns_hierarchy like:
> 
> <init_PID> <parent_of_init_PID> <relative PID level>
> 
> Ex:
> [root@localhost ~]#cat /proc/pidns_hierarchy
> 18060 1 1
> 18102 18060 2
> 1534  18102 3
> 1600  18102 3
> 1550  1 1
> *Note: numbers represent the pid 1 in different ns
> 
> It shows the pid hierarchy below:
> 
>       init_pid_ns 1
>               â”‚
> â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
> ns1                      ns2
> â”‚                        â”‚
> 1550                    18060
>                           â”‚
>                           â”‚
>                          ns3
>                           â”‚
>                         18102
>                           â”‚
>                  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
>                  ns4                   ns5
>                  â”‚                    â”‚
>                 1534                  1600
> 
> Every pid printed in pidns_hierarchy
> is the init pid of that pid ns level.
> 
> Acked-by: Richard Weinberer <richard@nod.at>
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
> v9: fix codes be included if CONFIG_PID_NS=n
> v8: use max() from kernel.h
>     fix some improper comments
> v7: change stype to be consistent with current interface like
>     <init_PID> <parent_of_init_PID> <relative PID level>
>     remove EXPERT dependent in Kconfig
> v6: fix a get_pid leak and do some cleanups;
> v5: collect pid by find_ge_pid;
>     use local list inside nslist_proc_show;
>     use get_pid, remove mutex lock.
> v4: simplify pid collection and some performance optimizamtion
>     fix another race issue.
> v3: fix a race issue and memory leak issue
> v2: use a procfs text file instead of dirs under /proc
> 

Hi,

Any comments?

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
