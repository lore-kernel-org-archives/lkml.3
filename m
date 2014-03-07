Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaCGFFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:05:32 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36992 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaCGFFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:05:30 -0500
X-Greylist: delayed 1636 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 00:05:30 EST
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTsoft Software Development Center
To: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] kexec/powerpc: fix exporting memory limit
Date: Fri, 7 Mar 2014 08:38:05 +0400
User-Agent: KMail/1.9.9
Cc: kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Hari Bathini <hbathini@linux.vnet.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, yadviga@dev.rtsoft.ru,
        lugovskoy@dev.rtsoft.ru, linux-kernel@vger.kernel.org
References: <1394115854-11709-1-git-send-email-nyushchenko@dev.rtsoft.ru> <1394153258.21206.1.camel@concordia>
In-Reply-To: <1394153258.21206.1.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201403070838.07820@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2014-03-06 at 18:24 +0400, Nikita Yushchenko wrote:
> > When preparing dump-capturing kernel, kexec userspace tool needs to
> > know actual amount of memory used by the running kernel. This may
> > differ from extire available DRAM for a couple of reasons. To address
> > this issue, kdump kernel support code injects several attributes into
> > device tree that are later captured by userspace kexec tool via /proc
> > interface.
> >
> > One such attrubute is 'chosen/linux,memory_limit' that is used to pass
> > memory limit of the running kernel.
> >
> > This was initialized using kernel's 'memory_limit' variable, that is
> > set by early init code based on mem= kernel parameter and other
> > reasons.
> >
> > But there are cases when memory_limit variable does not contain proper
> > information. One such case is when !CONFIG_HIGHMEM kernel runs on
> > system with memory large enough not to fit into lowmem.
>
> Why doesn't the !CONFIG_HIGHMEM code update memory_limit to reflect
> reality.

I guess because memory_limit is used for ... well, memory limit, set by 
mem=. And for the rest memblock is used (and it *is* updated).

And code elsewhere does use memblock, see e.g. numa_enforce_memory_limit() 
in arch/powerpc/mm/numa.c

In MMU init (MMU_init() in arch/powerpc/mm/init_32.c -which is the point 
where final memory configuration is set) memblock, not memory_limit, is 
both used and updated.
