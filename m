Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaLPQgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:36:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48249 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLPQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:36:39 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <54905F87.2030302@jp.fujitsu.com>
Date: Wed, 17 Dec 2014 01:36:23 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: =?ISO-2022-JP?B?IklzaGltYXRzdSwgWWFzdWFraS8bJEJAUD4+GyhCIBskQkx3Pk8bKEI=?=
	 =?ISO-2022-JP?B?Ig==?= <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 0/2] workqueue: fix a bug when numa mapping is changed v4
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v4. Thank you for hints/commentes to previous versions.

I think this versions only contains necessary things and not invasive.
Tested several patterns of node hotplug and seems to work well.

Changes since v3
 - removed changes against get_unbound_pool()
 - remvoed codes in cpu offline event.
 - added node unregister callback.
   clear wq_numa_possible_mask at node offline rather than cpu offline.
 - updates per-cpu pool's pool-> node at node_(un)register.
 - added more comments.
 - almost all codes are under CONFIG_MEMORY_HOTPLUG

 include/linux/memory_hotplug.h |    3 +
 kernel/workqueue.c             |   81 ++++++++++++++++++++++++++++++++++++++++-
 mm/memory_hotplug.c            |    6 ++-
 3 files changed, 88 insertions(+), 2 deletions(-)

Original problem was a memory allocation failure because pool->node
points to not-online node. This happens when cpu<->node mapping changes.

Yasuaki Ishimatsu hit a allocation failure bug when the numa mapping
between CPU and node is changed. This was the last scene:
 SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
  cache: kmalloc-192, object size: 192, buffer size: 192, default order: 1, min order: 0
  node 0: slabs: 6172, objs: 259224, free: 245741
  node 1: slabs: 3261, objs: 136962, free: 127656


