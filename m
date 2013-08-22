Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3HVPxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:53:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab3HVPxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:53:36 -0400
Message-ID: <1377186804.25163.17.camel@ul30vt.home>
Subject: Re: [PATCH v2 05/10] vfio: use get_unused_fd_flags(0) instead of
 get_unused_fd()
From: Alex Williamson <alex.williamson@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Thu, 22 Aug 2013 09:53:24 -0600
In-Reply-To: <613180f8dafa1143cc4f71405b0c1eba8d523000.1376327678.git.ydroneaud@opteya.com>
References: <cover.1376327678.git.ydroneaud@opteya.com>
	 <613180f8dafa1143cc4f71405b0c1eba8d523000.1376327678.git.ydroneaud@opteya.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-15 at 15:10 +0200, Yann Droneaud wrote:
> Macro get_unused_fd() is used to allocate a file descriptor with
> default flags. Those default flags (0) can be "unsafe":
> O_CLOEXEC must be used by default to not leak file descriptor
> across exec().
> 
> Instead of macro get_unused_fd(), functions anon_inode_getfd()
> or get_unused_fd_flags() should be used with flags given by userspace.
> If not possible, flags should be set to O_CLOEXEC to provide userspace
> with a default safe behavor.
> 
> In a further patch, get_unused_fd() will be removed so that
> new code start using anon_inode_getfd() or get_unused_fd_flags()
> with correct flags.
> 
> This patch replaces calls to get_unused_fd() with equivalent call to
> get_unused_fd_flags(0) to preserve current behavor for existing code.
> 
> The hard coded flag value (0) should be reviewed on a per-subsystem basis,
> and, if possible, set to O_CLOEXEC.
> 
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> Link: http://lkml.kernel.org/r/cover.1376327678.git.ydroneaud@opteya.com
> 
> ---
>  drivers/vfio/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index d3cb342..75c16cc 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1109,7 +1109,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  		 * We can't use anon_inode_getfd() because we need to modify
>  		 * the f_mode flags directly to allow more than just ioctls
>  		 */
> -		ret = get_unused_fd();
> +		ret = get_unused_fd_flags(0);
>  		if (ret < 0) {
>  			device->ops->release(device->device_data);
>  			break;

I don't see any reason why we shouldn't be adding O_CLOEXEC here.  If
anyone disagrees, please speak up.  I'll include this in my next tree
and post a follow-on patch to replace 0 with O_CLOEXEC.  Thanks,

Alex

