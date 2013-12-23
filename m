Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3LWRUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:20:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:11275 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab3LWRUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:20:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,538,1384329600"; 
   d="scan'208";a="454653256"
Message-ID: <52B870E5.3020708@intel.com>
Date: Mon, 23 Dec 2013 09:20:37 -0800
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net
Subject: Re: [E1000-devel] [PATCH 01/21] net: slight optimization of addr
 compare for some modules
References: <52B7C590.7070708@huawei.com>
In-Reply-To: <52B7C590.7070708@huawei.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2013 09:09 PM, Ding Tianhong wrote:
> Use the recently added and possibly more efficient
> ether_addr_equal_unaligned to instead of memcmp.
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: e1000-devel@lists.sourceforge.net
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  drivers/net/bonding/bond_3ad.c                        |  2 +-
>  drivers/net/ethernet/3com/3c509.c                     |  3 +--
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c        | 10 ++++------
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c     |  2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c      |  2 +-
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c    |  2 +-
>  drivers/net/ethernet/chelsio/cxgb3/l2t.c              |  2 +-
>  drivers/net/ethernet/cisco/enic/enic_pp.c             |  2 +-
>  drivers/net/ethernet/emulex/benet/be_main.c           |  2 +-
>  drivers/net/ethernet/intel/igbvf/netdev.c             |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c        |  3 +--
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c        |  4 ++--
>  drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |  2 +-
>  drivers/net/ethernet/micrel/ksz884x.c                 |  9 ++++-----
>  drivers/net/ethernet/neterion/vxge/vxge-main.c        |  2 +-
>  drivers/net/ethernet/packetengines/yellowfin.c        |  8 ++------
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c    |  2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c        |  4 ++--
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c        |  4 ++--
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      |  4 ++--
>  drivers/net/ethernet/renesas/sh_eth.c                 |  2 +-
>  drivers/net/ethernet/seeq/sgiseeq.c                   |  2 +-
>  drivers/net/ethernet/sun/sunvnet.c                    |  2 +-
>  drivers/net/ethernet/ti/cpsw_ale.c                    |  2 +-
>  drivers/net/fddi/skfp/fplustm.c                       |  3 ++-
>  drivers/net/plip/plip.c                               |  2 +-
>  net/caif/cfrfml.c                                     |  2 +-
>  27 files changed, 39 insertions(+), 47 deletions(-)

What is it you are trying to optimize for, size or speed?  Most of these
calls are in slow path.  Replacing the memcmp with an inline operation
may provide little to no gain in terms of speed and in many cases as you
might actually be increasing the resultant driver size.

Also I would recommend reviewing the addresses you are comparing.  It is
likely that you could use ether_addr_equal or compare_ether_addr in many
cases as I suspect a number of spots are using 16b aligned MAC addresses
for both operands.

Thanks,

Alex
