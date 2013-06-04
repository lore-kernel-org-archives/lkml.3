Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3FDFmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:42:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53612 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab3FDFmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:42:08 -0400
X-Sasl-enc: VW3ey5Dt/a7hTzQG97ioaatpjWWKXdWAC9G1uyhJpwX7 1370324524
Date: Mon, 3 Jun 2013 22:42:33 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20130604054233.GA23572@kroah.com>
References: <20130604145700.6abe693b7e4628cf62948624@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604145700.6abe693b7e4628cf62948624@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:57:00PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:44:0,
>                  from drivers/staging/lustre/lustre/fid/../include/linux/lvfs.h:48,
>                  from drivers/staging/lustre/lustre/fid/../include/lvfs.h:45,
>                  from drivers/staging/lustre/lustre/fid/../include/obd_support.h:41,
>                  from drivers/staging/lustre/lustre/fid/../include/linux/obd.h:44,
>                  from drivers/staging/lustre/lustre/fid/../include/obd.h:40,
>                  from drivers/staging/lustre/lustre/fid/fid_store.c:48:
> drivers/staging/lustre/lustre/fid/../include/linux/lustre_patchless_compat.h: In function 'truncate_complete_page':
> drivers/staging/lustre/lustre/fid/../include/linux/lustre_patchless_compat.h:56:3: error: too few arguments to function 'page->mapping->a_ops->invalidatepage'
>    page->mapping->a_ops->invalidatepage(page, 0);
>    ^
> 
> Lots of times.
> 
> Caused by the Lustre client patches interacting with commit d47992f86b30
> ("mm: change invalidatepage prototype to accept length") from the ext4
> tree.
> 
> I added this merge fix patch:
> 
> From 3873636f50eb89ba5e4f8e4e0523fd62f681edc8 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 4 Jun 2013 14:41:00 +1000
> Subject: [PATCH] staging/lustre: fix for invalidatepage() API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
> index f050808..67c4644 100644
> --- a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
> +++ b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
> @@ -53,7 +53,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
>  		return;
>  
>  	if (PagePrivate(page))
> -		page->mapping->a_ops->invalidatepage(page, 0);
> +		page->mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
>  
>  	cancel_dirty_page(page, PAGE_SIZE);
>  	ClearPageMappedToDisk(page);
> -- 
> 1.8.1
> 
> diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
> index 27e4e64..f1a1c5f 100644
> --- a/drivers/staging/lustre/lustre/llite/rw26.c
> +++ b/drivers/staging/lustre/lustre/llite/rw26.c
> @@ -72,7 +72,8 @@
>   * aligned truncate). Lustre leaves partially truncated page in the cache,
>   * relying on struct inode::i_size to limit further accesses.
>   */
> -static void ll_invalidatepage(struct page *vmpage, unsigned long offset)
> +static void ll_invalidatepage(struct page *vmpage, unsigned int offset,
> +			      unsigned int length)
>  {
>  	struct inode     *inode;
>  	struct lu_env    *env;
> @@ -89,7 +90,7 @@ static void ll_invalidatepage(struct page *vmpage, unsigned long offset)
>  	 * below because they are run with page locked and all our io is
>  	 * happening with locked page too
>  	 */
> -	if (offset == 0) {
> +	if (offset == 0 && length == PAGE_CACHE_SIZE) {
>  		env = cl_env_get(&refcheck);
>  		if (!IS_ERR(env)) {
>  			inode = vmpage->mapping->host;

That patch makes sense.

But then:

> But then got these errors:
> 
> drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c: In function 'cfs_cpt_bind':
> drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c:630:3: error: implicit declaration of function 'set_cpus_allowed' [-Werror=implicit-function-declaration]
>    rc = set_cpus_allowed(current, *cpumask);
>    ^
> cc1: some warnings being treated as errors
> drivers/staging/lustre/lustre/obdclass/lu_object.c: In function 'key_fini':
> drivers/staging/lustre/lustre/obdclass/lu_object.c:1354:4: error: implicit declaration of function 'module_refcount' [-Werror=implicit-function-declaration]
>     LINVRNT(module_refcount(key->lct_owner) > 0);
>     ^
> In file included from drivers/staging/lustre/include/linux/libcfs/libcfs.h:203:0,
>                  from drivers/staging/lustre/lustre/obdclass/lu_object.c:47:
> drivers/staging/lustre/lustre/obdclass/lu_object.c: In function 'lu_context_keys_dump':
> drivers/staging/lustre/lustre/obdclass/lu_object.c:1936:42: error: dereferencing pointer to incomplete type
>            key->lct_owner ? key->lct_owner->name : "",
>                                           ^
> drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:221:41: note: in definition of macro '__CDEBUG'
>    libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__);     \
>                                          ^
> drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:238:30: note: in expansion of macro 'CDEBUG_LIMIT'
>  #define CERROR(format, ...)  CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
>                               ^
> drivers/staging/lustre/lustre/obdclass/lu_object.c:1932:4: note: in expansion of macro 'CERROR'
>     CERROR("[%d]: %p %x (%p,%p,%p) %d %d \"%s\"@%p\n",
>     ^
> cc1: some warnings being treated as errors
> drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c: In function 'ptlrpcd':
> drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c:398:4: error: implicit declaration of function 'set_cpus_allowed' [-Werror=implicit-function-declaration]
>     cfs_set_cpus_allowed(current,
>     ^
> cc1: some warnings being treated as errors

That must be some #include files needed for ppc.

> So I gave up and just reverted commit 52f6317528c6 ("staging/lustre: drop
> CONFIG_BROKEN dependency") (thus disabling the code again) for now.

That makes sense.

Any of the lustre developers want to send me patches to fix the build
issues up please?

thanks,

greg k-h
