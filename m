Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaJKDyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 23:54:54 -0400
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:39552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993AbaJKDyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 23:54:52 -0400
Date: Sat, 11 Oct 2014 11:54:32 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Nathan Lynch <Nathan_Lynch@mentor.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Felipe Balbi <balbi@ti.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Linux USB Mailing List" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <josh@joshtriplett.org>, Rabin Vincent <rabin@rab.in>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141011035431.GK3756@peterchendt>
References: <20141008175707.GI22688@saruman> <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org> <20141009162656.GE16002@saruman>
 <20141009204101.GA25955@debian> <20141009204637.GE25729@saruman>
 <20141009210715.GH25729@saruman> <20141010135743.GB31348@saruman>
 <20141010162531.GL12379@n2100.arm.linux.org.uk> <54388B81.5020306@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54388B81.5020306@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(189002)(377454003)(479174003)(51704005)(102836001)(92726001)(46406003)(92566001)(107046002)(46102003)(95666004)(57986006)(105606002)(26826002)(97736003)(97756001)(106466001)(81156004)(80022003)(54356999)(76176999)(50986999)(15202345003)(33656002)(93886004)(104016003)(85306004)(33716001)(31966008)(110136001)(20776003)(21056001)(23726002)(120916001)(99396003)(50466002)(4396001)(76482002)(64706001)(68736004)(86362001)(87936001)(19580405001)(84676001)(85852003)(69596002)(15975445006)(83506001)(19580395003)(44976005)(6806004)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0629;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 0361212EA8
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0598;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 08:44:33PM -0500, Nathan Lynch wrote:
> On 10/10/2014 11:25 AM, Russell King - ARM Linux wrote:
> > 
> > Right, so GCC 4.8.{1,2} are totally unsuitable for kernel building (and
> > it seems that this has been known about for some time.)
> 
> Looking at http://gcc.gnu.org/PR58854 it seems that all 4.8.x for x < 3
> are affected, as well as 4.9.0.
> 
> > We can blacklist these GCC versions quite easily.  We already have GCC
> > 3.3 blacklisted, and it's trivial to add others.  I would want to include
> > some proper details about the bug, just like the other existing entries
> > we already have in asm-offsets.c, where we name the functions that the
> > compiler is known to break where appropriate.
> 
> Before blacklisting anything, it's worth considering that simple version
> checks would break existing pre-4.8.3 compilers that have been patched
> for PR58854.  It looks like Yocto and Buildroot issued releases with
> patched 4.8.2 compilers well before the (fixed) 4.8.3 release.  I think
> the most we can reasonably do without breaking some correctly-behaving
> toolchains is to emit a warning.

Yocto has PR58854 problem patch.

http://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/recipes-devtools/gcc/gcc-4.8/0048-PR58854_fix_arm_apcs_epilogue.patch?h=daisy

> 
> Hopefully nobody's still using gcc 4.8 from the Linaro 2013.11 toolchain
> release -- since it's a 4.8.3 prerelease from before the fix was
> committed you'll get GCC_VERSION == 40803 but still generate bad code.
> 
> > However, I'm rather annoyed that there are people here who have known
> > for some time that GCC 4.8.1 and GCC 4.8.2 _can_ lead to filesystem
> > corruption, and have sat on their backsides doing nothing about getting
> > it blacklisted for something like a year.
> 
> Mea culpa, although I hadn't drawn the connection to FS corruption
> reports until now.  I have known about the issue for some time, but
> figured the prevalence of the fix in downstream projects largely
> mitigated the issue.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Best Regards,
Peter Chen
