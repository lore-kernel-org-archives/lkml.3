Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbaEITgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:36:37 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:14470
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756765AbaEITgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:36:36 -0400
Date: Fri, 9 May 2014 14:36:14 -0500
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [v6,3/5] powerpc/book3e: support kgdb for kernel space
Message-ID: <20140509193614.GA28739@home.buserror.net>
References: <1382520685-11609-4-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382520685-11609-4-git-send-email-tiejun.chen@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:b074:a81c:8d02:b651]
X-ClientProxiedBy: BN1PR08CA0037.namprd08.prod.outlook.com (10.242.217.165)
 To DM2PR03MB400.namprd03.prod.outlook.com (10.141.84.153)
X-Forefront-PRVS: 02065A9E77
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(24454002)(76482001)(77982001)(2009001)(33656001)(46406003)(4396001)(64706001)(20776003)(47776003)(31966008)(46102001)(74502001)(74662001)(42186004)(21056001)(97756001)(81342001)(19580395003)(83322001)(53416003)(19580405001)(23726002)(50466002)(69596002)(81542001)(101416001)(83506001)(86362001)(79102001)(92726001)(54356999)(80022001)(92566001)(83072002)(50986999)(76176999)(81156002)(87976001)(21314002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB400;H:home.buserror.net;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 05:31:23PM +0800, Tiejun Chen wrote:
> Currently we need to skip this for supporting KGDB.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> 
> ---
> arch/powerpc/kernel/exceptions-64e.S |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index a55cf62..0b750c6 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -597,11 +597,13 @@ kernel_dbg_exc:
>  	rfdi
>  
>  	/* Normal debug exception */
> +1:	andi.	r14,r11,MSR_PR;		/* check for userspace again */
> +#ifndef CONFIG_KGDB
>  	/* XXX We only handle coming from userspace for now since we can't
>  	 *     quite save properly an interrupted kernel state yet
>  	 */
> -1:	andi.	r14,r11,MSR_PR;		/* check for userspace again */
>  	beq	kernel_dbg_exc;		/* if from kernel mode */
> +#endif

Now that we have support for properly saving state on special level
exceptions, that should be used here.  With the above patch, what happens
if e.g. a debug exception fires during a TLB miss, and the kgdb handler
takes its own TLB miss accessing the serial port?

-Scott
