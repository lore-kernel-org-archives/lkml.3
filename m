Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaKEKmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:42:00 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:28234 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753335AbaKEKl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:41:58 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="42891627"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: [PATCH 0/2v6] ns, procfs: pid conversion between ns and showing pidns hierarchy
Date: Wed, 5 Nov 2014 18:41:53 +0800
Message-ID: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series will expose pid inside containers
via procfs.
Also show the hierarchy of pid namespcae.
Then we could know how pid looks inside a container
and their ns relationships.

1. helpful for nested container check/restore
>From /proc/PID/ns/pid, we could know whether two pid lived
in the same ns.
>From this patch, we could know whether two pid had relationship
between each other.

2. used for pid translation from container
Ex:
     init_pid_ns    ns1         ns2
 t1  2
 t2   `- 3          1
 t3   `- 4          3
 t4       `- 5      `- 5        1
 t5       `- 6      `- 8        3

It could solve problems like: we see a pid 3 goes wrong
in container's log, what is its pid on hosts:
a) inside container:
# readlink /proc/3/ns/pid
pid:[4026532388]

b) on host:
# cat /proc/pidns_hierarchy
14918 16263
16581
Then we could easily find /proc/16263/ns/pid->4026532388.
On host, we knew that reported pid 3 is in level 2,
   and its parental pid ns is from pid 14918.

c) on host, check child of 16263, grep it from status:
NSpid:  16268   8       3

We knew that pid 16268 is pid 3 reported by container.

v6: fix some get_pid leaks and do some cleanups
v5: collect pid by find_ge_pid;
    use local list inside nslist_proc_show;
    use get_pid, remove mutex lock.
v4: simplify pid collection and some performance optimizamtion
    fix another race issue.
v3: fix a race issue and memory leak issue in pidns_hierarchy;
    add another two fielsd: NSpgid and NSsid.
v2: use a procfs text file instead of dirs under /proc for
    showing pidns hierarchy;
    add two new fields: NStgid and NSpid
    keep fields of Tgid and Pid unchanged for back compatibility.

Chen Hanxiao (2):
  v5 procfs: show hierarchy of pid namespace
  /proc/PID/status: show all sets of pid according to ns

 fs/proc/Kconfig           |   6 ++
 fs/proc/Makefile          |   1 +
 fs/proc/array.c           |  17 ++++
 fs/proc/pidns_hierarchy.c | 227 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 251 insertions(+)
 create mode 100644 fs/proc/pidns_hierarchy.c

-- 
1.9.3

