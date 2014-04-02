Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaDBNIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:08:10 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39300 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaDBNII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:08:08 -0400
Message-ID: <533C0BB4.4070009@gopivotal.com>
Date: Wed, 02 Apr 2014 14:08:04 +0100
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Kernel scanning/freeing to relieve cgroup memory pressure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

I'd like yourself and other cgroups developers to be aware of the use case
below.

Regards,
Glyn

Currently, a memory cgroup can hit its oom limit when pages could, in
principle, be reclaimed by the kernel except that the kernel does not
respond directly to cgroup-local memory pressure.

A use case where this is important is running a moderately large Java
application in a memory cgroup in a PaaS environment where cost to the
user depends on the memory limit ([1]). Users need to tune the memory
limit to reduce their costs. During application initialisation large
numbers of JAR files are opened (read-only) and read while loading the
application code and its dependencies. This is reflected in a peak of
file cache usage which can push the memory cgroup memory usage
significantly higher than the value actually needed to run the application.

Possible approaches include (1) automatic response to cgroup-local
memory pressure in the kernel, and (2) a kernel API for reclaiming
memory from a cgroup which could be driven under oom notification (with
the oom killer disabled for the cgroup - it would be enabled if the
cgroup was still oom after calling the kernel to reclaim memory).

Clearly (1) is the preferred approach. The closest facility in the
kernel to (2) is to ask the kernel to free pagecache using `echo 1 >
/proc/sys/vms/drop_caches`, but that is too wide-ranging, especially in
a PaaS environment hosting multiple applications. A similar facility
could be provided for a cgroup via a cgroup pseudo-file
`memory.drop_caches`.

Other approaches include a mempressure cgroup ([2]) which would not be
suitable for PaaS applications. See [3] for Andrew Morton's response. A
related workaround ([4]) was included in the 3.6 kernel.

Related discussions:
[1] 
https://groups.google.com/a/cloudfoundry.org/d/topic/vcap-dev/6M8BDV_tq7w/discussion
[2]https://lwn.net/Articles/531077/ <https://lwn.net/Articles/531077/>
[3]https://lwn.net/Articles/531138/ <https://lwn.net/Articles/531138/>
[4]https://lkml.org/lkml/2013/6/6/462 <https://lkml.org/lkml/2013/6/6/462>&
https://github.com/torvalds/linux/commit/e62e384e 
<https://github.com/torvalds/linux/commit/e62e384e>.
