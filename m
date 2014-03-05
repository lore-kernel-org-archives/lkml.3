Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaCEJ5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:57:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23542 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaCEJ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:57:18 -0500
Date: Wed, 5 Mar 2014 12:56:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        shuah.kh@samsung.com, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Subject: Re: [PATCH 01/12] staging: usbip: userspace: migrate usbip_bind to
 libudev
Message-ID: <20140305095619.GY26722@mwanda>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-2-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393960252-21247-2-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:10:41PM +0200, Valentina Manea wrote:

> +int write_sysfs_attribute(const char *attr_path, const char *new_value,
> +			  size_t len)
> +{
> +	int fd;
> +	int length;
> +
> +	if (attr_path == NULL || new_value == NULL || len == 0) {

Can any of these conditions be true?


> +		dbg("Invalid values provided for attribute %s.", attr_path);
> +		errno = EINVAL;
> +		return -1;
> +	}
> +
> +	if ((fd = open(attr_path, O_WRONLY)) < 0) {

Move the assignment out of the condition.

> +		dbg("Error opening attribute %s.", attr_path);
> +		return -1;
> +	}
> +
> +	length = write(fd, new_value, len);
> +	if (length < 0) {
> +		dbg("Error writing to attribute %s.", attr_path);
> +		close(fd);
> +		return -1;
> +	}
> +
> +	close(fd);
> +
> +	return 0;
> +}
> diff --git a/drivers/staging/usbip/userspace/src/sysfs_utils.h b/drivers/staging/usbip/userspace/src/sysfs_utils.h
> new file mode 100644
> index 0000000..32ac1d1
> --- /dev/null
> +++ b/drivers/staging/usbip/userspace/src/sysfs_utils.h
> @@ -0,0 +1,8 @@
> +
> +#ifndef __SYSFS_UTILS_H
> +#define __SYSFS_UTILS_H
> +
> +int write_sysfs_attribute(const char *attr_path, const char *new_value,
> +			  size_t len);
> +
> +#endif
> diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
> index 8cfd2db..d122089 100644
> --- a/drivers/staging/usbip/userspace/src/usbip_bind.c
> +++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
> @@ -16,7 +16,7 @@
>   * along with this program. If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> -#include <sysfs/libsysfs.h>
> +#include <libudev.h>
>  
>  #include <errno.h>
>  #include <stdio.h>
> @@ -28,6 +28,7 @@
>  #include "usbip_common.h"
>  #include "utils.h"
>  #include "usbip.h"
> +#include "sysfs_utils.h"
>  
>  enum unbind_status {
>  	UNBIND_ST_OK,
> @@ -48,135 +49,94 @@ void usbip_bind_usage(void)
>  /* call at unbound state */
>  static int bind_usbip(char *busid)
>  {
> -	char bus_type[] = "usb";

Ok.  This code was already really stupid before this patch but now it's
even more idiotic.  Just put these things things directly into the
string instead of abstracting the abastractions of the abstract
abstractions.  Sheesh.

>  	char attr_name[] = "bind";
> -	char sysfs_mntpath[SYSFS_PATH_MAX];
>  	char bind_attr_path[SYSFS_PATH_MAX];
> -	struct sysfs_attribute *bind_attr;
> -	int failed = 0;
> -	int rc, ret = -1;
> -
> -	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
> -	if (rc < 0) {
> -		err("sysfs must be mounted: %s", strerror(errno));
> -		return -1;
> -	}
> +	int rc = -1;

Don't do pointless assignments.  The compiler has builtin checks for
uninitialized variables but now you are turning the checks off and the
compiler can't do its job.

>  
>  	snprintf(bind_attr_path, sizeof(bind_attr_path), "%s/%s/%s/%s/%s/%s",
> -		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
> -		 USBIP_HOST_DRV_NAME, attr_name);
> +		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
> +		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, attr_name);
> +	dbg("bind attribute path: %s", bind_attr_path);

These dbg statements are totally pointless.  Just use strace.

>  
> -	bind_attr = sysfs_open_attribute(bind_attr_path);
> -	if (!bind_attr) {
> -		dbg("problem getting bind attribute: %s", strerror(errno));
> -		return -1;
> -	}
> -
> -	rc = sysfs_write_attribute(bind_attr, busid, SYSFS_BUS_ID_SIZE);
> +	rc = write_sysfs_attribute(bind_attr_path, busid, strlen(busid));
>  	if (rc < 0) {
> -		dbg("bind driver at %s failed", busid);
> -		failed = 1;
> +		dbg("Error binding device %s to driver: %s", busid,
> +		    strerror(errno));

The temptation here would be to change the debug statement to an on by
default print statement.  The other option would be to just remove all
the debug statements.

Etc...  For the rest of this patch.  Remove abstraction levels and dead
code.

regards,
dan carpenter

