Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaDOIiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:38:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42341 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaDOIiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:38:13 -0400
Message-ID: <534CEFF2.7090207@gopivotal.com>
Date: Tue, 15 Apr 2014 09:38:10 +0100
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: Kernel scanning/freeing to relieve cgroup memory pressure
References: <533C0BB4.4070009@gopivotal.com> <20140402180019.GL16631@htj.dyndns.org> <534B982D.8060106@gopivotal.com> <20140414205034.GA6443@cmpxchg.org>
In-Reply-To: <20140414205034.GA6443@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2014 21:50, Johannes Weiner wrote:
> On Mon, Apr 14, 2014 at 09:11:25AM +0100, Glyn Normington wrote:
>> Johannes/Michal
>>
>> What are your thoughts on this matter? Do you see this as a valid
>> requirement?
> As Tejun said, memory cgroups *do* respond to internal pressure and
> enter targetted reclaim before invoking the OOM killer.  So I'm not
> exactly sure what you are asking.
We are repeatedly seeing a situation where a memory cgroup with a given 
memory limit results in an application process in the cgroup being 
killed oom during application initialisation. One theory is that dirty 
file cache pages are not being written to disk to reduce memory 
consumption before the oom killer is invoked. Should memory cgroups' 
response to internal pressure include writing dirty file cache pages to 
disk?
>
>> On 02/04/2014 19:00, Tejun Heo wrote:
>>> (cc'ing memcg maintainers and cgroup ML)
>>>
>>> On Wed, Apr 02, 2014 at 02:08:04PM +0100, Glyn Normington wrote:
>>>> Currently, a memory cgroup can hit its oom limit when pages could, in
>>>> principle, be reclaimed by the kernel except that the kernel does not
>>>> respond directly to cgroup-local memory pressure.
>>> So, ummm, it does.
>>>
>>>> A use case where this is important is running a moderately large Java
>>>> application in a memory cgroup in a PaaS environment where cost to the
>>>> user depends on the memory limit ([1]). Users need to tune the memory
>>>> limit to reduce their costs. During application initialisation large
>>>> numbers of JAR files are opened (read-only) and read while loading the
>>>> application code and its dependencies. This is reflected in a peak of
>>>> file cache usage which can push the memory cgroup memory usage
>>>> significantly higher than the value actually needed to run the application.
>>>>
>>>> Possible approaches include (1) automatic response to cgroup-local
>>>> memory pressure in the kernel, and (2) a kernel API for reclaiming
>>>> memory from a cgroup which could be driven under oom notification (with
>>>> the oom killer disabled for the cgroup - it would be enabled if the
>>>> cgroup was still oom after calling the kernel to reclaim memory).
>>>>
>>>> Clearly (1) is the preferred approach. The closest facility in the
>>>> kernel to (2) is to ask the kernel to free pagecache using `echo 1 >
>>>> /proc/sys/vms/drop_caches`, but that is too wide-ranging, especially in
>>>> a PaaS environment hosting multiple applications. A similar facility
>>>> could be provided for a cgroup via a cgroup pseudo-file
>>>> `memory.drop_caches`.
>>>>
>>>> Other approaches include a mempressure cgroup ([2]) which would not be
>>>> suitable for PaaS applications. See [3] for Andrew Morton's response. A
>>>> related workaround ([4]) was included in the 3.6 kernel.
>>>>
>>>> Related discussions:
>>>> [1] https://groups.google.com/a/cloudfoundry.org/d/topic/vcap-dev/6M8BDV_tq7w/discussion
>>>> [2]https://lwn.net/Articles/531077/ <https://lwn.net/Articles/531077/>
>>>> [3]https://lwn.net/Articles/531138/ <https://lwn.net/Articles/531138/>
>>>> [4]https://lkml.org/lkml/2013/6/6/462 <https://lkml.org/lkml/2013/6/6/462>&
>>>> https://github.com/torvalds/linux/commit/e62e384e
>>>> <https://github.com/torvalds/linux/commit/e62e384e>.

