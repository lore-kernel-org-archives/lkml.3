Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaJCKCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:02:19 -0400
Received: from mail-db3on0095.outbound.protection.outlook.com ([157.55.234.95]:40838
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751908AbaJCKCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:02:17 -0400
Date: Fri, 3 Oct 2014 11:00:46 +0100
From: Romeo Cane <romeo.cane.ext@coriant.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: fix sys_call_table declaration
Message-ID: <20141003100046.GB2144@rcane-VirtualBox>
References: <20141002144131.GA3855@rcane-VirtualBox>
 <1412285674.28143.35.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1412285674.28143.35.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [217.115.69.134]
X-ClientProxiedBy: AM2PR02CA0039.eurprd02.prod.outlook.com (25.160.28.177) To
 DBXPR04MB141.eurprd04.prod.outlook.com (10.242.140.11)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DBXPR04MB141;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(377424004)(199003)(24454002)(51704005)(189002)(76482002)(106356001)(107046002)(83506001)(19580395003)(19580405001)(80022003)(46102003)(50466002)(77096002)(95666004)(105586002)(85306004)(42186005)(101416001)(21056001)(4396001)(20776003)(64706001)(47776003)(97736003)(33716001)(33656002)(122386001)(31966008)(97756001)(66066001)(76176999)(50986999)(54356999)(87976001)(10300001)(120916001)(110136001)(85852003)(92566001)(23726002)(99396003)(86362001)(46406003)(92726001)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBXPR04MB141;H:rcane-VirtualBox;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: coriant.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 07:34:34AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2014-10-02 at 15:41 +0100, Romeo Cane wrote:
> > Declaring sys_call_table as a pointer causes the compiler to generate the wrong lookup code in arch_syscall_addr
> 
> Care to elaborate ?
> 
> Ben.
> 
> > Signed-off-by: Romeo Cane <romeo.cane.ext@coriant.com>
> > ---
> >  arch/powerpc/include/asm/syscall.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
> > index b54b2ad..528ba9d 100644
> > --- a/arch/powerpc/include/asm/syscall.h
> > +++ b/arch/powerpc/include/asm/syscall.h
> > @@ -17,7 +17,7 @@
> >  
> >  /* ftrace syscalls requires exporting the sys_call_table */
> >  #ifdef CONFIG_FTRACE_SYSCALLS
> > -extern const unsigned long *sys_call_table;
> > +extern const unsigned long sys_call_table[];
> >  #endif /* CONFIG_FTRACE_SYSCALLS */
> >  
> >  static inline long syscall_get_nr(struct task_struct *task,
> 
>

Hi Ben,

this is the arch_syscall_addr function from kernel/trace/trace_syscalls.c:

unsigned long __init __weak arch_syscall_addr(int nr)
{
    return (unsigned long)sys_call_table[nr];
}

on my platform (E500MC) the generated assembly code is as follows:

without the patch:
  <arch_syscall_addr>:
     lis     r9,-16384
     rlwinm  r3,r3,2,0,29
     lwz     r11,30640(r9)
     lwzx    r3,r11,r3
     blr

with the patch:
  <arch_syscall_addr>:
     lis     r9,-16384
     rlwinm  r3,r3,2,0,29
     addi    r9,r9,30640
     lwzx    r3,r9,r3
     blr


the goal of the function is to retrieve the n-th element of the table (i.e. the address of a syscall)
Without the patch, the returned value is in fact the memory content pointed by the address of the first syscall plus an offset, that is not what we want.
The consequence is that ftrace of syscalls doesn't work.

That table has always been declared as a pointer since the support for syscalls tracing has been introduced for powerpc years ago, so I'm wondering why nobody else had this problem before.
Other architectures are not affected since in their includes the table is already declared as an array.


Romeo
 
