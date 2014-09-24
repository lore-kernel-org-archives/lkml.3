Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaIXOcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:32:53 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48173 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIXOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:32:51 -0400
Date: Wed, 24 Sep 2014 10:32:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: lizefan@huawei.com, peterz@infradead.org, mingo@kernel.org,
        keescook@chromium.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        rientjes@google.com
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Message-ID: <20140924143247.GF16555@htj.dyndns.org>
References: <542124D3.9000007@huawei.com>
 <20140924132218.GC16555@htj.dyndns.org>
 <20140924133513.GD16555@htj.dyndns.org>
 <201409242309.HDF95877.OSVFFtQLJMOHOF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409242309.HDF95877.OSVFFtQLJMOHOF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:09:25PM +0900, Tetsuo Handa wrote:
> Tejun Heo wrote:
> > > Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
> > > fixed.
> 
> s/happend/happened/
> 
> > 
> > Reverted due to build failure.  Will wait for a refreshed version. :(
> 
> I can build with 1-3 patches using HEAD of linux.git. What failure did you see?
> 
> $ make kernel/seccomp.o kernel/sys.o security/apparmor/domain.o kernel/cpuset.o

Got the following failure report from the build bot.

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17-fixes
head:   ed91a06989e253cde811d492414adcf94f34eb03
commit: ed91a06989e253cde811d492414adcf94f34eb03 [8/8] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB
+should be atomic flags
config: x86_64-randconfig-hxb2-0924 (attached as .config)
reproduce:
  git checkout ed91a06989e253cde811d492414adcf94f34eb03
  # save the attached .config to linux build tree
  make ARCH=x86_64

All error/warnings:

   In file included from include/linux/linkage.h:4:0,
                    from include/linux/preempt.h:9,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from mm/slab.c:89:
   mm/slab.c: In function '__do_cache_alloc':
>> mm/slab.c:3229:54: error: 'PF_SPREAD_SLAB' undeclared (first use in this function)
     if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
                                                         ^
   include/linux/compiler.h:131:45: note: in definition of macro 'unlikely'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                               	^
   mm/slab.c:3229:54: note: each undeclared identifier is reported only once for each function it ap
+pears in
     if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
                                                         ^
   include/linux/compiler.h:131:45: note: in definition of macro 'unlikely'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                               	^

vim +/PF_SPREAD_SLAB +3229 mm/slab.c

8c8cc2c1 Pekka Enberg   2007-02-10  3223
8c8cc2c1 Pekka Enberg   2007-02-10  3224  static __always_inline void *
8c8cc2c1 Pekka Enberg   2007-02-10  3225  __do_cache_alloc(struct kmem_cache *cache, gfp_t flags)
8c8cc2c1 Pekka Enberg   2007-02-10  3226  {
8c8cc2c1 Pekka Enberg   2007-02-10  3227        void *objp;
8c8cc2c1 Pekka Enberg   2007-02-10  3228
f0432d15 David Rientjes 2014-04-07 @3229        if (current->mempolicy || unlikely(current->flags &
+PF_SPREAD_SLAB)) {
8c8cc2c1 Pekka Enberg   2007-02-10  3230                objp = alternate_node_alloc(cache, flags);
8c8cc2c1 Pekka Enberg   2007-02-10  3231                if (objp)
8c8cc2c1 Pekka Enberg   2007-02-10  3232                        goto out;

-- 
tejun
