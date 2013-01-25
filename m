Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3AYJnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:43:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34446 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab3AYJm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:42:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,537,1355068800"; 
   d="scan'208";a="6646216"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/3] Support SRAT for movablemem_map boot option.
Date: Fri, 25 Jan 2013 17:42:06 +0800
Message-Id: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 17:41:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 17:41:58,
	Serialize complete at 2013/01/25 17:41:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here, we do two things:
1) patch1 ~ patch2: Prevent memblock from allocating memory in memory
                    to be set as ZONE_MOVABLE.
2) patch3:          Provide movablemem_map=acpi option for users who
                    don't want to specify physical address in kernel
                    commandline. It will use SRAT info, and set all
                    the hotpluggable memory as ZONE_MOVABLE.

After applying these 3 patches, movablemem_map boot option will work like this:

        /*
         * For movablemem_map=acpi:
         *
         * SRAT:                |_____| |_____| |_________| |_________| ......
         * node id:                0       1         1           2
         * hotpluggable:           n       y         y           n
         * movablemem_map:              |_____| |_________|
         *
         *
         * For movablemem_map=nn[KMG]@ss[KMG]:
         *
         * SRAT:                |_____| |_____| |_________| |_________| ......
         * node id:                0       1         1           2
         * user specified:                |__|                 |___|
         * movablemem_map:                |___| |_________|    |______| ......
         *
         * Using movablemem_map, we can prevent memblock from allocating memory
         * on ZONE_MOVABLE at boot time.
         *
         * NOTE: In the second case, SRAT info will be ingored.
         */

NOTE: Using this boot option could cause NUMA performance down. For users who
      don't want to lose NUMA performance, just do not use it now.
      We will improve it all along.

For more info of movablemem_map, please refer to:
      https://lkml.org/lkml/2013/1/14/87


Tang Chen (3):
  acpi, memory-hotplug: Parse SRAT before memblock is ready.
  acpi, memory-hotplug: Extend movablemem_map ranges to the end of
    node.
  acpi, memory-hotplug: Support getting hotplug info from SRAT.

 Documentation/kernel-parameters.txt |   23 ++++++++--
 arch/x86/kernel/setup.c             |   13 ++++--
 arch/x86/mm/numa.c                  |    2 +-
 arch/x86/mm/srat.c                  |   81 +++++++++++++++++++++++++++++++++-
 drivers/acpi/numa.c                 |   23 ++++++----
 include/linux/acpi.h                |    1 +
 include/linux/mm.h                  |    6 +++
 mm/page_alloc.c                     |   56 +++++++++++++++++++++++-
 8 files changed, 179 insertions(+), 26 deletions(-)

