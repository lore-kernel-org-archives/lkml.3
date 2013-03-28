Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3C1MEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:04:42 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:45027 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3C1MEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:04:39 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, rodrigo.vivi@gmail.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] compat/compat-drivers/linux-next: fb skip_vt_switch
Date: Thu, 28 Mar 2013 05:04:26 -0700
Message-Id: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

I maintain the the compat-drivers project [0] which aims at backporting the
Linux kernel drivers down to older kernels, automatically [1]. Thanks to
Ozan Caglayan as a GSoC project we now backport DRM drivers.

The initial framework we had set up to help with the automatic juice was
simply quilt refresh to help with hunk offsets, later it consisted of
writing cleaner diffs, then compartamentalizing shared differences into a
compat backport module [2].

Recently I looked into Coccinelle SmPL to help push for collateral evolutions
on the Linux kernel to be written when possible with SmPL [3] given that, as
discussed with Julia, the very inverse of the grammar may allow us to backport
that collateral evolution on older kernels. I'm still experimenting with that,
but another benefit of studying INRIA's Coccinelle work is that the concept
of collateral evolutions is now formalized and as I've studied their work
I'm realizing we have different categories for collateral evolutions. From
what I've experienced through the backport work, data structure changes are
the more difficult collateral evolutions to backport. Instead of updates on
our compat module these require manual diffs... One strategy to simplify
backporting these data structure changes however was to replace the uses of
the new elements on the data structure with static inlines and requiring
the heavy changes to be implementd on a helper. That is, we actually simplfied
the backport by changing the form of the collateral evolution.

The new commit by Jesse that extended the fb_info with a skip_vt_switch
element is the simplest example of a data structure expansion. We'd backport
this by adding a static inline to compat so that new kernels muck with the
new element and for older kernels this would be a no-op. This reduces the
size of the backport and unclutters the required patch with #idefs, and
insteads leaves only a replacement of the usage of the new elements with
a static inline, this however would still be required on our end:

	-      info->skip_vt_switch = true;
	+      fb_enable_skip_vt_switch(info);

So we'd then have to just add this static inline change for each new driver...
There may be a way to get SmPL to do this for us...

However... if the static inline makes it upstream it means 0 changes are
required for *any* driver!

I've been reluctant to request a change upstream because of these side
backport benefits but due to this case's simplcity I figured I'd shoot
this out for review now.

A more elaborate example would be the netdev_attach_ops() which is not
yet upstream. This exands to this simple inline for new kernels:

static inline void netdev_attach_ops(struct net_device *dev,                    
                       const struct net_device_ops *ops)                        
{                                                                               
        dev->netdev_ops = ops;                                                  
} 

For older kernels this expands to:

void netdev_attach_ops(struct net_device *dev,                                  
                       const struct net_device_ops *ops)                        
{                                                                               
        dev->open = ops->ndo_open;                                              
        dev->init = ops->ndo_init;                                              
        dev->stop = ops->ndo_stop;                                              
        dev->hard_start_xmit = ops->ndo_start_xmit;                             
        dev->change_rx_flags = ops->ndo_change_rx_flags;                        
        dev->set_multicast_list = ops->ndo_set_multicast_list;                  
        dev->validate_addr = ops->ndo_validate_addr;                            
        dev->do_ioctl = ops->ndo_do_ioctl;                                      
        dev->set_config = ops->ndo_set_config;                                  
        dev->change_mtu = ops->ndo_change_mtu;                                  
        dev->set_mac_address = ops->ndo_set_mac_address;                        
        dev->tx_timeout = ops->ndo_tx_timeout;                                  
        if (ops->ndo_get_stats)                                                 
                dev->get_stats = ops->ndo_get_stats;                            
        dev->vlan_rx_register = ops->ndo_vlan_rx_register;                      
        dev->vlan_rx_add_vid = ops->ndo_vlan_rx_add_vid;                        
        dev->vlan_rx_kill_vid = ops->ndo_vlan_rx_kill_vid;                      
#ifdef CONFIG_NET_POLL_CONTROLLER                                               
        dev->poll_controller = ops->ndo_poll_controller;                        
#endif                                                                          
                                                                                
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))                              
        dev->select_queue = ops->ndo_select_queue;                              
#endif                                                                          
}

Even though we have the static inline in compat it still means
every driver must be changed to use it. For example:

--- a/drivers/net/usb/rndis_host.c                                              
+++ b/drivers/net/usb/rndis_host.c                                              
@@ -358,7 +358,7 @@ generic_rndis_bind(struct usbnet *dev, s                    
        dev->rx_urb_size &= ~(dev->maxpacket - 1);                              
        u.init->max_transfer_size = cpu_to_le32(dev->rx_urb_size);              
                                                                                
-       net->netdev_ops = &rndis_netdev_ops;                                    
+       netdev_attach_ops(net, &rndis_netdev_ops);                              
                                                                                
        retval = rndis_command(dev, u.header, CONTROL_BUFFER_SIZE);             
        if (unlikely(retval < 0)) {   

This is just one driver. The patch that deals with this collateral
evolution is now 290 lines. I've been working with Julia to express
these type of tranformations as SmPL grammar, seeing if its possible
to use the inverse of SmPL in the long run, and so on... but in the end,
if we add a static inline upstream for small changes like these -- we'd
end up requring zero changes for the backport of these type of collateral
evolutions.

This should mean less bugs and cleaner backport code and maintenance.

Curious if video guys would care to accept this as an example simple
test case to help with the project with this respective small
collateral evolution and test case.

What follows are patches that deal with the changes on all the projects.
I'll apply the compat and compat-driver patches now as these are required,
but if my fb patch (patch #4 in this series) is accepted it'd simpify
backporting this collateral evolution for all video drivers tremendously.

[0] https://backports.wiki.kernel.org
[1] http://www.do-not-panic.com/2012/08/automatically-backporting-linux-kernel.html
[2] https://git.kernel.org/cgit/linux/kernel/git/mcgrof/compat.git/
[3] http://www.do-not-panic.com/2012/08/optimizing-backporting-collateral.html

linux-next:

Luis R. Rodriguez (1):
  fb: add helpers to enable and test for the skip_vt_switch

 drivers/gpu/drm/i915/intel_fb.c |    2 +-
 drivers/video/fbmem.c           |    2 +-
 include/linux/fb.h              |   10 ++++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

compat:

Luis R. Rodriguez (1):                                                          
  compat: backport fb_info->skip_vt_switch using a static inline                
                                                                                
 include/linux/compat-3.10.h |   41 +++++++++++++++++++++++++++++++++++++++++   
 1 file changed, 41 insertions(+)  

compat-drivers:

Luis R. Rodriguez (2):                                                          
  compat-drivers: backport fb_info->skip_vt_switch using ifdefs                 
  compat-drivers: simplify backport fb_info->skip_vt_switch CE                  
                                                                                
 .../drm/0001-fb-info-vt_switch.patch               |   56 ++++++++++++++++++++ 
 1 file changed, 56 insertions(+)                                               
 create mode 100644 patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch

-- 
1.7.10.4

