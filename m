Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbbAFOT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:19:56 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2152 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbAFOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:19:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 Jan 2015 06:18:22 -0800
Date: Tue, 6 Jan 2015 22:19:49 +0800
From: Vince Hsu <vinceh@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Lucas Stach <dev@lynxeye.de>, <swarren@wwwdotorg.org>, <gnurou@gmail.com>,
        <bskeggs@redhat.com>, <martin.peres@free.fr>,
        <seven@nimrod-online.com>, <samuel.pitoiset@gmail.com>,
        <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nouveau 06/11] platform: complete the power up/down
 sequence
Message-ID: <20150106141948.GA18598@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-7-git-send-email-vinceh@nvidia.com>
 <1419427385.2179.13.camel@lynxeye.de> <549B79B2.6010301@nvidia.com>
 <20150105152552.GH12010@ulmo.nvidia.com> <54ABAC09.4080306@nvidia.com>
 <20150106113626.GC31830@ulmo.nvidia.com> <54ABD14D.30003@nvidia.com>
 <20150106135551.GI31830@ulmo.nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20150106135551.GI31830@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02:55:52PM Jan 06, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jan 06, 2015 at 08:13:01PM +0800, Vince Hsu wrote:
> > 
> > On 01/06/2015 07:36 PM, Thierry Reding wrote:
> > >> Old Signed by an unknown key
> > >
> > >On Tue, Jan 06, 2015 at 05:34:01PM +0800, Vince Hsu wrote:
> > >>On 01/05/2015 11:25 PM, Thierry Reding wrote:
> > >>>>Old Signed by an unknown key
> > >>>On Thu, Dec 25, 2014 at 10:42:58AM +0800, Vince Hsu wrote:
> > >>>>On 12/24/2014 09:23 PM, Lucas Stach wrote:
> > >>>>>Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> > >>>>>>This patch adds some missing pieces of the rail gaing/ungating sequence that
> > >>>>>>can improve the stability in theory.
> > >>>>>>
> > >>>>>>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> > >>>>>>---
> > >>>>>>  drm/nouveau_platform.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> > >>>>>>  drm/nouveau_platform.h |  3 +++
> > >>>>>>  2 files changed, 45 insertions(+)
> > >>>>>>
> > >>>>>>diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
> > >>>>>>index 68788b17a45c..527fe2358fc9 100644
> > >>>>>>--- a/drm/nouveau_platform.c
> > >>>>>>+++ b/drm/nouveau_platform.c
> > >>>>>>@@ -25,9 +25,11 @@
> > >>>>>>  #include <linux/module.h>
> > >>>>>>  #include <linux/platform_device.h>
> > >>>>>>  #include <linux/of.h>
> > >>>>>>+#include <linux/of_platform.h>
> > >>>>>>  #include <linux/reset.h>
> > >>>>>>  #include <linux/regulator/consumer.h>
> > >>>>>>  #include <soc/tegra/fuse.h>
> > >>>>>>+#include <soc/tegra/mc.h>
> > >>>>>>  #include <soc/tegra/pmc.h>
> > >>>>>>  #include "nouveau_drm.h"
> > >>>>>>@@ -61,6 +63,9 @@ static int nouveau_platform_power_up(struct nouveau_platform_gpu *gpu)
> > >>>>>>  	reset_control_deassert(gpu->rst);
> > >>>>>>  	udelay(10);
> > >>>>>>+	tegra_mc_flush(gpu->mc, gpu->swgroup, false);
> > >>>>>>+	udelay(10);
> > >>>>>>+
> > >>>>>>  	return 0;
> > >>>>>>  err_clamp:
> > >>>>>>@@ -77,6 +82,14 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
> > >>>>>>  {
> > >>>>>>  	int err;
> > >>>>>>+	tegra_mc_flush(gpu->mc, gpu->swgroup, true);
> > >>>>>>+	udelay(10);
> > >>>>>>+
> > >>>>>>+	err = tegra_powergate_gpu_set_clamping(true);
> > >>>>>>+	if (err)
> > >>>>>>+		return err;
> > >>>>>>+	udelay(10);
> > >>>>>>+
> > >>>>>>  	reset_control_assert(gpu->rst);
> > >>>>>>  	udelay(10);
> > >>>>>>@@ -91,6 +104,31 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
> > >>>>>>  	return 0;
> > >>>>>>  }
> > >>>>>>+static int nouveau_platform_get_mc(struct device *dev,
> > >>>>>>+		struct tegra_mc **mc, unsigned int *swgroup)
> > >>>>>Uhm, no. If this is needed this has to be a Tegra MC function and not
> > >>>>>burried into nouveau code. You are using knowledge about the internal
> > >>>>>workings of the MC driver here.
> > >>>>>
> > >>>>>Also this should probably only take the Dt node pointer as argument and
> > >>>>>return a something like a tegra_mc_client struct that contains both the
> > >>>>>MC device pointer and the swgroup so you can pass that to
> > >>>>>tegra_mc_flush().
> > >>>>Good idea. I will have something as below in V2 if there is no other
> > >>>>comments for this.
> > >>>>
> > >>>>tegra_mc_client *tegra_mc_find_client(struct device_node *node)
> > >>>>{
> > >>>>     ...
> > >>>>     ret = of_parse_phandle_with_args(node, "nvidia,memory-client", ...)
> > >>>>     ...
> > >>>>}
> > >>>>
> > >>>>There were some discussion about this few weeks ago. I'm not sure whether we
> > >>>>have some conclusion/implementation though. Thierry?
> > >>>>
> > >>>>http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/308703.html
> > >>>I don't think client is a good fit here. Flushing is done per SWGROUP
> > >>>(on all clients of the SWGROUP). So I think we'll want something like:
> > >>>
> > >>>	gpu@0,57000000 {
> > >>>		...
> > >>>		nvidia,swgroup = <&mc TEGRA_SWGROUP_GPU>;
> > >>>		...
> > >>>	};
> > >>>
> > >>>In the DT and return a struct tegra_mc_swgroup along the lines of:
> > >>>
> > >>>	struct tegra_mc_client {
> > >>>		unsigned int id;
> > >>>		unsigned int swgroup;
> > >>>
> > >>>		struct list_head list;
> > >>>	};
> > >>>
> > >>>	struct tegra_mc_swgroup {
> > >>>		struct list_head clients;
> > >>>		unsigned int id;
> > >>>	};
> > >>>
> > >>>Where tegra_mc_swgroup.clients is a list of struct tegra_mc_client
> > >>>structures, each representing a memory client pertaining to the
> > >>>SWGROUP.
> > >>Based on your suggestion above, I created a struct tegra_mc_swgroup:
> > >>
> > >>struct tegra_mc_swgroup {
> > >>     unsigned int id;
> > >>     struct tegra_mc *mc;
> > >>     struct list_head head;
> > >>     struct list_head clients;
> > >>};
> > >>
> > >>And added the list head in the struct tegra_mc_soc.
> > >>
> > >>struct tegra_mc_soc {
> > >>     struct tegra_mc_client *clients;
> > >>     unsigned int num_clients;
> > >>
> > >>     struct tegra_mc_hr *hr_clients;
> > >>     unsigned int num_hr_clients;
> > >Why do you still need these?
> > This part is added in "[PATCH 2/11] memory: tegra: add mc flush support" and
> > "[PATCH 3/11] memory: tegra: add flush operation for Tegra124 memory
> > clients"
> > for the hotreset registers.
> 
> Right. Perhaps calling this structure tegra_mc_hotreset and the
> variables *_hotresets would be a good idea to clarify that they aren't
> actually per-client but per-SWGROUP.
Okay.

> 
> > >>Created one function to build the swgroup list.
> > >>
> > >>static int tegra_mc_build_swgroup(struct tegra_mc *mc)
> > >>{
> > >>     int i;
> > >>
> > >>     for (i = 0; i < mc->soc->num_clients; i++) {
> > >>         struct tegra_mc_swgroup *sg;
> > >>         bool found = false;
> > >>
> > >>         list_for_each_entry(sg, &mc->soc->swgroups, head) {
> > >>             if (sg->id == mc->soc->clients[i].swgroup) {
> > >>                 found = true;
> > >>                 break;
> > >>             }
> > >>         }
> > >Can't you use your new tegra_mc_find_swgroup() function here? That way
> > >you could turn it into something slightly more readable:
> > The tegra_mc_build_swgroup() is called during driver probe, and after that
> > the swgroup list is established and then the tegra_mc_find_swgroup() can
> > work.
> 
> But you can reuse tegra_mc_find_swgroup() instead of open-coding it to
> search the partial list. The code will be exactly the same, won't it?
That depends on how you define the tegra_mc_find_swgroup().

> 
> > >	unsigned int swgroup = mc->soc->clients[i].swgroup;
> > >	struct tegra_mc_swgroup *group;
> > >
> > >	group = tegra_mc_find_swgroup(mc, swgroup);
> > The tegra_mc_find_swgroup() is expected to be called outside the mc driver
> > and
> > can only take the device node as argument because other drivers do not have
> > the mc instance information unless they call tegra_mc_find_swgroup() or
> > tegra_mc_find_client().
> 
> You can do that by making a low-level function that works on the struct
> tegra_mc * and an unsigned int swgroup which is only used internally and
> then wrap a public function around it that deals with looking up the
> struct tegra_mc * and SWGROUP ID.
Now the tegra_mc_find_swgroup() looks like below:

struct tegra_mc_swgroup *tegra_mc_find_swgroup(struct device_node *node)           
{                                                                                  
    struct of_phandle_args args;                                                   
    struct platform_device *pdev;                                                  
    struct tegra_mc *mc;                                                           
    struct tegra_mc_swgroup *sg;                                                   
    int ret;                                                                       
                                                                                   
    ret = of_parse_phandle_with_fixed_args(node, "nvidia,swgroup",                 
                1, 0, &args);                                                      
    if (ret)                                                                       
        return ERR_PTR(ret);                                                       
                                                                                   
    pdev = of_find_device_by_node(args.np);                                        
    if (!pdev)                                                                     
        return NULL;                                                               
                                                                                   
    mc = platform_get_drvdata(pdev);                                               
    if (!mc)                                                                       
        return NULL;                                                               
                                                                                   
    list_for_each_entry(sg, &mc->soc->swgroups, head) { 
        if (sg->id == args.args[0])                                                
            return sg;                                                             
    }                                                                              
                                                                                   
    return NULL;                                                                   
}                                                                                  
EXPORT_SYMBOL(tegra_mc_find_swgroup);     

I will add a find_swgroup() as internal funcion and add the add_swgroup()
per your suggestion. And keep the tegra_mc_find_swgroup() public. Is that
okay for you?

Thanks,
Vince 

