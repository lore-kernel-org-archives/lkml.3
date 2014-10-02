Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaJBVKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:10:16 -0400
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:25690
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752268AbaJBVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:10:12 -0400
Date: Thu, 2 Oct 2014 16:03:55 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Pavel Machek <pavel@denx.de>,
        Dinh Nguyen <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <yvanderv@opensource.altera.com>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
In-Reply-To: <3341525.7GDFQS2rGu@wuerfel>
Message-ID: <alpine.DEB.2.02.1410021552470.26097@atx-linux-37>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <542C26B6.7010302@opensource.altera.com> <20141001231646.GB1529@amd> <3341525.7GDFQS2rGu@wuerfel>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR03CA073.namprd03.prod.outlook.com (10.141.249.46) To
 BLUPR03MB311.namprd03.prod.outlook.com (10.141.48.26)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB311;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(199003)(24454002)(189002)(77096002)(33716001)(85852003)(87976001)(23726002)(102836001)(101416001)(97736003)(86152002)(92726001)(92566001)(110136001)(54356999)(76176999)(50986999)(85306004)(83506001)(86362001)(69596002)(31966008)(93886004)(42186005)(53416004)(4396001)(106356001)(64706001)(81156004)(66066001)(107046002)(50466002)(95666004)(21056001)(76482002)(105586002)(99396003)(46406003)(46102003)(47776003)(20776003)(120916001)(10300001)(80022003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB311;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2014, Arnd Bergmann wrote:

> On Thursday 02 October 2014 01:16:46 Pavel Machek wrote:
> > > > 
> > > > struct socfpga_reset_manager {
> > > >         u32     status;
> > > >         u32     ctrl;
> > > >         u32     counts;
> > > >         u32     padding1;
> > > >         u32     mpu_mod_reset;
> > > >         u32     per_mod_reset;
> > > >         u32     per2_mod_reset;
> > > >         u32     brg_mod_reset;
> > > > };
> > > > 
> > > > from u-boot. Unlike macros, structs have advantages that typos lead to
> > > > easier-to-see failure modes... (And they are easier to read/parse,
> > > > too).
> > > > 
> > > 
> > > Copying from uboot sounds good, but I already know that the CPU reset
> > > offset is different for our next SOC, Arria 10. The Arria 10 SOC should
> > > still be able to use the same MSL as Cyclone5 and Arria5, but with a few
> > > differences. One of them being, the CPU1 reset offset is at 0x20 instead
> > > of 0x10. So I think having a macro for this one register is a bit
> > > cleaner than having to define a whole new struct for Arria10.
> > 
> > I don't think "whole new struct" is a problem. At least it will be
> > plain to see what changed (which will get easily lost in ifdefs.
> > 
> > struct cyclone5_reset_manager {
> >         struct socfpga_reset_manager common;
> >         u32 brg_mod_reset;
> > }
> > 
> > struct aria10_reset_manager {
> >         struct socfpga_reset_manager common;
> >         char filler[0x10];
> >         u32 brg_mod_reset;
> > }
> > 
> > if (of_machine_is_compatible("altr,socfpga-arria10"))
> >         __raw_writel(0, (struct cyclone5_reset_manager *) rst_manager_base_addr->brg_mod_reset));
> > else
> >         __raw_writel(0, (struct aria10_reset_manager *) rst_manager_base_addr->brg_mod_reset));
> > 
> > ...does not sound that bad. (And you'll need some nice solution for
> > u-boot, anyway...)
> 
> I think it would be better to just add more fields and access a different
> field based on the SoC type than cast the structs around.
> 
> Also, never use __raw_writel unless you know exactly what you are doing.
> This should use writel, or possibly writel_relaxed.

Arnd, Pavel,

I appreciate the comments.

I will fix this to not be a __raw_writel.

> 
> Finally, don't sprinkle of_machine_is_compatible() checks all over the
> place. Make the decision once when you initially probe the machine.
> 
> 	Arnd
> 

The changes for aria10 are minor: a different DT plus two register changes.  
I'm not introducing aria10 support in this patch.  This is a 16 line patch
for fixing something in an established machine layer.  If I have to come up
with a new scheme for accessing registers, then I will need to touch other
code that this patch does not intend to change.

Alan

