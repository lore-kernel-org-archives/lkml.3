Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbbA2Bzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:55:49 -0500
Received: from mx2.parallels.com ([199.115.105.18]:34936 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbbA2Bzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:46 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm v2 0/3] slub: make dead caches discard free slabs immediately
Date: Wed, 28 Jan 2015 19:22:48 +0300
Message-ID: <cover.1422461573.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kmem extension of the memory cgroup is almost usable now. There is,
in fact, the only serious issue left: per memcg kmem caches may pin the
owner cgroup for indefinitely long. This is, because a slab cache may
keep empty slab pages in its private structures to optimize performance,
while we take a css reference per each charged kmem page.

The issue is only relevant to SLUB, because SLAB periodically reaps
empty slabs. This patch set fixes this issue for SLUB. For details,
please see patch 3.

Changes in v2:
 - address Christoph's concerns regarding kmem_cache_shrink
 - fix race between put_cpu_partial reading ->cpu_partial and
   kmem_cache_shrink updating it as proposed by Joonsoo

v1: https://lkml.org/lkml/2015/1/26/317

Thanks,

Vladimir Davydov (3):
  slub: never fail to shrink cache
  slub: fix kmem_cache_shrink return value
  slub: make dead caches discard free slabs immediately

 mm/slab.c        |    4 +--
 mm/slab.h        |    2 +-
 mm/slab_common.c |   15 +++++++--
 mm/slob.c        |    2 +-
 mm/slub.c        |   94 +++++++++++++++++++++++++++++++++++-------------------
 5 files changed, 78 insertions(+), 39 deletions(-)

-- 
1.7.10.4

