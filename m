Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaIWPAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:00:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbaIWPAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:00:04 -0400
Message-ID: <54218AEF.5090200@suse.cz>
Date: Tue, 23 Sep 2014 16:59:59 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net tree
References: <20140918103200.12b79941@canb.auug.org.au> <541A28BA.1060201@infradead.org>
In-Reply-To: <541A28BA.1060201@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-18 02:35, Randy Dunlap wrote:
> On 09/17/14 17:32, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the net tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced these warnings:
>>
>> warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>> warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>> warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>> warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>> warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>> warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>> warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>> warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
>>
> 
> I have looked into these and don't see why there is a problem.
> Any help would be appreciated.

This is a side effect of 5d6be6a5 ("scsi_netlink : Make SCSI_NETLINK
dependent on NET instead of selecting NET"). Previously, SCSI_FC_ATTRS
would select SCSI_NETLINK which would select CONFIG_NET. The above
warnings are just a tip of the iceberg, the more serious issue is that
ppc64_defconfig is lacking networking support. This is the downside of
savedefconfig, because the 'select' implications can disappear over
time. Looks like more defconfigs are affected by this:

$ grep -rL CONFIG_NET= arch/*/configs/ | xargs grep -l CONFIG_SCSI_FC_ATTRS=
arch/ia64/configs/generic_defconfig
arch/ia64/configs/gensparse_defconfig
arch/mips/configs/ip27_defconfig
arch/mips/configs/malta_defconfig
arch/mips/configs/rm200_defconfig
arch/mips/configs/malta_kvm_guest_defconfig
arch/mips/configs/gpr_defconfig
arch/mips/configs/jazz_defconfig
arch/mips/configs/mtx1_defconfig
arch/mips/configs/malta_kvm_defconfig
arch/mips/configs/loongson3_defconfig
arch/parisc/configs/c8000_defconfig
arch/powerpc/configs/pseries_defconfig
arch/powerpc/configs/pseries_le_defconfig
arch/powerpc/configs/ppc64e_defconfig
arch/powerpc/configs/ppc64_defconfig
arch/powerpc/configs/pmac32_defconfig
arch/sh/configs/sh2007_defconfig
arch/sh/configs/sdk7780_defconfig
arch/sparc/configs/sparc64_defconfig

Michal
