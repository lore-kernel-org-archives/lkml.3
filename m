Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaANXNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:13:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaANXNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:13:41 -0500
Date: Tue, 14 Jan 2014 15:13:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Hedi <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] hotplug, memory: move register_memory_resource out of the
 lock_memory_hotplug
Message-Id: <20140114151340.004d25c00056d88f33cadda0@linux-foundation.org>
In-Reply-To: <1389723874-32372-1-git-send-email-nzimmer@sgi.com>
References: <1389723874-32372-1-git-send-email-nzimmer@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 12:24:34 -0600 Nathan Zimmer <nzimmer@sgi.com> wrote:

> We don't need to do register_memory_resource() since it has its own lock and
> doesn't make any callbacks.
> 
> Also register_memory_resource return NULL on failure so we don't have anything
> to cleanup at this point.
> 
> 
> The reason for this rfc is I was doing some experiments with hotplugging of
> memory on some of our larger systems.  While it seems to work, it can be quite
> slow.  With some preliminary digging I found that lock_memory_hotplug is
> clearly ripe for breakup.
> 
> It could be broken up per nid or something but it also covers the
> online_page_callback.  The online_page_callback shouldn't be very hard to break
> out.
> 
> Also there is the issue of various structures(wmarks come to mind) that are
> only updated under the lock_memory_hotplug that would need to be dealt with.
>
> ...
>
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1097,17 +1097,18 @@ int __ref add_memory(int nid, u64 start, u64 size)
>  	struct resource *res;
>  	int ret;
>  
> -	lock_memory_hotplug();
> -
>  	res = register_memory_resource(start, size);
>  	ret = -EEXIST;
>  	if (!res)
> -		goto out;
> +		return ret;
>  
>  	{	/* Stupid hack to suppress address-never-null warning */
>  		void *p = NODE_DATA(nid);
>  		new_pgdat = !p;
>  	}
> +
> +	lock_memory_hotplug();
> +
>  	new_node = !node_online(nid);
>  	if (new_node) {
>  		pgdat = hotadd_new_pgdat(nid, start);

Looks sane to me.

register_memory_resource() makes me cry.  Please review:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memory_hotplug.c: register_memory_resource() fixes

- register_memory_resource() should not go BUG on ENOMEM.  That's
  appropriate at system boot time, but not at memory-hotplug time.  Fix.

- register_memory_resource()'s caller is incorrectly replacing
  request_resource()'s -EBUSY with -EEXIST.  Fix this by propagating
  errors appropriately.

Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Hedi <hedi@sgi.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-register_memory_resource-fixes mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-register_memory_resource-fixes
+++ a/mm/memory_hotplug.c
@@ -64,17 +64,21 @@ void unlock_memory_hotplug(void)
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
 	struct resource *res;
+	int err;
+
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-	BUG_ON(!res);
+	if (!res)
+		return ERR_PTR(-ENOMEM);
 
 	res->name = "System RAM";
 	res->start = start;
 	res->end = start + size - 1;
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-	if (request_resource(&iomem_resource, res) < 0) {
+	err = request_resource(&iomem_resource, res);
+	if (err) {
 		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
-		res = NULL;
+		res = ERR_PTR(err);
 	}
 	return res;
 }
@@ -1108,9 +1112,8 @@ int __ref add_memory(int nid, u64 start,
 		return ret;
 
 	res = register_memory_resource(start, size);
-	ret = -EEXIST;
-	if (!res)
-		return ret;
+	if (IS_ERR(res))
+		return PTR_ERR(res);
 
 	{	/* Stupid hack to suppress address-never-null warning */
 		void *p = NODE_DATA(nid);
_

