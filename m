Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbbAUAbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:31:45 -0500
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:48438
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752904AbbAUAbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:31:43 -0500
Message-ID: <1421800292.4961.215.camel@freescale.com>
Subject: Re: [PATCH] powerpc/fsl_pci: Fix pci stack build bug with FRAME_WARN
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Anton Blanchard <anton@samba.org>,
        "Himangi Saraogi" <himangi774@gmail.com>,
        Aaron Sierra <asierra@xes-inc.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 20 Jan 2015 18:31:32 -0600
In-Reply-To: <20150120140349.a7a9885065c241b555b91717@freescale.com>
References: <20150120140349.a7a9885065c241b555b91717@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR11CA0013.namprd11.prod.outlook.com (25.160.91.23) To
 BN1PR0301MB0724.namprd03.prod.outlook.com (25.160.78.143)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR0301MB0724;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0724;
X-Forefront-PRVS: 04631F8F77
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(54094003)(199003)(24454002)(189002)(377424004)(51704005)(68736005)(33646002)(50986999)(47776003)(36756003)(122386002)(40100003)(62966003)(77156002)(2950100001)(103116003)(19580405001)(19580395003)(46102003)(105586002)(110136001)(50226001)(106356001)(64706001)(23676002)(86362001)(50466002)(92566002)(42186005)(76176999)(87976001)(101416001)(97736003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0724;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0724;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 00:31:40.3855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0724
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 14:03 -0600, Kim Phillips wrote:
> Fix this:
> 
>   CC      arch/powerpc/sysdev/fsl_pci.o
> arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_pcie_check_link':
> arch/powerpc/sysdev/fsl_pci.c:91:1: error: the frame size of 1360 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> when configuring FRAME_WARN, by converting the allocation from the
> stack to the heap.  We use GFP_ATOMIC since this function can be
> called with interrupts disabled.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_pci.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> index 6455c1e..635d743 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -69,11 +69,13 @@ static int fsl_pcie_check_link(struct pci_controller *hose)
>  
>  	if (hose->indirect_type & PPC_INDIRECT_TYPE_FSL_CFG_REG_LINK) {
>  		if (hose->ops->read == fsl_indirect_read_config) {
> -			struct pci_bus bus;
> -			bus.number = hose->first_busno;
> -			bus.sysdata = hose;
> -			bus.ops = hose->ops;
> -			indirect_read_config(&bus, 0, PCIE_LTSSM, 4, &val);
> +			struct pci_bus *bus;
> +			bus = kmalloc(sizeof(*bus), GFP_ATOMIC);
> +			bus->number = hose->first_busno;

Missing check for allocation failure.

Do we not have a real struct pci_bus we can use here?  Or refactor
indirect_read_config() to take hose and bus number instead?

If putting a pci_bus struct on the stack is no longer OK, then
fake_pci_bus() should be fixed as well.  I wonder if GCC is allocating
separate pci_bus structs on the stack for this one and the one that
early_read_config_dword() uses...

-Scott


