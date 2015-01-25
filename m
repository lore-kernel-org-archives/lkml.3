Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbbAYQQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:16:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbbAYQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:16:13 -0500
Date: Sun, 25 Jan 2015 21:36:59 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Message-ID: <20150125133659.GA21552@kroah.com>
References: <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
 <1421081411-5759-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421081411-5759-1-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:50:11PM +0100, Vitaly Kuznetsov wrote:
> When an SMP Hyper-V guest is running on top of 2012R2 Server and secondary
> cpus are sent offline (with echo 0 > /sys/devices/system/cpu/cpu$cpu/online)
> the system freeze is observed. This happens due to the fact that on newer
> hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are distributed
> across all cpus (see init_vp_index() function in drivers/hv/channel_mgmt.c)
> and on cpu offlining nobody reassigns them to CPU0. Prevent cpu offlining
> when vmbus is loaded until the issue is fixed host-side.
> 
> This patch also disables hibernation but it is OK as it is also broken (MCE
> error is hit on resume). Suspend still works.
> 
> Tested with WS2008R2 and WS2012R2.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
> Changes since v2:
> - repair the build when vmbus is builded as a module [Greg KH] by saving
>   current cpu_disable pointer to previous_cpu_disable and restoring it on
>   unload;
> - return -ENOSYS (same as native_cpu_disable when !CONFIG_HOTPLUG_CPU) instead
>   of -1 in hyperv_cpu_disable().
> 
> Changes since v1:
> - introduce hv_cpu_hotplug_quirk() function to not spread #ifdefs [Greg KH];
> - add pr_notice() message "hv_vmbus: CPU offlining is not supported by
>   hypervisor".
> ---
>  drivers/hv/vmbus_drv.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)

Doesn't apply to my char-misc-test branch at all :(
