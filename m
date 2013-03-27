Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3C0RUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:20:31 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:6592
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab3C0RU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:20:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKBXGL-01-9PY-02
X-M-MSG: 
Date: Wed, 27 Mar 2013 12:19:31 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <arvind.chauhan@arm.com>,
        <robin.randhawa@arm.com>, <Steve.Bannister@arm.com>,
        <Liviu.Dudau@arm.com>, <charles.garcia-tobin@arm.com>
Subject: Re: [PATCH V4 0/2] Implement per policy instance of governor
Message-ID: <20130327171931.GA17070@jshin-Toonie>
References: <cover.1364398686.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1364398686.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 09:28:56PM +0530, Viresh Kumar wrote:
> Hi Guys,
> 
> All patches are pushed here for others to apply (you can apply from mail to):
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/governor-per-policy-v4
> 
> Currently, there can't be multiple instances of single governor_type. If we have
> a multi-package system, where we have multiple instances of struct policy (per
> package), we can't have multiple instances of same governor. i.e. We can't have
> multiple instances of ondemand governor for multiple packages.
> 
> Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
> governor-name/. Which again reflects that there can be only one instance of a
> governor_type in the system.
> 
> This is a bottleneck for multicluster system, where we want different packages
> to use same governor type, but with different tunables.
> 
> This patchset is inclined towards fixing this issue. Now we will create
> governors directory in cpu/cpu*/cpufreq/<gov> for platforms which have multiple
> struct policy alive at any moment. Platform drivers requiring this feature must
> set have_governor_per_policy variable in their instance of cpufreq_driver. For
> others the interface is kept same: cpu/cpufreq/<gov>.
> 
> 
> This is V4 of this patchset. V3 is already applied by Rafael in his linux-next
> branch. Jacob Shin reported some regressions with this patchset and when I went
> into testing it with his configuration I found more issues then what he
> reported.
> 
> To test these over linux-next you need to revert following first:
> db9baec cpufreq: Get rid of "struct global_attr"
> 86bd6f0 cpufreq: governor: Implement per policy instances of governors
> 8ae67b1 cpufreq: Add per policy governor-init/exit infrastructure
> 
> I have tested this for following now and believe there are no more regressions
> with it:
> - platform with a single policy instance or single group of cpu
> - platform with multiple policies but which don't want per policy instance of
>   governor
> - platform with multiple policies and which want per policy instance of governor
> 
> I have tried with different settings and combinations of governors.
> 
> @Rafael: To simplify your life I have sorted out your branch and you can simply
> pickup the complete branch that I have pushed.
> 
> V3->V4:
> - We have two instances of all show/store routines for ondemand/conservative
>   governor. One for per-policy instance of governor and other for one governor
>   instance for all policies.
> - Dropped: db9baec cpufreq: Get rid of "struct global_attr".
> - Fixed cpufreq_governor_dbs for multiple policies using same governor instance.
> - Implemented few macro's in cpufreq_governor.h to make above stuff clean.
> - Renamed have_multiple_policies to have_governor_per_policy
> - Some more minor cleanups
> 
> Viresh Kumar (2):
>   cpufreq: Add per policy governor-init/exit infrastructure
>   cpufreq: governor: Implement per policy instances of governors
> 
>  drivers/cpufreq/cpufreq.c              |  36 ++++-
>  drivers/cpufreq/cpufreq_conservative.c | 193 ++++++++++++++----------
>  drivers/cpufreq/cpufreq_governor.c     | 212 +++++++++++++++++---------
>  drivers/cpufreq/cpufreq_governor.h     | 117 +++++++++++++--
>  drivers/cpufreq/cpufreq_ondemand.c     | 263 ++++++++++++++++++++-------------
>  include/linux/cpufreq.h                |  17 ++-
>  6 files changed, 562 insertions(+), 276 deletions(-)
> 
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> 

V4 tested good on AMD machine that the regression was reported on.

Thanks,

Tested-by: Jacob Shin <jacob.shin@amd.com>

