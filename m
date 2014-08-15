Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaHOLYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:24:11 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35261 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaHOLYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:24:09 -0400
MIME-Version: 1.0
In-Reply-To: <6486222925419988442@unknownmsgid>
References: <6486222925419988442@unknownmsgid>
Date: Fri, 15 Aug 2014 04:24:07 -0700
Message-ID: <CAKbGBLizXPqs6yAsi_ew3vMyMWOYfCnEKMV-JFb5w+YAqGVUPw@mail.gmail.com>
Subject: Re: Thunderbolt driver hotplug not working correctly
From: Steven Noonan <steven@uplinklabs.net>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 4:05 PM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> Hello Steven,
>
> I think that there are two problems:
>  - The Kernel does not notice that the device is gone.
>  - The first hotplug operation, after removing a coldplugged device fails.
>
> For the first one could you check whether thie pciehp (sub)-driver is loaded?
> (dmesg | grep pciehp should show something, the config option is
> CONFIG_HOTPLUG_PCI_PCIE).
>
> I was able reproduce the second problem on my machine. Could you test whether
> this patch fixes the problem?
>

With the patch I see that PCI bridge 09:00.0 survives the hotplug
events, but the bridge at 0a:00.0 and the Ethernet controller don't
survive.

>
> ---
>  drivers/thunderbolt/path.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/thunderbolt/path.c b/drivers/thunderbolt/path.c
> index 8fcf8a7..9562cd0 100644
> --- a/drivers/thunderbolt/path.c
> +++ b/drivers/thunderbolt/path.c
> @@ -150,7 +150,26 @@ int tb_path_activate(struct tb_path *path)
>
>         /* Activate hops. */
>         for (i = path->path_length - 1; i >= 0; i--) {
> -               struct tb_regs_hop hop;
> +               struct tb_regs_hop hop = { 0 };
> +
> +               /*
> +                * We do (currently) not tear down paths setup by the firmeware.
> +                * If a firmware device is unplugged and plugged in again then
> +                * it can happen that we reuse some of the hops from the (now
> +                * defunct) firmeware path. This causes the hotplug operation to
> +                * fail (the pci device does not show up). Clearing the hop
> +                * before overwriting it fixes the problem.
> +                *
> +                * Should be removed once we discover and tear down firmeware
> +                * paths.
> +                */
> +               res = tb_port_write(path->hops[i].in_port, &hop, TB_CFG_HOPS,
> +                                   2 * path->hops[i].in_hop_index, 2);
> +               if (res) {
> +                       __tb_path_deactivate_hops(path, i);
> +                       __tb_path_deallocate_nfc(path, 0);
> +                       goto err;
> +               }
>
>                 /* dword 0 */
>                 hop.next_hop = path->hops[i].next_hop_index;
> --
> 2.0.4
>
