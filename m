Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030736Ab3DSOnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:43:08 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19507 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030720Ab3DSOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:43:05 -0400
Message-ID: <1366381837.3824.71.camel@misato.fc.hp.com>
Subject: Re: [Bug fix PATCH v4] Reusing a resource structure allocated by
 bootmem
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 19 Apr 2013 08:30:37 -0600
In-Reply-To: <5170FBD7.8060605@jp.fujitsu.com>
References: <516FB07C.9010603@jp.fujitsu.com>
	 <1366295000.3824.47.camel@misato.fc.hp.com>
	 <517082B9.7050708@jp.fujitsu.com> <5170FBD7.8060605@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 17:09 +0900, Yasuaki Ishimatsu wrote:
> Hi Toshi,
> 
> 2013/04/19 8:33, Yasuaki Ishimatsu wrote:
> > Hi Toshi,
> >
> > 2013/04/18 23:23, Toshi Kani wrote:
> >> On Thu, 2013-04-18 at 17:36 +0900, Yasuaki Ishimatsu wrote:
> >>> When hot removing memory presented at boot time, following messages are shown:
> >>   :
> >>> diff --git a/kernel/resource.c b/kernel/resource.c
> >>> index 4aef886..637e8d2 100644
> >>> --- a/kernel/resource.c
> >>> +++ b/kernel/resource.c
> >>> @@ -21,6 +21,7 @@
> >>>   #include <linux/seq_file.h>
> >>>   #include <linux/device.h>
> >>>   #include <linux/pfn.h>
> >>> +#include <linux/mm.h>
> >>>   #include <asm/io.h>
> >>>
> >>>
> >>> @@ -50,6 +51,16 @@ struct resource_constraint {
> >>>
> >>>   static DEFINE_RWLOCK(resource_lock);
> >>>
> >>> +/*
> >>> + * For memory hotplug, there is no way to free resource entries allocated
> >>> + * by boot mem after the system is up. So for reusing the resource entry
> >>> + * we need to remember the resource.
> >>> + */
> >>> +struct resource bootmem_resource = {
> >>> +    .sibling = NULL,
> >>> +};
> >>
> >
> 
> >> This should be a pointer of struct resource and declared as static, such
> >> as:
> >>
> >> static struct resource *bootmem_resource_free;
> >
> > O.K. I'll update it.
> 
> Oh, I missed "should be pointer of struct resource" part.
> Please teach me your detailed idea. If this is defined as pointer,
> how do we initialize this and manage bootmem resources?
> 
> I'm thinking it but have no idea.

Sure.  It's quite simple.  Since only bootmem_resource.sibling is used,
it can be replaced with a pointer, such as bootmem_resource_free.  This
avoids allocating a struct resource table as this code is supposed to
save memory.

So, first, declare the pointer below, which is initialized to NULL as
BSS (checkpatch.pl complains if you set it to NULL explicitly).

  static struct resource *bootmem_resource_free;

Then, in free_resource(), this pointer replaces bootmem_resource.sibling
as follows.

  res->sibling = bootmem_resource_free;
  bootmem_resource_free = res;

Similarly, in get_resource().

  if (bootmem_resource_free) {
      res = bootmem_resource_free;
      bootmem_resource_free = res->sibling;
  }


Thanks,
-Toshi

